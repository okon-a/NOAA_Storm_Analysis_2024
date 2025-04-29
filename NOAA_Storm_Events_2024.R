knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)
library(dplyr)      # Data manipulation verbs (filter, summarize, join)
library(readr)      # Fast CSV import
library(ggplot2)    # Advanced plotting
library(lubridate)  # Date/time parsing
library(stringr)    # String operations
library(scales)     # Formatting numbers and labels

# Read 2024 files (ensure filenames and dates match):
details    <- read_csv("C:/Users/19all/Desktop/DAT511/StormEvents_details-ftp_v1.0_d2024_c20250401.csv")
locations  <- read_csv("C:/Users/19all/Desktop/DAT511/StormEvents_locations-ftp_v1.0_d2024_c20250401.csv")
fatalities <- read_csv("C:/Users/19all/Desktop/DAT511/StormEvents_fatalities-ftp_v1.0_d2024_c20250401.csv")

# Standardize names
names(details)    <- tolower(names(details))
names(locations)  <- tolower(names(locations))
names(fatalities) <- tolower(names(fatalities))

# Merge on common 'event_id'. Fatalities may be one-to-many; we sum later.
storm_raw <- details %>%
  left_join(locations, by = "event_id") %>%
  left_join(fatalities, by = "event_id")

# Parse primary date-time column for seasonality
storm_clean <- storm_raw %>%
  mutate(
    begin_dt = ymd_hms(begin_date_time),  # Convert text to POSIXct
    month = month(begin_dt, label = TRUE, abbr = FALSE),
    event_type = str_to_title(event_type), # Uniform event type names
    damage_property = if_else(is.na(damage_property), "0", damage_property)
  )

# Inspect cleaned data
dim(storm_clean)
head(storm_clean, 3)


health_summary <- storm_clean %>%
  group_by(event_type) %>%
  summarize(
    injuries = sum(injuries_direct + injuries_indirect, na.rm = TRUE),
    deaths   = sum(deaths_direct + deaths_indirect, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  mutate(total_health = injuries + deaths) %>%
  arrange(desc(total_health))

# Bar plot of top 10 event types by combined health impact
ggplot(slice_head(health_summary, n = 10), aes(x = reorder(event_type, total_health), y = total_health)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Top 10 Storm Event Types by Combined Injuries and Fatalities (2024)",
    x = "Event Type", y = "Total Injuries + Deaths"
  ) +
  scale_y_continuous(labels = comma) +
  theme_minimal()


# Identify top 10 event types by overall count
top10 <- storm_clean %>%
  count(event_type) %>%
  arrange(desc(n)) %>%
  slice_head(n = 10) %>%
  pull(event_type)

events_by_state <- storm_clean %>%
  filter(event_type %in% top10) %>%
  count(state, event_type)

# Heatmap
ggplot(events_by_state, aes(x = event_type, y = state, fill = n)) +
  geom_tile(color = "white") +
  scale_fill_viridis_c(option = "C") +
  labs(
    title = "Frequency of Top 10 Storm Event Types by State (2024)",
    x = "Event Type", y = "State", fill = "Count"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    axis.text.y = element_text(size = 6)
  )


# Prepare monthly counts and identify top 8 event types
data_monthly <- storm_clean %>%
  count(month, event_type)
top8_types <- storm_clean %>%
  count(event_type) %>%
  arrange(desc(n)) %>%
  slice_head(n = 8) %>%
  pull(event_type)
season_top8 <- data_monthly %>% filter(event_type %in% top8_types)

# Plot: Combined seasonal trends for top 8 event types
ggplot(season_top8, aes(x = month, y = n, color = event_type, group = event_type)) +
  geom_line(size = 1.2) +
  labs(
    title = "Seasonal Trends for Top 8 Storm Event Types (2024)",
    x = "Month", y = "Number of Events", color = "Event Type"
  ) +
  theme_minimal()


# Parse and convert damage_property to numeric
prop_data <- storm_clean %>%
  mutate(
    amount = parse_number(damage_property),
    multiplier = case_when(
      str_detect(damage_property, "K") ~ 1e3,
      str_detect(damage_property, "M") ~ 1e6,
      TRUE ~ 1
    ),
    damage_usd = amount * multiplier
  )

# Summarize total damage by event type and filter top 6
damage_summary <- prop_data %>%
  group_by(event_type) %>%
  summarize(total_damage = sum(damage_usd, na.rm = TRUE)) %>%
  arrange(desc(total_damage))

# Plot: Top 6 event types by total property damage
ggplot(slice_head(damage_summary, n = 6), aes(x = reorder(event_type, total_damage), y = total_damage / 1e6)) +
  geom_col(fill = "purple") +
  coord_flip() +
  labs(
    title = "Top 6 Event Types by Total Property Damage (2024)",
    x = "Event Type", y = "Damage (Million USD)"
  ) +
  scale_y_continuous(labels = dollar_format(prefix = "$")) +
  theme_minimal()





