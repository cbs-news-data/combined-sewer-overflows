# LIBRARIES
library(dplyr)
library(sf)

# ANALYSIS
# Read in CSO data and convert to sf object
CSOs <- read.csv("data/ALL_CSO_DOWNLOADS.csv") %>% filter(!is.na(PF_LON) &
                                                            !is.na(PF_LAT))  %>% filter(PERMITTING_STATE != "PR") %>% select(
                                                              FACILITY_NAME,
                                                              LOCATION_ADDRESS,
                                                              FACILITY_CITY,
                                                              STATE_CODE,
                                                              PERMIT_DESIGN_FLOW,
                                                              PERMIT_AVG_FLOW,
                                                              PF_LAT,
                                                              PF_LON
                                                            )
CSOs_sf <- st_as_sf(CSOs, coords = c("PF_LON", "PF_LAT"), crs = 4326)

# Read the shapefile and filter for SN_C == TRUE (means tract is disadvantaged)
justice_40_data <- st_read("data/justice_40/usa/usa.shp")
justice_40_data <- justice_40_data %>%
  filter(SN_C == 1 ) %>% select(SF, SN_C)

# Perform spatial join to check which points are in the filtered tracts
points_in_tracts <- st_join(CSOs_sf, justice_40_data, join = st_within)

# Count the number of points that fall within SN_C == TRUE tracts
num_points_in_tracts <- points_in_tracts %>%
  filter(!is.na(SN_C)) %>%  # Keep only points within tracts
  nrow()

###################

# FOR FINDING AVERAGE
# Total average flow nationally
CSOs <- CSOs %>% filter(FACILITY_CITY == "CHICAGO")
CSOs$PERMIT_AVG_FLOW <- as.numeric(CSOs$PERMIT_AVG_FLOW)

mean_flow <- mean(CSOs$PERMIT_AVG_FLOW, na.rm = TRUE)  # na.rm = TRUE excludes NA values

