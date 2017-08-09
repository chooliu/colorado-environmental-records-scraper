# 03_malfunction_format_parse.R
# in contrast to 02_simple_text_summaries.R, the below
# parsing specific to "CDPHE Malfunction Reporting Form" tables
# (standardized fmt needed as we attempt to extract specific items)
# ========================================

# from 01_import_pdfs.R
load("table.Rdata")

library(tabulizer)
library(dplyr)
library(tidyr)


table_filtered <- 
  table %>%
  rowwise() %>%
  filter(!is.null(pdf_text)) %>%
  rowwise() %>%
  filter(!is.na(pdf_text[[1]])) %>%
  filter(., grepl("UPSET", report_type, ignore.case = T))
#  filter(., report_type == "UPSET")

# ^ change comment here based on inclusion of UPSET-RPT / UPSET-PLANT-1, or not




# assumes the table extracted from pdf
# has the search_term (e.g., "Suncor Representative") in first column
generatorFuzzyRegex <- function(search_term) {
  function(table_from_pdf) {
    
    # table_from_pdf <- table_from_pdf[[1]]
    index <- agrep(search_term, table_from_pdf,
                   ignore.case = T, max.distance = 0.03)
    if (ncol(table_from_pdf) == 1) {
      output <- table_from_pdf[index]
    } else {
      output <- table_from_pdf[index + nrow(table_from_pdf)]
    }
    
    if (length(output) == 0) {
      output <- NA
    }
    
    if (length(output) >= 2) {
      output <- paste(output, collapse = " ")
    }
    
    gsub(search_term, "", output, ignore.case = T)
    
    }
}




# 
# table_filtered <-
#   table_filtered %>% 
#   mutate(suncor_representative =
#            generatorFuzzyRegex("Suncor Representative ")(pdf_text),
#          date_of_email_notification =
#            generatorFuzzyRegex("Date of E-mail Notification ")(pdf_text),
#          time_of_email_notification =
#            generatorFuzzyRegex("Time of E-mail Notification ")(pdf_text),
#          estimated_event_start_date_and_time =
#            generatorFuzzyRegex("Estimated Event Start Date and Time ")(pdf_text),
#          estimated_event_end_date_and_time =
#            generatorFuzzyRegex("Estimated Event End Date and Time ")(pdf_text),
#          operating_permit_no =
#            generatorFuzzyRegex("Operating Permit No. ")(pdf_text),
#          airs_id_no =
#            generatorFuzzyRegex("AIRS ID No. ")(pdf_text),
#          condition_of_permit_regulation_or_standard_potentially_deviated_from =
#            paste0(
#              generatorFuzzyRegex("Condition of Permit, Regulation, or")(pdf_text),
#              generatorFuzzyRegex("Standard Potentially Deviated From")(pdf_text),
#              generatorFuzzyRegex("(e.g., Condition 25.1)")(pdf_text)),
#          estimated_numeric_value_of_deviation =
#            paste0(
#              generatorFuzzyRegex("Estimated Numeric Value of Deviation")(pdf_text),
#              generatorFuzzyRegex("(e.g., ppm, ppmc lb/hr, etc.)")(pdf_text)),
#          information_regarding_cause_of_deviation =
#            paste0(
#              generatorFuzzyRegex("Information Regarding")(pdf_text),
#              generatorFuzzyRegex("Cause of Deviation")(pdf_text))
#          )







# grab text sandwiched between two search_terms
# works better than generatorFuzzyRegex() 
generatorFuzzyRegexRANGE <- function(search_term_start, search_term_end, inclusive = F) {
  
  function(table_from_pdf) {
    
    if (inclusive == T) {
      inclusive <- 0
    } else {
      inclusive <- 1
      }
    
    index_start <- agrep(search_term_start, table_from_pdf,
                         ignore.case = T, max.distance = 0.03) + inclusive
    index_end <- 
      unlist(
        sapply(search_term_end, function(x) {
          agrep(x, table_from_pdf, ignore.case = T, max.distance = 0.03, fixed = F) })
      )
    
    if (length(index_start) == 0 | length(index_end) == 0) {
      return(NA)
    } else {
      index_end <- max( index_end ) - inclusive
    }
    
    if (ncol(table_from_pdf) == 1) {
      output <- table_from_pdf[index_start:index_end]
    } else {
      output <- table_from_pdf[index_start:index_end + nrow(table_from_pdf)]
    }
    
    if (length(output) == 0) {
      output <- NA
    }
    
    if (length(output) >= 2) {
      output <- paste(output, collapse = " ")
    }
    
    gsub(paste(c(search_term_start, search_term_end, "NA"), collapse = "|"),
         "", output, ignore.case = T)
  }
}




# run field extraction fxns
# --------------------------------------------------

# grab first few fields with "simple" generatorFuzzyRegex
table_filtered <-
  table_filtered %>% 
  mutate(suncor_representative =
           generatorFuzzyRegex("Suncor Representative ")(pdf_text),
         date_of_email_notification =
           generatorFuzzyRegex("Date of E-mail Notification ")(pdf_text),
         time_of_email_notification =
           generatorFuzzyRegex("Time of E-mail Notification ")(pdf_text),
         estimated_event_start_date_and_time =
           generatorFuzzyRegex("Estimated Event Start Date and Time ")(pdf_text),
         estimated_event_end_date_and_time =
           generatorFuzzyRegex("Estimated Event End Date and Time ")(pdf_text),
         operating_permit_no =
           generatorFuzzyRegex("Operating Permit No. ")(pdf_text),
         airs_id_no =
           generatorFuzzyRegex("AIRS ID No. ")(pdf_text))


# fields with more free text get a little difficult and need generatorFuzzyRegexRANGE()
# table parsing messier cells that aren't upper-left justified 
table_filtered <-
  table_filtered %>% 
  mutate(
         condition_of_permit_regulation_or_standard_potentially_deviated_from =
             generatorFuzzyRegexRANGE("AIRS ID No. ",
                                      c("Estimated Numeric Value of Deviation", "Estimated Maximum Numeric Value"))(
                                          pdf_text),
         estimated_numeric_value_of_deviation =
           generatorFuzzyRegexRANGE("(e.g., Condition 25.1)",
                                    c("Information Regarding", "Information Regarding Cause of Deviation"))(
                                        pdf_text),
         information_regarding_cause_of_deviation =
           generatorFuzzyRegexRANGE("Information Regarding",
                                    c("b", "Cause of Deviation"),
                                    inclusive = T)(pdf_text))




# small function to display results error checking
displayTextFieldsForRowNum <- function(rownum) {
  tmp <- table_filtered[rownum, -(1:5)]
  print(table_filtered$report_id[rownum])
  print(
    data.frame(variable_names = names(tmp),
               text_result = as.character(tmp)),
    width = 500)
}

displayTextFieldsForRowNum(1)
