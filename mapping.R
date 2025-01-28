# LIBRARIES
library(dplyr)
library(janitor)
library(tidyverse)
library(leaflet)
library(sf)

# Load CSO data
CSOs <- read.csv("data/ALL_CSO_DOWNLOADS.csv")

# Filter out rows with missing coordinates, if any
CSOs <- CSOs %>%
  filter(!is.na(PF_LAT) & !is.na(PF_LON))

# Load Justice 40 data
justice_40_data <- st_read("data/justice_40/usa/usa.shp")

# Filter for tracts with SN_C == TRUE
filtered_tracts <- justice_40_data %>%
  filter(SN_C == TRUE)

# Add color to the filtered tracts
filtered_tracts <- filtered_tracts %>%
  mutate(fill_color = "blue")  # Blue for SN_C == TRUE

# Create the leaflet map
leaflet() %>%
  # Add base map
  addProviderTiles(providers$CartoDB.Positron) %>%
  
  # Add CSO points
  addCircles(
    data = CSOs,
    lng = ~PF_LON,
    lat = ~PF_LAT,
    radius = 5,
    color = "red",
    fillOpacity = 0.7,
    popup = ~paste("Latitude:", PF_LAT, "<br>Longitude:", PF_LON)
  ) %>%
  
  # Add filtered census tracts
  addPolygons(
    data = filtered_tracts,
    fillColor = ~fill_color,   # Use blue for SN_C == TRUE
    color = "black",           # Black border for polygons
    weight = 0.5,              # Border thickness
    fillOpacity = 0.5,         # Transparency of the fill
  ) %>%
  
  # Center the map
  setView(lng = -95.7129, lat = 37.0902, zoom = 4)

