# 01_import_pdfs.R
# simple tabulizer import / .pdf title -> metadata
# ========================================


library(tabulizer)
library(dplyr)
library(tidyr)
library(lubridate)



# location of .pdfs scraped from CER 
file_path <- "/Users/choo/Dropbox/suncor"
table <- tibble(
  pdf_names = list.files(file_path, pattern = "*pdf", full = T)
  )

# import .pdf -> text / table
# commented out line prevents free-form text import (tables only)
extract_attempt <- function(file) {
  output <- extract_tables(file)
  if (length(output) != 1) {
    print( paste0("No table found in ", file, ".") )
    output <- NA
    # alternative: output <- extract_text(file)
  }
  return(output)
}

# run extraction
table <-
  table %>%
  rowwise() %>%
  mutate(pdf_text = extract_attempt(pdf_names))

# file name --> date metadata
table <-
  table %>%
  mutate(pdf_names = gsub(file_path, "", pdf_names)) %>%
  separate(pdf_names, into = c("report_type", "date", "report_id"),
           sep = "_", remove = T) %>%
  mutate(report_id = gsub(".pdf", "", report_id, perl = T))

# date format manipulation from lubridate
table$date <- as_date(table$date, "%m-%d-%Y")
table$year <- year(table$date)




# line 28 time consuming, so recommend saving via save(table, file = "table.Rdata")
# then grabbing table via load("table.Rdata")


