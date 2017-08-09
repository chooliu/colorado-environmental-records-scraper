# 02_simple_text_summaries.R
# basic summaries on date, .pdf word content
# ========================================

# from 01_import_pdfs.R
load("table.Rdata")

library(tabulizer)
library(dplyr)
library(tidyr)
library(lubridate)



# optional: remove documents that weren't detected to have tables 
# --------------------------------------------

table_filtered <- 
  table %>%
  rowwise() %>%
  filter(!is.null(pdf_text)) %>%
  rowwise() %>%
  filter(!is.na(pdf_text[[1]]))





# look for keywords in text
# --------------------------------------------

# summarize COUNT of "upset" reports (malfunctions) with a keyword ("invest")
# change commented out lines option to grepl or exact-match "UPSET"
table_filtered %>% 
  # filter(., grepl("upset", report_type, ignore.case = T, perl = T)) %>%
  filter(., report_type == "UPSET") %>%
  mutate(under_invest = grepl(".invest.", paste( pdf_text, collapse = " "), perl = T)) %>%
  group_by(year) %>%
  summarize(number_under_investigation = sum(under_invest),
            total_num = length(under_invest),
            percent_under_invest = number_under_investigation / total_num)

# print text of "upset" reports containing keyword ("invest")
table_filtered %>% 
  rowwise() %>%
  filter(., report_type == "UPSET") %>%
  mutate(under_invest = grepl(".invest.", paste( pdf_text, collapse = " "), perl = T)) %>%
  filter(., under_invest == T) %>%
  .$pdf_text




# summarize trends by year
# --------------------------------------------

# table of report_type x day
count_by_date <-
  table %>%
  group_by(date, report_type) %>%
  summarize(count = length(report_id))

# table of report_type x year
count_by_rpttype_year <-
  table %>%
  #filter(., grepl("upset", report_type, ignore.case = T, perl = T)) %>%
  group_by(year, report_type) %>%
  summarize(count = length(report_id))


# clumsy reshape for rpt_type x year table 
library(reshape2)
tbl <- dcast(report_type ~ year, data = count_by_rpttype_year, fill = 0)
# rownames(tbl) <- tbl[ , 1]
# tbl <- tbl[ , -1]
# tbl <- as.numeric(tbl, dim(tbl))
# tbl[ rowSums(tbl) > 3, ]


# three files were not downloadable (confidential for AIRS #100-0003)
# manually add details to count_by_date 
count_by_date <-
  bind_rows(
    count_by_date,
    tibble(
      date = as_date(c("12/30/2015", "05/11/2016"), "%m/%d/%Y"), 
      report_type = c("2015 INSP RPT", "2015 INSP RPT SUPP DOCS"),
      count = c(2, 1)
))

count_by_date <- count_by_date[order(count_by_date$date), ]


# subset "UPSET" reports
upsets <- filter(count_by_date, grepl("UPSET", report_type))

# artificial date column to calculate difference
upsets$date2 <- c(upsets$date[1], upsets$date[-length(upsets$date)])


# summarize the time between upset reports in given date range
summaryTimeUpsets <- function(datestart, dateend) {
  tmp <- filter(upsets, date >= datestart & date <= dateend) %>%
    mutate(diff = difftime(date, date2, units = "days"))
  c(mean = mean(tmp$diff),
    median = median(tmp$diff))
}

summaryTimeUpsets("2015-01-01", "2015-12-31")
summaryTimeUpsets("2016-01-01", "2016-12-31")
summaryTimeUpsets("2017-01-01", "2017-12-31")


