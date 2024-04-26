import csv
from datetime import datetime, timedelta
import random

# List of 14 different artists
artists = ["Ed Sheeran", "Billie Eilish", "Drake", "Ariana Grande", "Taylor Swift", "Beyoncé", "Justin Bieber",
           "Rihanna", "Kanye West", "Lady Gaga", "The Weeknd", "Bruno Mars", "Dua Lipa", "Post Malone"]

# Function to generate random datetime within a range
def random_datetime(start_date, end_date):
    delta = end_date - start_date
    random_days = random.randint(0, delta.days)
    random_seconds = random.randint(0, 24*60*60 - 1)
    return start_date + timedelta(days=random_days, seconds=random_seconds)

# Function to generate dummy data
def generate_dummy_data():
    start_date = datetime(2022, 1, 1)
    end_date = datetime(2022, 6, 30)
    data = []
    for _ in range(1500):
        endTime = random_datetime(start_date, end_date)
        # Randomly select track and artist names with repetition
        trackName = f"Song {random.randint(1, 10)}"
        artistName = random.choice(artists)
        msPlayed = random.randint(60000, 900000)
        data.append([endTime.strftime('%Y-%m-%d %H:%M:%S'), trackName, artistName, msPlayed])
    return data

# Function to write data to CSV file
def write_to_csv(data, filename):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(['endTime', 'trackName', 'artistName', 'msPlayed'])
        writer.writerows(data)

# Generate dummy data
dummy_data = generate_dummy_data()

# Write data to CSV file
write_to_csv(dummy_data, 'spotify_data.csv')

print("CSV file generated successfully.")