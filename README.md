# Insurance Customer Behaviour and Cost Analytics
## Advanced SQL Data Analysis Report 

### Project Overview 
This project analyses an insurance customer dataset using advanced SQL techniques to understand cost behaviour, customer risk profiles, and demographic trends. The objective was to transform raw data ito meaningful business insights by applying analytical views, segmentation logic and window function based trend analysis.

### Objectives : Key focus areas include:
- Identify major cost drivers
- Understanding age-related cost trends 
- Segmenting customers based on behavioural and demographic factors 
- Evaluating portfolio structure and risk distribution

### Methodology 
The dataset was processed using a structured SQL workflow 
- **Table Creation**: A Table 'insurance' was created to store the insurance data.
```sql
CREATE TABLE insurance(
           age	INT,
           sex	VARCHAR(20),
           bmi	DECIMAl(10,2),
           children	INT,
           smoker VARCHAR(5),
           region VARCHAR(20),
           charges DECIMAL(10,2)
	);
```
- **Risk Profiling**: Customers were classified into risk levels using BMI and smoking status.
```sql
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
```
- **Advanced Analysis**: Window functions and aggregation queries were used to evaluate trends, rankings, and distributions.
- **Smoke Impact Analysis**: Average charge were compared across smoking categories to identify major cost drivers.
```sql
SELECT smoker, avg(charges)
FROM insurance 
GROUP BY smoker;
```
- **Age Vs Cost Trend Analysis**: To evaluate how insurance costs change over time, average charges were calculated across age groups.
```sql
SELECT age, 
AVG(charges) AS running_avg_cost
from insurance 
GROUP BY age
ORDER BY age;
```
- **Segmentation Logic**: Customers were grouped into Standard, Young Healthy, Premium, and Family High Dependence categories.
```sql
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
```

### Key Findings 
#### Smoking Status as a primary Cost Driver
Average insurance charges for smokers (~32050) were nearly four times higher than for non smokers(~8434).
This indicates that behavioural risk factors strongly influence insurance pricing models, outweighing most demographic variables.
#### Age vs Cost Trend
Average insurance charges showed a gradual increase from early adulthood(~7000-9000 range) to later ages(~13000+ by age 60 +).
The growth pattern was steady rather than exponential, suggesting age contributes to incremental risk accumulation rather than sudden cost escalation.
#### Customer Segmentation Distribution
Customer segments were distributed as follows:
- Standard: 46.3%
- Young Healthy: 24.7%
- Premium Customer: 16.4%
- Family High Dependence: 12.5%
The distribution forms a risk pyramid, where mid-risk customers dominate the portfolio while high-cost premium customers represent a smaller but influential group.
#### Young Healthy Segment as a Growth Cohort
Nearly one-fourth of customers belong to the Young Healthy category. Although their current charges are lower, this group represents potential long-term revenue as insurance costs tend to increase with age.
#### Structural Risk from Family Dependence
Customers with multiple dependents account for 12.5% of the population. While smaller in size, this segment introduces structural risk due to increased claim probability and long-term coverage needs.

### Overall Interpretation 
The analysis reveals two primary dimensions driving insurance charges:
1. Behavioural Risk: Smoking status significantly increases average costs.
2. Physiological Risk: Age and BMI contribute to gradual cost escalation.
The portfolio structure suggests a stable underwriting model supported by a large standard-risk customer base, supplemented by smaller high-value segments.

### Conclusion 
using advanced SQL techniques, this project demonstrates how structured analytics modeling can transform raw insurance data into meaningful business intelligence. The findings highlight the importance of lifestyle behaviour, demographic trends and customer segmentation in understanding insurance cost dynamics.
