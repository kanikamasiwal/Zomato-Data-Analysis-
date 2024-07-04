---Create a table zomato and import the data
DROP TABLE IF EXISTS zomato;
CREATE TABLE zomato
(RestaurantID INT,
	RestaurantName TEXT,
	CountryCode INT,
	City TEXT,
	Address TEXT,
	Locality TEXT,
	LocalityVerbose TEXT,
	Longitude DECIMAL(10, 6),
	Latitude DECIMAL(10, 6),
	Cuisines TEXT,
	AverageCostfortwo INT,
	Currency VARCHAR(70),
	HasTablebooking VARCHAR(10),
	HasOnlinedelivery VARCHAR(10),
	Isdeliveringnow VARCHAR(10),
	Switchtoordermenu VARCHAR(10),
	Pricerange INT,
	Aggregaterating DECIMAL(2,1),
	Ratingcolor VARCHAR(20),
	Ratingtext VARCHAR(20),
	Votes INT
	)
;

COPY zomato FROM 'C:\Users\Kanika Masiwal\OneDrive\Desktop\sql\zomato.csv'
WITH(FORMAT CSV,HEADER,DELIMITER',');

-----Retrieve all columns for all restaurants in the dataset.

SELECT * FROM zomato;

------ Create the table countrycode and import the data
CREATE TABLE countrycode
(CountryCode INT,
	Country VARCHAR(50)
);

COPY countrycode FROM 'C:\Users\Kanika Masiwal\OneDrive\Desktop\sql\Country-Code.CSV'
WITH(FORMAT CSV,HEADER,DELIMITER',');

--------Retrieve all columns from countrycode table
SELECT * FROM countrycode;

-------- 1 How many restaurants are there in each city?

SELECT DISTINCT z.City , COUNT(z.RestaurantName) OVER (PARTITION BY z.City)FROM zomato z;

-------2 What are the top 5 cuisines offered across all restaurants?

WITH cuisine_counts AS (
    SELECT TRIM(UNNEST(string_to_array(Cuisines, ','))) AS Cuisine
    FROM zomato
)
SELECT Cuisine, COUNT(*) AS Count
FROM cuisine_counts
GROUP BY Cuisine
ORDER BY Count DESC
LIMIT 5;

------	3 How does the distribution of restaurants vary by price range?
SELECT Pricerange, COUNT(*) AS RestaurantCount,
       COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS Percentage
FROM zomato
GROUP BY Pricerange
ORDER BY Pricerange;

-------4 What is the average rating for restaurants that offer online delivery versus those that do not?

SELECT 
  AVG(CASE WHEN HasOnlinedelivery = 'No' THEN Aggregaterating END) AS Average_no,
  AVG(CASE WHEN HasOnlinedelivery = 'Yes' THEN Aggregaterating END) AS Average_yes
FROM zomato;
------	5 Which city has the highest average cost for two?
SELECT City, AverageCostfortwo
FROM zomato
ORDER BY AverageCostfortwo DESC
LIMIT 1;

-------6.Are there any correlations between the average cost for two and the aggregate rating?
SELECT
    CORR(AverageCostfortwo, Aggregaterating) AS CorrelationCoefficient
FROM
    zomato;

-----7.Which restaurants have the highest number of votes, and what is their average rating?
SELECT City, Votes, Aggregaterating
FROM zomato
ORDER BY Votes DESC
LIMIT 1;
-----8.How does the availability of table booking and online delivery impact the aggregate rating of restaurants?
SELECT City, HasTablebooking, HasOnlinedelivery, ROUND(AVG(Aggregaterating),2) AS AverageRating
FROM zomato
GROUP BY 
	City,
    HasTablebooking,
    HasOnlinedelivery
ORDER BY AVG(Aggregaterating) DESC;
-----9. Calculate the percentage of restaurants that offer online delivery but do not have table booking. How does this compare with their average cost for two and aggregate rating?

WITH OnlineDeliveryNoBooking AS (
    SELECT
        COUNT(*) AS RestaurantsWithOnlineDeliveryNoBooking,
        ROUND(AVG(AverageCostfortwo),2) AS AvgCostForTwo,
        ROUND(AVG(Aggregaterating),2) AS AvgAggregateRating
    FROM
        zomato
    WHERE
        HasOnlinedelivery = 'Yes'
        AND HasTablebooking = 'No'
),
TotalRestaurants AS (
    SELECT
        COUNT(*) AS TotalRestaurants
    FROM
        zomato
    WHERE
        HasOnlinedelivery = 'Yes'
)
SELECT
    RestaurantsWithOnlineDeliveryNoBooking,
    ROUND((RestaurantsWithOnlineDeliveryNoBooking::numeric / TotalRestaurants * 100.0), 2) AS PercentageOnlineDeliveryNoBooking,
    AvgCostForTwo,
    AvgAggregateRating
FROM
    OnlineDeliveryNoBooking,
    TotalRestaurants;

-----10.Identify the top 5 cities with the highest number of restaurants. What are the average cost for two and aggregate rating trends in these cities?
WITH CityRestaurantCounts AS (
    SELECT
        City,
        COUNT(*) AS RestaurantCount,
        AVG(AverageCostfortwo) AS AvgCostForTwo,
        AVG(Aggregaterating) AS AvgAggregateRating
    FROM
        zomato
    GROUP BY
        City
    ORDER BY
        RestaurantCount DESC
    LIMIT 5
)
SELECT
    City,
    RestaurantCount,
    ROUND(AvgCostForTwo, 2) AS AvgCostForTwo,
    ROUND(AvgAggregateRating, 2) AS AvgAggregateRating
FROM
    CityRestaurantCounts
ORDER BY
    RestaurantCount DESC;
---11.Analyze the distribution of ratings (excellent, very good, etc.) across different price ranges. Are higher-priced restaurants more likely to receive better ratings?
SELECT
    Pricerange,
    Ratingtext,
    COUNT(*) AS RatingCount,
    ROUND(COUNT(*)::numeric / SUM(COUNT(*)) OVER (PARTITION BY Pricerange) * 100.0, 2) AS PercentageInPriceRange
FROM
    zomato
GROUP BY
    Pricerange,
    Ratingtext
ORDER BY
    Pricerange,
    RatingCount DESC;
---12.Calculate the average aggregate rating for restaurants in countries where the average cost for two people is less than 1000 units of local currency

SELECT c.Country, ROUND(AVG(z.Aggregaterating),2) AS AvgRating
FROM Zomato z
JOIN CountryCode c ON z.CountryCode = c.CountryCode
WHERE z.AverageCostfortwo < 1000
GROUP BY c.Country;

---13.Rank countries by the number of restaurants that have an aggregate rating of 'Excellent'. Include only countries with at least 5 such restaurants
SELECT c.Country, COUNT(*) AS NumExcellentRestaurants
FROM Zomato z
JOIN CountryCode c ON z.CountryCode = c.CountryCode
WHERE z.Ratingtext = 'Excellent'
GROUP BY c.Country
HAVING COUNT(*) >= 5
ORDER BY NumExcellentRestaurants DESC;


