import os.path
from urllib.parse import urljoin
from scrapy.http import Request
import scrapy

class CersScraper(scrapy.Spider):
    name = 'cers_scraper'
    save_path = ''
    records_url = 'http://environmentalrecords.colorado.gov/HPRMWebDrawer/Record?q=AIRSIDAPI%3AAIRS_ID&sortBy=&pageSize=10000'
    metadata_url = 'http://environmentalrecords.colorado.gov/HPRMWebDrawer/Record/'

    def __init__(self, save_path='', airs_id='', *args, **kwargs):
        super(CersScraper, self).__init__(*args, **kwargs)

        if not save_path:
            raise ValueError("save_path is required.")
        
        if not airs_id:
            raise ValueError("airs_id is required.")

        if not os.path.isdir(save_path):
            os.makedirs(save_path)
            
        self.save_path = save_path
        self.records_url = self.records_url.replace("AIRS_ID", airs_id)
                   
    def start_requests(self):
        urls = [self.records_url,]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        for table_row in response.css('table.trim-list.search-results tbody tr'):
            record_number = table_row.css('::attr(trim-uri)').extract_first()
            prop_val = table_row.css('.prop-val::text').extract()
            date = table_row.css('.nowrap::text').extract_first()
            date_formatted = date.split(' ')[0].replace('/', '-')
            file_name = '{}_{}_{}'.format(prop_val[0], date_formatted, prop_val[2])
            file_name = os.path.join(self.save_path, file_name).replace(' ', '-')
            href_pdf = table_row.css('a::attr(href)').extract_first()
            href_metadata = urljoin(self.metadata_url, record_number)

            # create request for pdf
            request_pdf = Request(
                url=response.urljoin(href_pdf),
                callback=self.save_pdf
            )

            pdf_file_name = file_name + ".pdf"
            request_pdf.meta['file_name'] = pdf_file_name
            if not os.path.isfile(pdf_file_name):
                yield request_pdf

            # create request for metadata file
            request_metadata = Request(
                url=href_metadata,
                callback=self.save_metadata
            )

            metadata_file_name = file_name + ".txt"
            request_metadata.meta['file_name'] = metadata_file_name
            if not os.path.isfile(metadata_file_name):
                yield request_metadata

    def save_metadata(self, response):
        """save file metadata to a separate text file
        """
        container = response.css("#fieldGroupCollapse-rec_identification div.accordion-inner div.form-horizontal div.control-group")

        with open(response.meta['file_name'], 'w') as file:
            for group in container:
                file.write(group.css("label::text").extract_first() + '\t' + group.css("div.controls span::text").extract_first() + '\n')

    def save_pdf(self, response):
        """save pdf copy of document
        """
        with open(response.meta['file_name'], 'wb') as file:
            file.write(response.body)
