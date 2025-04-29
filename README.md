# NOAA_Storm_Analysis_2024
In-Depth Analysis of NOAA Storm Events for 2024: Health, Geography, and Seasonality

## Overview
This repository contains an analysis of the 2024 NOAA Storm Events database, focused on impacts to population health, geographic distribution, seasonality, and economic property damage. The final deliverables include:

- **`storm_analysis.R`**: Standalone R script with all data processing and plotting code.
- **`NOAA_Storm_Project.Rmd`**: R Markdown document combining code, visualizations, and in-depth narrative analysis.
- **`README.md`**: Project overview and instructions (this file).

The analysis is designed for reproducibility and can be published to RPubs as a demonstration of data analytics proficiency.

---

## Prerequisites
- **R** (version ≥ 4.0)
- **R packages**: `dplyr`, `readr`, `ggplot2`, `lubridate`, `stringr`, `scales`, `forcats`, `gridExtra`
- **Data files** (2024 NOAA CSVs):
  - `StormEvents_details-ftp_v1.0_d2024_c20241216.csv`
  - `StormEvents_locations-ftp_v1.0_d2024_c20241216.csv`
  - `StormEvents_fatalities-ftp_v1.0_d2024_c20241216.csv`

Place these CSVs in the project directory before running the scripts.

---

## Usage
1. **Clone the repository**
   ```bash
   git clone <repository_url>
   cd <repository_folder>
   ```

2. **Install R dependencies**
   ```r
   install.packages(c(
     "dplyr", "readr", "ggplot2", "lubridate",
     "stringr", "scales", "forcats", "gridExtra"
   ))
   ```

3. **Run the analysis script**
   ```r
   source("storm_analysis.R")
   ```
   This will produce four core plots:
   - Q1: Health impacts by event type
   - Q2: Geographic distribution heatmap
   - Q3: Seasonality line chart for top events
   - Q4: Bar chart of property damage

4. **Generate the R Markdown report**
   - Open `NOAA_Storm_Project.Rmd` in RStudio
   - Click **Knit** to produce an HTML report
   - Publish to RPubs by clicking **Publish** in the preview window

---

## File Structure
```
project_root/
├── README.md
├── storm_analysis.R         # R script with cleaned code
├── NOAA_Storm_Project.Rmd   # R Markdown with analysis narrative
├── StormEvents_details-ftp_v1.0_d2024_c20241216.csv
├── StormEvents_locations-ftp_v1.0_d2024_c20241216.csv
└── StormEvents_fatalities-ftp_v1.0_d2024_c20241216.csv
```

---

## Results and Publishing
- The final HTML report will be available on [RPubs](https://rpubs.com) once published.
- Include the RPubs URL in your class submission.
- Optionally, host the entire project on GitHub for portfolio visibility.

---

## License and Contact
Feel free to reuse or adapt this analysis for educational or professional purposes. For any questions or feedback, contact **Alyssa Okon** at `alyssa.okon@example.com`.

