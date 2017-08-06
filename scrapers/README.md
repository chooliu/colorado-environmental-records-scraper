This web scraper uses [scrapy](https://scrapy.org/) to download Suncor related files from the [Colorado Environmental Records](http://environmentalrecords.colorado.gov/HPRMWebDrawer/Record) website. To get started, run `pip install -r requirements.txt` in the project root directory which will install all `scrapy` dependencies.

At the moment, the only configuration needed is to change the `save_path` variable in `cers/spiders/cers_suncor.py` to the directory you want to save the pdfs in. After that, the scrapy can be run by calling `scrapy crawl sun_corp`. 
