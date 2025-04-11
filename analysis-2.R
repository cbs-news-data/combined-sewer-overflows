# Load necessary libraries
library(dplyr)
library(sf)

# Read the full shapefile with all census tracts
all_tracts <- st_read("data/justice_40/usa/usa.shp") %>%
  select(SF, SN_C)  # SF = tract ID, SN_C = disadvantaged flag (1 or 0)

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

points_with_tracts <- st_join(CSOs_sf, all_tracts, join = st_within)

# Remove any without a matched tract
points_with_tracts <- points_with_tracts %>% filter(!is.na(SF))

# Disadvantaged tracts with at least one CSO
disadvantaged_tracts_with_CSOs <- points_with_tracts %>%
  filter(SN_C == 1)

# Not disadvantaged tracts with at least one CSO
not_disadvantaged_tracts_with_CSOs <- points_with_tracts %>%
  filter(SN_C == 0 | is.na(SN_C))

# Count tracts with at least one CSO
num_disadv_with_CSOs <- nrow(disadvantaged_tracts_with_CSOs)
num_not_disadv_with_CSOs <- nrow(not_disadvantaged_tracts_with_CSOs)

# Total tracts by type
total_disadv <- sum(all_tracts$SN_C == 1)
total_not_disadv <- sum(all_tracts$SN_C == 0 | is.na(all_tracts$SN_C))

# Rates
rate_disadv <- num_disadv_with_CSOs / total_disadv
rate_not_disadv <- num_not_disadv_with_CSOs / total_not_disadv

# Calculations
times_more_likely <- rate_disadv / rate_not_disadv
percent_more_likely <- ((rate_disadv - rate_not_disadv) / rate_not_disadv) * 100

# Output
cat("Disadvantaged tracts with CSO:", num_disadv_with_CSOs, "\n")
cat("Other tracts with CSO:", num_not_disadv_with_CSOs, "\n")
cat("Rate (disadvantaged):", round(rate_disadv, 4), "\n")
cat("Rate (not disadvantaged):", round(rate_not_disadv, 4), "\n")
cat("Disadvantaged tracts are", round(times_more_likely, 2), "times more likely to have a CSO.\n")
cat("That’s", round(percent_more_likely), "% more likely.\n")