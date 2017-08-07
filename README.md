# Colorado Environmental Records Scraper

## About

This repository provides basic tools for scraping and parsing the Colorado Environmental Records Web Drawer ([environmentalrecords.colorado.gov/HPRMWebDrawer](http://environmentalrecords.colorado.gov/HPRMWebDrawer)).

The CER web drawer includes permit-related documents (e.g., malfunction / compliance reports, permit modifications, administrative changes) submitted to the Colorado Department of Public Health and Environment, including the Colorado Department of Public Health and Environment's Air Pollution Control Division, Water Quality Control Division, Air Quality Control Commission, Water Quality Control Commission, and Solid and Hazardous Waste Commission.

Unfortunately, as is the case with many government records portals, downloading and reading the comprehensive set of records is manually difficult and time-consuming.

As part of an ongoing project to make public records in Colorado more accessible, we provide a scraper that **systematically and reproducibly downloads all database metadata and .pdf files associated with a given AIRS ID** (Air Pollution Control Division identifier), with plans to expand to other record types in the future.

## Motivating Case

Following a controversial proposal by Suncor Energy USA Inc to increase its pollutant emission limits, local organizations noted poor record keeping available to the public on the CER Web Drawer. We quickly mobilized to download and analyze the many records associated with the AIRS ID #001-0003 (395 documents, 2.85GB).

We also wrote R scripts that aggregate and analyze the documents' metadata and text (note: 3 of 395 failed to download due to "confidential" status), including summaries of the number of refinery malfunction reports ("UPSET" documents) over time and the number of malfunction reports without an specified root cause (i.e. containing the text "under investigation").

## Navigation

* `./scrapers/` : download the CER Web Drawer documents and metadata. (requirements: Python 3, scrapy)
* `./textanalysis/` : scripts to parse and summarize .pdfs (requirements: R, tabulizer, tinyverse)

## Wishlist / How To Contribute

* scrapers for new database queries (i.e., scrapers for queries other than AIRS ID)
* Python analogues scripts for .pdf -> text parsing / summaries
* in R scripts, save text of tables in .pdfs into better data structures than nested R data frames
* R and Python scripts to aggregate CER database metadata on documents (currently exported as multiple .txt files)
