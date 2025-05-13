#GNIS_data


#Read GNIS data

GNIS_assessments <- openxlsx::read.xlsx("C:/Users/tpritch/OneDrive - Oregon/DEQ - Integrated Report - IR 2024/Final List/IR_2024_Rollup-post_public_comment.xlsx",
                                        sheet = 'GNIS_decisions')


save(GNIS_assessments, file = "data/GNIS_Assessments.Rdata")



# map_display_data --------------------------------------------------------


map_display <- openxlsx::read.xlsx("C:/Users/tpritch/OneDrive - Oregon/DEQ - Integrated Report - IR 2024/Final List/IR_2024_Rollup-post_public_comment.xlsx",
                                        sheet = 'map_display')

save(map_display, file = "data/map_display.Rdata")



# map display GNIS --------------------------------------------------------


map_display_GNIS <- openxlsx::read.xlsx("C:/Users/tpritch/OneDrive - Oregon/DEQ - Integrated Report - IR 2024/Final List/IR_2024_Rollup-post_public_comment.xlsx",
                                   sheet = 'map_display_GNIS')

save(map_display_GNIS, file = "data/map_display_GNIS.Rdata")
