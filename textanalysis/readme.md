R scripts to perform basic text extraction / summarize date and report-types from the .pdfs downloaded from Scrapy.
Scripts tested with AIRS ID 100-0003 on 6 August 2017.

* Java jdk1.8.0_131.jdk
* R version 3.4.0 (2017-04-21)
* Platform: x86_64-apple-darwin15.6.0 (64-bit)

Key R libraries*:
* lubridate_1.6.0
* tidyr_0.6.3
* dplyr_0.7.1
* tabulizer_0.1.24
* rJava_0.9-8

\* Note: The most challenging dependencies to tackle first are [rJava](https://cran.r-project.org/web/packages/rJava/index.html)
& [tabulizer](https://github.com/ropensci/tabulizer).
