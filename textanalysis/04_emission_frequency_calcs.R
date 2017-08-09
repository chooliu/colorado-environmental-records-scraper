# 04_emission_volume_calcs.R
# "CDPHE Malfunction Reporting Form" / template -> emission frequency estimates
# exact volumes generally aren't possible (due to "ongoing" event date)
# ========================================

# load fmt'd table for malfunctions
source("../textanalysis/03_malfunction_format_parse.R")



# search for text
searchForEmission <- function(emission_text) {
  function(x) {
    grepl(emission_text, paste( x, collapse = " "), perl = T, ignore.case = T)
  }
}

# look for mentions of specific pollutants / concerns of interest
# note: majority of VOCs, NOx not included in malfunction templates
table_filtered <-
  # table_filtered %>%
  filter(table_filtered, report_type == "UPSET") %>%
  mutate(text_flat = paste(pdf_text, collapse = " "),
         has_CO = searchForEmission(".CO.")(text_flat),
         has_HCN = searchForEmission(".HCN.|cyanide")(text_flat),
         has_H2S = searchForEmission(".H2S.")(text_flat),
         has_opacity = searchForEmission(".opacity.")(text_flat),
         has_SO2 = searchForEmission(".SO2.")(text_flat),
         has_NOx = searchForEmission(".NOx.|.nitrogen.")(text_flat),
         has_VOC = searchForEmission(".VOC.")(text_flat)) # none


# estimate number with multiple violations 
table_filtered %>% mutate(has_multiple_violations =
                            sum(has_CO, has_H2S, has_opacity, has_SO2, has_NOx, has_VOC)) %>%
  ungroup() %>%
  summarise(multiple = sum(has_multiple_violations >= 2) )

# alt multiple estimate violations calculation
# not great because will catch decimals in non-regulation based words
# (22.3 lb/h for example)

countRegexMatches <- function(text, search_term = "[0-9]\\.[0-9]") {
  length(gregexpr(search_term, text)[[1]])
}

table_filtered %>%
  mutate(num_possible_violations = countRegexMatches(condition_of_permit_regulation_or_standard_potentially_deviated_from)
           ) %>% 
  ungroup() %>%
  summarise(multiple = sum(num_possible_violations >= 2) )










library(ggplot2)

# summarize H2S
# ------------------
emission_summary <-
  table_filtered %>% 
  group_by(year, has_H2S) %>%
  summarise(count = length(report_id))
emission_summary <-
  emission_summary %>%
  arrange(has_H2S)

emission_summary
H2S_plot <- 
  ggplot(data = emission_summary, aes(x = year, y = count,
                                      lty = has_H2S, color = has_H2S)) +
  geom_point() + geom_line(aes(group = has_H2S)) + theme_classic() +
  geom_text(aes(label = count, y = count + 1, x = year + 0.1), size = 3, show.legend = F) +
  theme(legend.position = "top") +
  scale_linetype_manual(name = "H2S Mentioned in Report",
                     values = c(3, 1),
                     labels = c("no", "yes")) +
  scale_color_manual(name = "H2S Mentioned in Report",
                     values = c("#666666", "#b2182b"),
                     labels = c("no", "yes")) +
  xlab("Year") + ggtitle("") +
  ylab("Number of Malfunction Reports")
  



# summarize CO
# ------------------

emission_summary <-
  table_filtered %>% 
  group_by(year, has_CO) %>%
  summarise(count = length(report_id))
emission_summary <- rbind(emission_summary,
                          list(year = 2017, has_CO = F, count = 0),
                          list(year = 2015, has_CO = F, count = 0),
                          list(year = 2016, has_CO = F, count = 0))
emission_summary <-
  emission_summary %>%
  arrange(has_CO)
