Create database Airlines;
use airlines;
SET SQL_SAFE_UPDATES = 0;

-- Weekday VS Weekend --
Alter Table maindata
Add Column WeekDay_VS_Weekend VARCHAR(25);

Update maindata
SET WeekDay_VS_Weekend = 
  CASE
  WHEN DAYNAME(date_column) IN ('Saturday', 'Sunday') THEN 'Weekend'
    ELSE 'Weekday'
    END;
    
SELECT  year,
    month,
    day,
    date_column,
    Month_name,
    quarter_column,
    YearMonth,
    Weekday_No,
    Week_day_Name,
    Financial_Month,
    Financial_Quarter_Text,
    WeekDay_VS_Weekend from maindata;

-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DATE VIEW --
CREATE VIEW DATE_FIELD AS
SELECT `Date_column`,`Month`,`Month_Name`,`Quarter_column`,`YearMonth`,`WeekDay_No`,`Week_Day_Name`,`Financial_Month`,`Financial_Quarter`
FROM maindata;

Select * from DATE_FIELD;

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- Q2. Find the load Factor percentage on a yearly , Quarterly , Monthly basis --

-- Load Factor--
Alter Table  maindata
Add Column Load_Factor FLOAT DEFAULT NULL;

Update maindata
SET Load_Factor = ifnull(round(`Transported Passengers`/`Available Seats`*100,2),0);

SELECT Load_Factor from maindata;

--------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW LoadFactor AS
SELECT `Year`,`Quarter_column`,`Month`, ROUND(avg(Load_Factor*100),2) AS AVG_LoadFactor
FROM maindata 
GROUP BY `Year`,`Quarter_column`,`Month`;

SELECT * from LoadFactor;

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q3. Find the load Factor percentage on a Carrier Name basis  -- 

CREATE VIEW Carrier_Names AS
SELECT `Carrier Name`, ROUND(avg(Load_Factor*100),2) AS AVG_LoadFactor
FROM maindata
GROUP BY `Carrier Name`;

SELECT * FROM Carrier_Names;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Top 10 Carrier Names based passengers preference --

CREATE VIEW Top10_Carrier_Name AS
SELECT `Carrier Name`, SUM(`Transported Passengers`) AS No_of_passengers
FROM maindata
GROUP BY `Carrier Name`
order by No_of_passengers DESC
LIMIT 10;

Select * from Top10_Carrier_Name;

---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q5. Display top Routes ( from-to City) based on Number of Flights --

CREATE VIEW Top_Route AS
SELECT `From - To City`, Count(`Departures Performed`) as No_of_Flights
FROM maindata
group by `From - To City`
order by No_of_Flights DESC
LIMIT 20;

SELECT * FROM Top_Route;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q6. Identify the how much load factor is occupied on Weekend vs Weekdays --

CREATE VIEW Weekend_VS_Weekday AS
SELECT `WeekDay_VS_Weekend`, ROUND(avg(Load_Factor*100),2) AS AVG_Loadfactor
FROM maindata
Group By `WeekDay_VS_Weekend`;

SELECT * from Weekend_VS_Weekday;

------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*-- Search capability to find the flights between 
Source Country, Source State, Source City to Destination Country , Destination State, Destination City --*/

Create View Search_Capability_To_Find_The_Flights AS
SELECT `Airline ID`,`Datasource ID`,`Region Code`,`Carrier Name`,`Origin Country`,`Destination Country`,`Origin State`,`Destination State`,`Origin City`,`Destination City`
FROM maindata;

SELECT * FROM Search_Capability_To_Find_The_Flights;

---------------------------------------------------------------------------------------------------------------------------------------------------------

-- Number of flights based on Distance groups --

CREATE VIEW DistanceGroup_IDs AS
SELECT `Distance Group ID`, Count(`Departures Performed`) AS No_of_flights
FROM maindata
GROUP BY `Distance Group ID`
Order BY No_of_flights DESC;

SELECT * FROM DistanceGroup_IDs;