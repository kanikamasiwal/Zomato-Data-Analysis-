# Zomato Dataset Analysis
This repository contains SQL queries and scripts to analyze the Zomato restaurant dataset. Below is a brief guide to the contents and usage of the repository:

# Table Creation and Data Import
 ### 1.Create Zomato Table:
 - Defines a table zomato with columns for restaurant details such as ID, name, location, cuisine, ratings, etc.
 - Imports data from a CSV file (zomato.csv) into the zomato table.
 ### 2.Create CountryCode Table:
 - Defines a table countrycode to store country codes and names.
 - Imports data from a CSV file (Country-Code.CSV) into the countrycode table.

# Queries and Analysis

 ### Retrieve All Restaurant Data:
 - SQL query to fetch all columns for all restaurants from the zomato table.
 - 
### Top 5 Cuisines Across All Restaurants:
 - Identifies the top 5 cuisines offered across all restaurants based on frequency.
   
### Restaurant Distribution by Price Range:
 - Analyzes the distribution of restaurants across different price ranges.

### Average Rating for Restaurants with Online Delivery vs. Without:
 - Compares the average aggregate rating for restaurants offering online delivery versus those that do not.

### City with Highest Average Cost for Two:
 - Identifies the city with the highest average cost for two people.

### Correlation Between Average Cost for Two and Aggregate Rating:
 - Calculates the correlation coefficient between the average cost for two and the aggregate rating of restaurants.

### Restaurant with Highest Number of Votes and Average Rating:
 - Finds the restaurant with the highest number of votes and its average rating.

### Impact of Table Booking and Online Delivery on Aggregate Rating:
 - Analyzes how the availability of table booking and online delivery impacts the aggregate rating of restaurants.

### Percentage of Restaurants with Online Delivery but No Table Booking:
 - Calculates the percentage of restaurants offering online delivery but not table booking, comparing with their average cost for two and aggregate rating.

### Top 5 Cities by Number of Restaurants:
 - Identifies the top 5 cities with the highest number of restaurants, including trends in average cost for two and aggregate rating.

### Distribution of Ratings Across Different Price Ranges:
 - Analyzes the distribution of ratings (e.g., excellent, very good) across different price ranges to determine if higher-priced restaurants receive better ratings.

### Average Aggregate Rating in Countries with Low Average Cost:
 - Calculates the average aggregate rating for restaurants in countries where the average cost for two people is less than 1000 units of local currency.

### Rank Countries by Number of Excellent-Rated Restaurants:
 - Ranks countries based on the number of restaurants with an aggregate rating of 'Excellent', including only countries with at least 5 such restaurants.

# Resources

### Data Sources:
 - **Zomato Dataset:** The dataset used in this repository can be found [here](https://www.kaggle.com/datasets/shrutimehta/zomato-restaurants-data/data).
### Tools:
- **PostgreSQL:** Database management system used for data storage and querying. [Download PostgreSQL](https://www.postgresql.org/download/).
### Documentation:
 - **SQL Tutorial:** Comprehensive guide on SQL syntax and usage. [SQL Tutorial](https://www.w3schools.com/sql/).

