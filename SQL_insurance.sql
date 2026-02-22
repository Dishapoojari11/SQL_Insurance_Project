-- Create table 
CREATE TABLE insurance(
           age	INT,
           sex	VARCHAR(20),
           bmi	DECIMAl(10,2),
           children	INT,
           smoker VARCHAR(5),
           region VARCHAR(20),
           charges DECIMAL(10,2)
	);

-- Checking if imported properly
select * from insurance; 

-- CONVERTING RAW DATA INTO INSIGHT READY DATA   
    -- Customer Risk Profiling
    WITH risk_base AS(
     SELECT *,
		CASE
			WHEN smoker = 'yes' AND bmi > 30 THEN 'High Risk'
            WHEN bmi BETWEEN 25 AND 30 THEN 'Medium Risk'
            ELSE 'Low Risk'
		END AS risk_level
	FROM insurance
)
SELECT * FROM risk_base;

 -- Regional Performance Metrics
  CREATE VIEW regional_metrics AS
  SELECT
    region,
    AVG(charges) AS avg_charges,
    COUNT(*) AS total_customers,
    AVG(bmi) AS avg_bmi
  FROM insurance
  GROUP BY region;

-- Ranking customers by charges inside each region
CREATE VIEW charge_ranking AS 
SELECT *,
RANK() OVER(
	PARTITION BY region
    ORDER BY charges DESC 
) AS regional_rank 
from insurance;
     -- helps ans "top expensive customers by region"

-- Advanced Aggregation (ABOVE AVG CUSTOMER)
WITH regional_avg AS(
	SELECT region, AVG(charges) AS avg_charge
    FROM insurance
    GROUP BY region
)
SELECT i.*, r.avg_charge
from insurance i
JOIN regional_avg r
ON i.region = r.region
WHERE i.charges> r.avg_charge;
     -- High value customers

-- Q1 Do Smokers really pay more?
SELECT smoker, avg(charges)
FROM insurance 
GROUP BY smoker;

-- Q2 Age vs Cost Trend
SELECT age, 
AVG(charges) AS running_avg_cost
from insurance 
GROUP BY age
ORDER BY age;

-- Q3 Customer Segmentation
CREATE VIEW customer_segments AS 
SELECT *,
CASE 
WHEN age<30 and smoker='no' THEN 'Young Healthy'
WHEN children >=3 THEN 'Family High Dependence'
WHEN charges > 20000 THEN 'Premium Customer'
ELSE 'Standard'
END AS segment 
from insurance;


SELECT
segment,
COUNT(*) AS total,
COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS percentage
FROM customer_segments
GROUP BY segment;