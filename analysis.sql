/* 
This query breaks down users by plan type and status.
Project: Spotify Revenue Leakage Detector
*/


/*Q1)This query shows active vs inactive users*/
use subscriptionDB;
SELECT SUBSCRIPTION_STATUS,
count(*) as total_users
from spotify
group by SUBSCRIPTION_STATUS;

/*Q2) Which plan loses the most users*/
use subscriptionDB;
select subscription_type,
       subscription_status,
       count(*) as total_rows
       from spotify
group by subscription_type,subscription_status
order by subscription_type

/*Q3)Which country has the most inactive users?*/
use subscriptionDB;
select country,
       subscription_status,
       count(*) as total_rows
       from spotify
       where subscription_status = 'Inactive'
group by country, subscription_status
order by total_rows DESC

use subscriptionDB;
select country,
count(*) as total_rows
from spotify 
where subscription_status = 'Inactive'
group by country
order by total_rows desc

/*Q4)What is the monthly revenue leakage in dollars for each subscription plan?"
In other words, how much money is Spotify losing every month from inactive users, 
broken down by plan type?*/

USE subscriptionDB;
SELECT SUBSCRIPTION_TYPE,
COUNT(*) AS TOTAL_ROWS
FROM SPOTIFY
WHERE SUBSCRIPTION_STATUS = 'Inactive'
group by subscription_type
order by total_rows desc

USE subscriptionDB;
SELECT
SUBSCRIPTION_TYPE,
count(*) as inactive_users,
case
when SUBSCRIPTION_TYPE = 'Free' THEN 0
WHEN SUBSCRIPTION_TYPE = 'PREMIUM INDIVIDUAL' THEN 10.99
WHEN SUBSCRIPTION_TYPE = 'Premium Duo' THEN 14.99
WHEN SUBSCRIPTION_TYPE = 'Premium Family' THEN 16.99
WHEN SUBSCRIPTION_TYPE = 'Student' THEN 5.99
ELSE 0
END AS MONTHLY_PRICE,
-- NEW: multiply count × price
    COUNT(*) * CASE 
        WHEN subscription_type = 'Free' THEN 0
        WHEN subscription_type = 'Premium Individual' THEN 10.99
        WHEN subscription_type = 'Premium Duo' THEN 14.99
        WHEN subscription_type = 'Premium Family' THEN 16.99
        WHEN subscription_type = 'Student' THEN 5.99
        ELSE 0
    END AS monthly_revenue_leakage

FROM spotify
WHERE subscription_status = 'Inactive'
GROUP BY subscription_type
ORDER BY monthly_revenue_leakage DESC;

/*Q5)Which active users are showing early warning signs of going 
inactive?*/
use subscriptionDB;
select SUBSCRiPTION_type,
count(*) as Customers_vergeofloss
from spotify 
WHERE subscription_status = 'Active'
And months_inactive >=2
group by subscription_type
order by Customers_vergeofloss desc

/*Q6) What is the average listening hours per week 
For each subscription plan?*/
use subscriptionDB;
select subscription_type,
AVG (avg_listening_hours_per_week) AS AVG_LISTENING_PER_PLAN
from spotify
group by subscription_type
order by avg (avg_listening_hours_per_week) desc

/*Q7)Which device type has the most inactive users?*/
USE SUBSCRIPTIONDB;
SELECT primary_device,
COUNT(*) AS INACTIVE_PER_DEVICE
FROM SPOTIFY
WHERE SUBSCRIPTION_STATUS = 'INACTIVE'
GROUP BY primary_device
ORDER BY INACTIVE_PER_DEVICE DESC

/*Q8)What is the total annual revenue leakage per plan?*/
USE SUBSCRIPTIONDB;
SELECT SUBSCRIPTION_TYPE,
count(*) as inactive_users,
count(*) * case
when subscription_type = 'free' then 0
when subscription_type = 'premium individual' then 10.99
when subscription_type = 'Premium Duo' then 14.99
when subscription_type = 'Premium Family' then 16.99
when subscription_type = 'Student ' then 5.99
else 0
end * 12 as  annual_revenue_leakage
from spotify
where subscription_status = 'inactive'
GROUP BY subscription_type
ORDER BY annual_revenue_leakage DESC
