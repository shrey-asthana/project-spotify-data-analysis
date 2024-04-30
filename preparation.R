# loading libraries

install.packages("tidyverse")
library(tidyverse)
library(ggplot2)


# importing the dataset 
spotify_data <- read.csv("D:/Work/Data Analytics/Projects/Spotify-Data-Analysis/source/spotify_data.csv", header = TRUE)

# converting date-time column to correct data type 
spotify_data$endTime <- ymd_hms(spotify_data$endTime)

# Converting artistName to factor data type
spotify_data$artistName <- factor(spotify_data$artistName)


str(spotify_data)

# adding month, day, day of week, date, time columns , week number

spotify_data <- spotify_data %>% mutate(month = month(endTime, label = TRUE),
                                        date = date(endTime), 
                                        day_of_week = wday(endTime, label = TRUE),
                                        end_hour = hour(endTime),
                                        weeknum = week(endTime) %>% as.integer())


# Converting month,day_of_week to ordered factor data type
spotify_data$artistName <- factor(spotify_data$artistName)

# adding column to show hours of listening

spotify_data <- spotify_data %>% 
  mutate(hour_listen = (msPlayed/1000)/3600)

# creating repeat listen column denoting replays of a song assuming 3 min length

spotify_data <- spotify_data %>% 
  mutate(repeat_listen = as.integer((msPlayed/1000)/(60*3)))




# checking data for a random date in data set
spotify_data %>% 
  group_by(date, end_hour) %>%
  filter(month == 1, date == '2022-02-10') %>% 
  summarize( listen = n()) # there are no activity hours and hours with some activity.
