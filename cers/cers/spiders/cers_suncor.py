from datetime import datetime
from urllib.parse import urljoin
from scrapy.http import Request
import os.path

import scrapy

class CersSuncor(scrapy.Spider):
    name = 'cers_suncor'
    save_path = 'C:/Users/andys/Desktop/cers_suncor'

    if not os.path.isdir(save_path):
        os.makedirs(save_path)

    def start_requests(self):
        urls = ['http://environmentalrecords.colorado.gov/HPRMWebDrawer/Record?q=AIRSIDAPI%3A+001-0003%2BAnd%2B%28recOwner%3D9%2BOr%2BrecOwner%3D1723%2BOr%2BrecOwner%3D1322%2BOr%2BrecOwner%3D1028%2BOr%2BrecOwner%3D1321%29&sortBy=&pageSize=10000',]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        for table_row in response.css('table.trim-list.search-results tbody tr'):
            prop_val = table_row.css('.prop-val::text').extract()
            date = table_row.css('.nowrap::text').extract_first()
            date_formatted = date.split(' ')[0].replace('/', '-')
            file_name = '{}_{}_{}.pdf'.format(prop_val[0], date_formatted, prop_val[2])
            file_name = os.path.join(self.save_path, file_name).replace(' ', '_')
            href = table_row.css('a::attr(href)').extract_first()

            request = Request(
                url=response.urljoin(href),
                callback=self.save_pdf
            )

            request.meta['file_name'] = file_name         
            if not os.path.isfile(file_name):
                yield request

    def save_pdf(self, response):
        with open(response.meta['file_name'], 'wb') as file:
            file.write(response.body)
