# Colorado Environmental Records Scraper

## About

This repository provides basic tools for scraping and parsing the Colorado Environmental Records Web Drawer ([environmentalrecords.colorado.gov/HPRMWebDrawer](http://environmentalrecords.colorado.gov/HPRMWebDrawer)).

The CER web drawer includes permit-related documents (e.g., malfunction / compliance reports, permit modifications, administrative changes) submitted to the Colorado Department of Public Health and Environment, including the Colorado Department of Public Health and Environment's Air Pollution Control Division, Water Quality Control Division, Air Quality Control Commission, Water Quality Control Commission, and Solid and Hazardous Waste Commission.

Unfortunately--as is the case with many government records portals--downloading and reading the comprehensive set of records is manually difficult and time-consuming.

As part of an ongoing project to make public records in Colorado more accessible / in analysis-ready formats (see [chooliu/colorado-open-data-list](https://github.com/chooliu/colorado-open-data-list)), we provide a scraper that **systematically and reproducibly downloads all CER Web Drawer metadata and .pdf files associated with a given AIRS ID** (Air Pollution Control Division identifier), with plans to expand to other record types in the future.

## Motivating Case

We began work on this repo following a controversial proposal by Suncor Energy USA Inc to increase its pollutant emission limits, despite a long history of permit violations & allegations of poor record keeping. We quickly mobilized to download records associated with the AIRS ID # 001-0003 (395 documents, 2.85GB; note: 3 of 395 failed to download due to "confidential" status) and assess data transparency.

The metadata and text within .pdfs were parsed in R with the goal of summarizing and visualizing longitudinal trends in refinery malfunctions and pollutant emissions reported. We also quantified transparency / reporting issues (e.g., malfunction reports with no specified root cause / were "under investigation").

**More generally, our goal is to increase the accessibility of environmental data to the public.**

## Navigation

* `./scrapers/` : download the CER Web Drawer documents and metadata. (requirements: Python 3, scrapy)
* `./textanalysis/` : scripts to parse and summarize .pdfs (requirements: R, tabulizer, tinyverse)

## Wishlist / How To Contribute

We welcome any critiques or contributions.

* scrapers for new database queries (i.e., scrapers for queries other than AIRS ID)
* save text of tables in .pdfs into better data structures (e.g., in current R scripts, tabular pdfs were saved as a data frame / list of matrices) -- ideally database/tabular formats that can be readily shared with people with less technical background
* scripts for parsing different document templates (only malfunction reporting template implemented)
* Python analogues for .pdf -> text parsing & summaries
* R and Python scripts to aggregate CER database metadata on documents (currently exported as multiple .txt files)
