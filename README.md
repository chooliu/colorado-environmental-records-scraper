# Colorado Environmental Records Scraper

## About

This repository provides basic tools for scraping and parsing the Colorado Environmental Records Web Drawer ([environmentalrecords.colorado.gov/HPRMWebDrawer](http://environmentalrecords.colorado.gov/HPRMWebDrawer)).

The CER web drawer includes permit-related documents (e.g., malfunction / compliance reports, permit modifications, administrative changes) submitted to the Colorado Department of Public Health and Environment, including the Colorado Department of Public Health and Environment's Air Pollution Control Division, Water Quality Control Division, Air Quality Control Commission, Water Quality Control Commission, and Solid and Hazardous Waste Commission.

Unfortunately, as is the case with many government records portals, downloading and reading the comprehensive set of records is manually difficult and time-consuming.

As part of an ongoing project to make public records in Colorado more accessible, we provide a scraper that **systematically and reproducibly downloads all database metadata and .pdf files associated with a given AIRS ID** (Air Pollution Control Division identifier), with plans to expand to other record types in the future.

## Motivating Case

Following a controversial proposal to increase pollutant emission limits Suncor Energy USA Inc, local organizations noted poor records available to the public on the CER Web Drawer. We quickly mobilized to download and analyze the many records associated with the AIRS ID #001-0003 (395 documents, 2.85GB).

We wrote R scripts that aggregate and analyze basic information about the 395 documents in the Web Drawer (note: 3 of 395 failed to download due to "confidential" status), including summaries of the number of refinery malfunction reports ("UPSET" documents) over time and the number of malfunction reports without an specified root cause (i.e. containing the text "under investigation").

## Software Requirements

The scraper is based in Python 3/Scrapy. Scripts to parse .pdfs -> text are based in R / tabulizer. See `./scrapers/` and `./textanalysis/` for details.

## Wishlist / How To Contribute

Ideally, the CER Web Drawer would make records/metadata easily downloadable and searchable by the public.

In the mean time, we welcome contributions of:

* scrapers for new database queries (i.e., scrapers for queries other than AIRS ID)
* Python analogues scripts for .pdf -> text parsing / summaries
* in R scripts options to save text into better data structures than nested R data frames
* R and Python scripts to aggregate CER database metadata on documents (exported as multiple .txt files)
