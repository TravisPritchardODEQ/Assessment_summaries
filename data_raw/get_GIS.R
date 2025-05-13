
# Download GIS layers -----------------------------------------------------
#This needs to be done since the ESRI rest server seems to stop returning data
# after about 250 requests. Probably an anti DOS attck vector, but it means
# we need to bring in the data locally. This process will ensuure the mapping
# is consistent with the online map



# Map Linear --------------------------------------------------------------


url <- parse_url("https://services.arcgis.com/uUvqNMGPm7axC2dD/ArcGIS/rest/services")

url$path <- paste(url$path, "IR_2024_StateFinal/FeatureServer/4/query", sep = "/")

url$query <- list(where =  paste0("year_last_assessed > 1"),
                  outFields = "*",
                  returnGeometry = "true",
                  f = "geojson")


request <- build_url(url)


river_stream_GIS <- st_read(request)


# Map watershed -----------------------------------------------------------



url <- parse_url("https://services.arcgis.com/uUvqNMGPm7axC2dD/ArcGIS/rest/services")

url$path <- paste(url$path, "IR_2024_StateFinal/FeatureServer/7/query", sep = "/")

url$query <- list(where =  paste0("year_last_assessed > 1"),
                  outFields = "*",
                  returnGeometry = "true",
                  f = "geojson")


request <- build_url(url)


watershed_GIS <- st_read(request)


save(river_stream_GIS, watershed_GIS, file = 'GIS_layers.RData')


# GNIS --------------------------------------------------------------------



url <- parse_url("https://services.arcgis.com/uUvqNMGPm7axC2dD/ArcGIS/rest/services")

url$path <- paste(url$path, "IR_2024_StateFinal/FeatureServer/6/query", sep = "/")
url$query <- list(where =  paste0("OBJECTID_1  >= -9999"),
                  outFields = "*",
                  returnGeometry = "true",
                  f = "geojson")

request <- build_url(url)



requested_AU_GNIS <- st_read(request)


# Waterbody  --------------------------------------------------------------



url <- parse_url("https://services.arcgis.com/uUvqNMGPm7axC2dD/ArcGIS/rest/services")

url$path <- paste(url$path, "IR_2024_StateFinal/FeatureServer/5/query", sep = "/")

url$query <- list(where =  paste0("AU_ID like 'OR_LK%'"),
                  outFields = "*",
                  returnGeometry = "true",
                  f = "geojson")


request <- build_url(url)

lentic_GIS_Lake <- st_read(request)

url <- parse_url("https://services.arcgis.com/uUvqNMGPm7axC2dD/ArcGIS/rest/services")



load('data/AU_all_rollup_display.Rdata')

esturay <- AU_all_rollup_display |>
  filter(str_detect(AU_ID, "EB")) |>
  pull(AU_ID)


get_esturary <- function(x){


  url <- parse_url("https://services.arcgis.com/uUvqNMGPm7axC2dD/ArcGIS/rest/services")

  url$path <- paste(url$path, "IR_2024_StateFinal/FeatureServer/5/query", sep = "/")
  url$query <- list(where = paste0("AU_ID= '", x, "'"),
                    outFields = "*",
                    returnGeometry = "true",
                    f = "geojson")


  request <- build_url(url)

  lentic_GIS_EB <- st_read(request) |>
    select(AU_ID, AU_Name, AU_status, Cat_4_parameters, Cat_5_parameters,
           Attaining_parameters, Insufficient_parameters)




}


EB <- map_df(esturay,get_esturary )
Lentic_GIS_EB <- EB


lentic_GIS_OC <- lentic_GIS_OC |>
  select(AU_ID, AU_Name, AU_status, Cat_4_parameters, Cat_5_parameters,
         Attaining_parameters, Insufficient_parameters)
lentic_GIS_Lake <- lentic_GIS_Lake |>
  select(AU_ID, AU_Name, AU_status, Cat_4_parameters, Cat_5_parameters,
         Attaining_parameters, Insufficient_parameters)

lentic_GIS <- bind_rows(lentic_GIS_OC, lentic_GIS_Lake, Lentic_GIS_EB)



load('GIS_layers.RData')
GNIS_GIS <- requested_AU_GNIS
save(river_stream_GIS, watershed_GIS,lentic_GIS, GNIS_GIS,  file = 'data/GIS_layers.RData')
