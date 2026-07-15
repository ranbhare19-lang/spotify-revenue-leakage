/*
Project: Google Payments Fraud Intelligence Dashboard
Author: Charulata Ranbhare
Date: July 2023
Dataset: IEEE-CIS Fraud Detection — 590,540 transactions
Description: SQL analysis identifying $3,083,844 in fraud exposure
             with a risk scoring model and window functions
*/

-- Query 1: Fraud vs Legitimate Transaction Count
USE FraudDB;
SELECT isFraud,
COUNT(*) AS Total_transactions
FROM train_transaction
Group by isFraud;

-- Query 2: Total Fraud Exposure Value
Use FraudDB;
Select Sum(TransactionAmt) as Fraud_Exposure_Value
FROM train_transaction
where isFraud = '1';

-- Query 3: Fraud by Card Type
Use FraudDB;
SELECT card4 as Card_type,
Count (*) as isfraud
FROM train_transaction
WHERE isFraud = '1'
Group by card4 
order by isfraud desc;

-- Query 4: Fraud by Email Domain
Use FraudDB;
SELECT P_emaildomain as EMAIL_TYPE,
COUNT(*) AS isFraud
from train_transaction
where isfraud = '1'
group by P_emaildomain
Order by isfraud desc;

-- Query 5: Average Transaction Amount — Fraud vs Legitimate
use fraudDB;
select  
    isFraud,
    avg(TransactionAmt) as AVG_transaction_amount,
    count(*) as Total_transaction
from train_transaction
group by isFraud
order by isFraud desc;

-- Query 6: Debit vs Credit Fraud
Use FraudDB;
SELECT card6 as Card_type,
count(*) as Total_transaction
from train_transaction
where isfraud = '1'
group by card6
order by Total_transaction desc;

-- Query 7: Fraud Risk Scoring Model with Window Functions (JOIN)
use frauddb;
select top 100
      t.transactionID,
      t.transactionAmt,
      t.card4,
      t.card6,
      t.P_emaildomain,
      i.DeviceType,
(
Case when t.P_emaildomain = 'anonymous.com' then 30 else 0 end +
case when t.transactionAmt > 500 then 20 else 0 end +
case when t.transactionAmt > 200 then 10 else 0 end +
case when t.card6 = 'Debit' then 10 else 0 end +
case when t.P_emaildomain IS NULL then 15 else 0 end
     ) as risk_score,
     Rank () over (
     order by (
     case when t.P_emaildomain = 'anonymous.com' then 30 else 0 end +
     case when t.transactionAmt > 500 then 20 else 0 end +
     case when t.transactionAmt > 200 then 10 else 0 end +
     case when t.card6 = 'Debit' then 10 else 0 end +
     case when t.P_emaildomain IS NULL then 15 else 0 end
       ) desc
     ) AS INVESTIGATION_PRIORITY
     from train_transaction t 
     inner join train_identity i
     on t.transactionID = i.transactionID
     WHERE t.isfraud = 1
     order by risk_score desc;
