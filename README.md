# Combined Sewer Overflows Project

Code and analysis for CBS NEWS STORY LINK.

## Overview

This project supports a CBS News investigation into combined sewer overflows (CSOs) and their impacts on disadvantaged communities in the U.S. It includes data processing, analysis, and a MapLibre visualization of outfalls and affected areas.

## Data

All source data is stored in the data/ folder. Where possible, files are preserved in their original form and filenames.
- ALL_CSO_DOWNLOADS.csv: Raw EPA data on all combined sewer outfall (CSO) locations.
- cso-locations.geojson: Cleaned and mapped version of the raw CSO dataset.
- NEW_J40.geojson: GeoJSON file of Justice40-designated disadvantaged communities.
- states.geojson: U.S. states geometries for mapping.
- justice_40/: Original files and intermediate outputs used to generate the J40 dataset.

## R Scripts

- analysis.R: Main script to process and join CSO data with Justice40 areas.
- analysis-2.R: Secondary or experimental analysis for deeper statistical comparisons.

## Visualization
- index.html: Loads the interactive MapLibre map.

## Outputs

The output/ directory contains processed data used for the story and visualization:
	•	for-chance.csv: Dataset created for TV gfx visualization development.
	•	poverty-data.csv: Poverty-level analysis results used in story context.


## Contact

Please contact Taylor Johnston at taylor.johnston@cbsnews.com for any questions. 
