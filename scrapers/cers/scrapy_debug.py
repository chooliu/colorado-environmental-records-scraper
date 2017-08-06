from scrapy.cmdline import execute
import os

os.chdir('C:/Projects/colorado-environmental-records-scraper/scrapers/cers/spiders/')
execute(['scrapy', 'crawl', 'cers_scraper', '-a', 'save_path=C:/Users/andys/Desktop/cers_suncorp', '-a', 'airs_id=001-0003'])