# exploring columns

spotify_data %>% ggplot(aes(x=month)) + 
  geom_histogram(stat = "count",fill="#1DB954", alpha=0.7) +
  labs(title = "Listening frequency by month", x="Month", y="Count") + theme_minimal()

spotify_data %>% ggplot(aes(x=day_of_week)) + 
  geom_histogram(stat = "count",fill="#1DB954", alpha=0.7) +
  labs(title = "Listening frequency by day of week", x="Day of week", y="Count") + theme_minimal()

spotify_data %>% ggplot(aes(x=artistName)) + 
  geom_histogram(stat = "count",fill="#1DB954", alpha=0.7) +
  labs(title = "Listening frequency by Artists", x="Artist Name", y="Count") + theme_minimal()

spotify_data %>% ggplot(aes(x=end_hour)) + 
  geom_histogram(stat = "count",fill="#1DB954", width = 0.5, alpha=0.7) + 
  scale_x_continuous(breaks = 0:23,labels=0:23) +
  facet_wrap(~month) + # data aggregated separately for each month
  labs(title = "Listening frequency by hour for each month", x="Hour", y="Count") + theme_minimal()

# plot - artist frequency per month

spotify_data %>%
  group_by(month, artistName) %>% 
  summarize(freq = n()) %>% 
  ggplot(aes(x=freq,y=artistName,color=month)) +
  geom_segment(aes(y=artistName,yend=artistName,x=0,xend=freq), size = 1, alpha=0.7, show.legend = FALSE) +
  scale_color_manual(values = c("#FC8585","#FFC86D","#48BCD7","#F49E2D","#85CBD9","#994B26")) +
  geom_point(size=2,show.legend = FALSE) +
  facet_wrap(~ month) + labs(title = "Frequency of All Artists Per Month") +
  theme_minimal()


# plotting two artists' frequency  

spotify_data %>% group_by(artistName, month) %>%
  filter(artistName %in% c('Ariana Grande','Taylor Swift')) %>% 
  mutate(counts = n()) %>%  
  ggplot(aes(x=month,y=counts,fill=artistName)) + 
  geom_col(position="dodge",width = 0.9) + 
  scale_fill_manual(values = c("Ariana Grande" = "#AEDCAE", 
                               "Taylor Swift" = "#1DB954")) +
  labs(title = "Taylor Swift vs Ariana Grande", 
       subtitle = "frequency of occurance per month",
       fill = "Artist Name",
       x="",y="") +
  theme_minimal()


# plotting repeat listening frequency of artists per month  

# checking repeat frequency in wide data format

spotify_data_wide <- spotify_data %>% 
  group_by(artistName,month) %>%
  summarize(repeats = sum(repeat_listen)) %>% 
  arrange(month) %>% 
  pivot_wider(names_from = month,values_from = repeats) %>% 
  as_tibble()

spotify_data %>%
  group_by(artistName,month) %>%
  mutate(repeats = sum(repeat_listen)) %>% 
  ggplot(aes(x=artistName,y=repeats,fill=repeats)) +
  geom_col(position = "dodge",width = 0.3) +
  scale_fill_steps(low="#ECFADC",high="#1DB954") +
  facet_wrap(~month) +
  coord_flip() + labs(title = "Repeat Listens Per Month",x="",
                      subtitle = "assuming song length of 3 minutes") +
  theme_minimal()


# plotting most listened artist (by hours)
spotify_data %>% group_by(artistName) %>%
  summarize(hours = sum(hour_listen)) %>% 
  slice_max(hours,n=10) %>% 
  ggplot(aes(x=artistName,y=hours,color=artistName)) +
  geom_segment(aes(x= artistName, xend= artistName,
                   y= 0, yend = hours),size=0.7,show.legend = FALSE) +
  geom_point(size = 2, color = "#1DB954") + 
  coord_flip() +
  labs(title = "Top 10 Most Listened Artists", x="",y="Hours") +
  theme_minimal()


# plotting week by week listening activity
spotify_data %>% group_by(month, weeknum) %>%
  summarize(total_hours = sum(hour_listen)) %>%
  ggplot(aes(x = weeknum, y = total_hours, fill = month)) +
  geom_col(width = 0.7, alpha=0.7) +
  scale_x_discrete(limits = 1:26, breaks = 1:26 ) +
  scale_fill_manual(values = c("#FC8585","#FFC86D","#48BCD7","#F49E2D","#85CBD9","#994B26")) +
  labs(title = "Playback hours per week",
       y = "Total Hours", x="Week of the Year", fill = "Month") +
  theme_minimal()


# plotting hour of the day listening activity
spotify_data %>% group_by(end_hour) %>%
  summarize(hours = sum(hour_listen)) %>%
  ggplot(aes(x = end_hour, y = hours)) +
  geom_col(aes(fill = hours), width = 0.5) +
  scale_fill_steps(low="#ECFADC",high="#1DB954") +
  scale_x_discrete(limits=0:23,breaks=0:23)+
  labs(title = "Playback hours by hour of the day",
       x= "Hour of the day", y="Listening hours") +
  xlab("") +
  theme_light()


# plotting hour of the day listening activity - week wise
  spotify_data %>% group_by(day_of_week, end_hour) %>%
    summarize(hours = sum(hour_listen)) %>%
    ggplot(aes(x = end_hour, y = hours)) +
    geom_line(aes(color = day_of_week),show.legend = TRUE, linewidth = 1, alpha=0.7) +
    scale_x_discrete(limits=0:23,breaks=0:23) +
    labs(title = "Playback hours by hour of the day and week",
         x= "Hour of the day", y="Listening hours") +
    xlab("") +
    theme_light()