CO_plot <- 
  ggplot(data = emission_summary, aes(x = year, y = count,
                                      lty = has_CO, color = has_CO)) +
  geom_point() + geom_line(aes(group = has_CO)) + theme_classic() +
  geom_text(aes(label = count, y = count + 1, x = year + 0.1), show.legend = F) +
  theme(legend.position = "top") +
  scale_linetype_manual(name = "CO Mentioned in Report",
                        values = c(3, 1),
                        labels = c("no", "yes")) +
  scale_color_manual(name = "CO Mentioned in Report",
                     values = c("#666666", "#b2182b"),
                     labels = c("no", "yes")) +
  xlab("Year") + ggtitle("") +
  ylab("Number of Malfunction Reports")




# summarize SO2
# ------------------

emission_summary <-
  table_filtered %>% 
  group_by(year, has_SO2) %>%
  summarise(count = length(report_id))
emission_summary <-
  emission_summary %>%
  arrange(has_SO2)
SO2_plot <-
  ggplot(data = emission_summary, aes(x = year, y = count,
                                      lty = has_SO2, color = has_SO2)) +
  geom_point() + geom_line(aes(group = has_SO2)) + theme_classic() +
  geom_text(aes(label = count, y = count + 1, x = year + 0.1), show.legend = F) +
  theme(legend.position = "top") +
  scale_linetype_manual(name = "SO2 Mentioned in Report",
                        values = c(3, 1),
                        labels = c("no", "yes")) +
  scale_color_manual(name = "SO2 Mentioned in Report",
                     values = c("#666666", "#b2182b"),
                     labels = c("no", "yes")) +
  xlab("Year") + ggtitle("") +
  ylab("Number of Malfunction Reports")





# summarize opacity
# ------------------

emission_summary <-
  table_filtered %>% 
  group_by(year, has_opacity) %>%
  summarise(count = length(report_id))
emission_summary <-
  emission_summary %>%
  arrange(has_opacity)
opacity_plot <-
  ggplot(data = emission_summary, aes(x = year, y = count,
                                      lty = has_opacity, color = has_opacity)) +
  geom_point() + geom_line(aes(group = has_opacity)) + theme_classic() +
  geom_text(aes(label = count, y = count + 1, x = year + 0.1), show.legend = F) +
  theme(legend.position = "top") +
  scale_linetype_manual(name = "Opacity Mentioned in Report",
                        values = c(3, 1),
                        labels = c("no", "yes")) +
  scale_color_manual(name = "Opacity Mentioned in Report",
                     values = c("#666666", "#b2182b"),
                     labels = c("no", "yes")) +
  xlab("Year") + ggtitle("") +
  ylab("Number of Malfunction Reports")









# 
# emission_summary <-
#   table_filtered %>% 
#   group_by(year, has_NOx) %>%
#   summarise(count = length(report_id))
# emission_summary <-
#   emission_summary %>%
#   arrange(has_NOx)
# nitrogen_plot <-
#   ggplot(data = emission_summary, aes(x = year, y = count, color = has_NOx)) +
#   geom_point() + geom_line(aes(group = has_NOx)) + theme_classic() +
#   geom_text(aes(label = count, y = count + 1, x = year + 0.1), show.legend = F) +
#   theme(legend.position = "top") +
#   scale_color_manual(name = "Nitrogen Emission",
#                      values = c("#666666", "#b2182b"),
#                      labels = c("no", "yes")) +
#   xlab("Year") +
#   ylab("Malfunction Reports Containing Opacity")





library(gridExtra)
png(filename = "../output/malfunctions-by-year.png", width = 650, height = 500)
grid.arrange(CO_plot, H2S_plot, SO2_plot, opacity_plot)
dev.off()




# check if event end time marked as 'ongoing' in malfunction template reports
filter(table_filtered, report_type == "UPSET") %>%
  mutate(event_ongoing =
              grepl("ongoing|on-going", estimated_event_end_date_and_time, ignore.case = T)) %>%
  #ungroup() %>%
  group_by(year) %>%
  summarise(sum_ongoing = sum(event_ongoing),
            total = length(event_ongoing), 
            proportion_ongoing = sum_ongoing / total)
