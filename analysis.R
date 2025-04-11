# Load necessary libraries
library(dplyr)
library(sf)

# Read in CSO data and convert to sf object
CSOs <- read.csv("data/ALL_CSO_DOWNLOADS.csv") %>%
  filter(!is.na(PF_LON) & !is.na(PF_LAT)) %>%
  filter(PERMITTING_STATE != "PR") %>%
  select(
    FACILITY_NAME,
    LOCATION_ADDRESS,
    FACILITY_CITY,
    STATE_CODE,
    PERMIT_DESIGN_FLOW,
    PERMIT_AVG_FLOW,
    PF_LAT,
    PF_LON
  )

# Convert to sf object
CSOs_sf <- st_as_sf(CSOs, coords = c("PF_LON", "PF_LAT"), crs = 4326)

# Read the shapefile and filter for SN_C == TRUE (disadvantaged tracts)
justice_40_data <- st_read("data/justice_40/usa/usa.shp")
justice_40_data <- justice_40_data %>%
  filter(SN_C == 1) %>%
  select(SF, SN_C)

# Perform spatial join to check which points are in the filtered tracts
points_in_tracts <- st_join(CSOs_sf, justice_40_data, join = st_within)

# Count the number of points that fall within disadvantaged tracts
num_points_in_tracts <- points_in_tracts %>%
  filter(!is.na(SN_C)) %>%
  nrow()

# Save output
write.csv(points_in_tracts, "output/for-chance.csv")

# Count total census tracts in the dataset
total_tracts <- nrow(st_read("data/justice_40/usa/usa.shp"))  # Read full dataset

# Count disadvantaged census tracts
disadvantaged_tracts <- nrow(justice_40_data)

# Calculate percentage of disadvantaged tracts
percent_disadvantaged <- (disadvantaged_tracts / total_tracts) * 100

# Print results
cat("Total census tracts:", total_tracts, "\n")
cat("Disadvantaged census tracts:", disadvantaged_tracts, "\n")
cat("Percentage of census tracts that are disadvantaged:", round(percent_disadvantaged, 2), "%\n")

# Analysis for Chicago-specific data
CSOs_chicago <- CSOs %>%
  filter(FACILITY_CITY == "CHICAGO")

CSOs_chicago$PERMIT_AVG_FLOW <- as.numeric(CSOs_chicago$PERMIT_AVG_FLOW)

# Calculate mean flow
mean_flow <- mean(CSOs_chicago$PERMIT_AVG_FLOW, na.rm = TRUE)

# Print mean flow
cat("Mean permit average flow for Chicago:", round(mean_flow, 2), "\n")