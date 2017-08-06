from scrapy.cmdline import execute
import os

os.chdir('C:/Projects/colorado-environmental-records-scraper/cers/cers/spiders/')
execute(['scrapy', 'crawl', 'cers_suncor'])