#This script will take all the assessed AUs and generate a assessment summary for each one.


library(tidyverse)
library(progressr)
options(dplyr.summarise.inform = FALSE)
load('data/AU_all_rollup_display.Rdata')
load('data/GIS_layers.RData')

assessed_AUs <- AU_all_rollup_display %>%
  pull(AU_ID) %>%
  unique()




# Testing units
# assessed_AUs <- c('OR_WS_170900100401_02_104506', 'OR_WS_170900100202_02_104493',
#                   'OR_SR_1709000902_02_104073', 'OR_SR_1709000906_02_104091',
#                   'OR_LK_1709000603_02_100771', 'OR_LK_1708000105_11_100637')


renderdocs <- function(x){
  rmarkdown::render('Assessment_Summary_IR22.Rmd', params = list(AU_ID =x),
                    output_file = paste('C:/Users/tpritch/OneDrive - Oregon/DEQ - Integrated Report - IR 2024/Assessment Summaries/2024_IR_Assessment_Unit_report-', x,
                                        '.html', sep=''), quiet	 = TRUE)

}
#
# start.time <- Sys.time()
# #Run the code
# assessed_AUs |> map(renderdocs)
#
# end.time <- Sys.time()
# time.taken <- end.time - start.time
# time.taken
#
#
#
# start.time <- Sys.time()
# #Run the code
# assessed_AUs |> furrr::future_map(renderdocs,
#                                   .progress = TRUE)


start.time <- Sys.time()

parallel_render <- function(x) {
  p <- progressor(steps = length(assessed_AUs))

  furrr::future_map(x, ~{
    p()
    renderdocs(.x)
  })

}


with_progress({
  parallel_render(assessed_AUs)
  })

end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken


