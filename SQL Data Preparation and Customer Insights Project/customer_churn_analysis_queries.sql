USE ecomm;
SELECT * from customer_churn;

-- 1. HANDLING MISSING VALUES AND OUTLIERS:
-- a. MEAN Imputation for - WarehouseToHome
SET @mean_WarehouseToHome = (
    SELECT ROUND(AVG(WarehouseToHome), 0)
    FROM customer_churn
    WHERE WarehouseToHome IS NOT NULL
);
UPDATE customer_churn
SET WarehouseToHome = @mean_WarehouseToHome
WHERE WarehouseToHome IS NULL;

-- b. MODE Imputation for - Tenure
SET @mode_Tenure = (
    SELECT Tenure
    FROM customer_churn
    WHERE Tenure IS NOT NULL
    GROUP BY Tenure
    ORDER BY COUNT(*) DESC
    LIMIT 1
);
UPDATE customer_churn
SET Tenure = @mode_Tenure
WHERE Tenure IS NULL;

-- c. Handle OUTLIERS for - WarehouseToHome
DELETE FROM customer_churn 
WHERE WarehouseToHome > 100;


-- 2. NEW COLUMN CREATION
-- new column named 'CHURNSTATUS'. Set its value to “Churned” if the corresponding value in the 'Churn' column is 1, else assign “Active”.
ALTER TABLE customer_churn
ADD COLUMN ChurnStatus VARCHAR(10);
UPDATE customer_churn
SET ChurnStatus =
    CASE
	WHEN Churn = 1 THEN 'Churned'
	ELSE 'Active'
    END;
    
    
-- 3. DATA EXPLORATION & ANALYSIS
-- a.count of churned and active customers
SELECT ChurnStatus, COUNT(*) AS customer_count
FROM customer_churn
GROUP BY ChurnStatus;
-- Result:
-- Churned	948
-- Active	4680
-- Insight: -- Insight: Around 17% of customers have churned, indicating a noticeable but manageable retention issue that warrants targeted intervention.

-- b. Determine the percentage of churned customers who complained.
SELECT ROUND(100.0 * SUM(CASE WHEN Complain = 1 THEN 1 ELSE 0 END) / COUNT(*),2) 
AS percentage_churned_who_complained
FROM customer_churn
WHERE ChurnStatus = 'Churned';
-- percentage = 53.59
-- Insight: -- Insight: Over half of the churned customers had raised complaints earlier, suggesting unresolved customer issues may be a major driver of churn.

-- c. Identify the city tier with the highest number of churned customers whose preferred order category is Laptop & Accessory.
SELECT CityTier, COUNT(*) AS churned_count
FROM customer_churn
WHERE ChurnStatus = 'Churned'AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY churned_count DESC
LIMIT 1;
-- Result: city tier 3 with	150
-- Insight: -- Insight: Customers in Tier-3 cities show the highest churn in the Laptop & Accessory category, indicating possible issues with pricing, delivery, or service quality in these regions.

-- d. Identify category wise churn rate and rank them (using SUB QUERY and WINDOW function)
WITH category_churn AS (
    SELECT 
        PreferredOrderCat,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN ChurnStatus='Churned' THEN 1 ELSE 0 END) AS churned_customers
    FROM customer_churn
    GROUP BY PreferredOrderCat
)

SELECT *,
       ROUND((churned_customers*100.0/total_customers),2) AS churn_rate,
       RANK() OVER (ORDER BY (churned_customers*100.0/total_customers) DESC) AS churn_rank
FROM category_churn;
-- Mobile Phone → 27.43% churn
-- Fashion → 15.5%
-- Laptop & Accessory → 10.24%
-- Others → 7.58%
-- Grocery → 4.88%

-- e. average satisfaction score of customers who have complained?
SELECT ROUND(AVG(SatisfactionScore),0)
FROM customer_churn
WHERE Complain = 1;
-- result: 3
-- Insight: Customers who complained report a low average satisfaction score, indicating dissatisfaction and poor experience are strongly linked to complaint behaviour.


-- f. List the top 3 preferred order categories with the highest average cashback amount
SELECT PreferredOrderCat, ROUND(AVG(CashbackAmount),0) AS avg_cashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY avg_cashback DESC
LIMIT 3;
-- Result
-- Others	304
-- Grocery	266
-- Fashion	210
-- Insight:  The 'Others', Grocery, and Fashion categories generate the highest cashback usage, suggesting these segments attract more incentive-driven purchases.

-- g. Categorize customers based on their distance from the warehouse to home and based on churn status
SELECT
    CASE
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS DistanceCategory,
    ChurnStatus,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY
    DistanceCategory,ChurnStatus;
-- Result:
-- Close Distance	  Churned	265
-- Far Distance	      Churned	498
-- Moderate Distance  Churned	184
-- Close Distance	  Active	1696
-- Moderate Distance  Active	1106
-- Far Distance	      Active	1871
-- Very Close Distance Active	7
-- Very Close Distance Churned	1
-- Insight: Customers located farther from the warehouse show higher churn counts, suggesting delivery distance and logistics efficiency may influence customer retention.

-- h. JOIN ON TABLES
-- h1. create a table ‘customer_returns’
CREATE TABLE customer_returns (
    ReturnID INT PRIMARY KEY,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount INT
);
INSERT INTO customer_returns
(ReturnID, CustomerID, ReturnDate, RefundAmount)
VALUES
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);

-- hb. return details along with the customer details of those who have churned and have made complaints.
SELECT
    cr.*,
    cc.*
FROM customer_returns cr
JOIN customer_churn cc
    ON cr.CustomerID = cc.CustomerID
WHERE cc.ChurnStatus = 'Churned'
  AND cc.ComplaintReceived = 'Yes';
  
  -- i. most preferred payment mode among active customers
SELECT PreferredPaymentMode, COUNT(*) AS cust_count
FROM customer_churn
WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode
ORDER BY cust_count DESC
LIMIT 1;
-- 	Debit Card	1956
-- Insight: Debit Card is the most preferred payment mode among active customers, suggesting that maintaining seamless card payment experience is important for retention.



-- RECOMMENDED ACTIONS:
-- 1. Strengthen customer support resolution processes, as a high proportion of churned users had raised complaints.
-- 2. Investigate logistics, delivery time, and pricing strategies in Tier-3 regions where churn is highest for Laptop products.
-- 3. Improve delivery efficiency for customers located far from warehouses, as churn appears higher among distant customers.
-- 4. Maintain smooth debit card payment experience and promotions, since it is the most preferred payment mode among retained users. 
-- 5. Reduce churn in the mobile phone category, which showed the highest churn rate (27.4%) across all product categories.




