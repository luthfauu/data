use practice;
select count(*) from marketing_customers;

-- 1. UNDERSTAND THE CUSTOMERS
-- a. Business Question: Identify the Total customer count
select count(distinct ID) from marketing_customers;
-- Result: 2240
-- Insight: The dataset contained 2240 customers, sufficient to observe spending and campaign patterns.

-- b. Business Question: Identify the average income and analyse under which financial segment do majority of the people come.
SELECT round(AVG(Income),0) FROM marketing_customers;
-- Result: 52238
-- Insight: The average income of customers is around 52K, indicating a middle-income segment. This suggests marketing strategies should balance affordability with perceived value rather than positioning products as premium luxury.

-- c. Business Question: Which country contributes the most to total customers and analyse where we have to improve campaign performances.
SELECT Country, COUNT(*) as cust_cnt
FROM marketing_customers
GROUP BY Country
ORDER BY cust_cnt DESC;
-- Result: 
-- Spain	1095
-- Saudi Arabia	337
-- Canada	268
-- Australia	160
-- India	148
-- Germany	120
-- USA	109
-- Mexico	3
--  Insight: The customer base is highly concentrated in Spain, indicating the company’s strongest market presence there. Secondary markets exist in Saudi Arabia and Canada, suggesting potential expansion opportunities, while very small markets like Mexico show limited penetration.


-- 2. REVENUE ANALYSIS
-- a. Business Question: Analyse the total money spend on this Company and identify the customer's spending behaviour
SELECT SUM(Total_Spend) AS total_revenue
FROM marketing_customers;
-- Result: 1356988
--  Insight: Even though customers have an average income of about 52K, their spending on this company is relatively decent. This suggests the brand is not a primary spending priority, so improving customer engagement and loyalty could help increase revenue.

-- b. Business Question: Analyse the revenue earned in different channels and identify which channel needs attention.
SELECT 
SUM(Web_revenue) AS web,
SUM(Store_revenue) AS store,
SUM(Catalog_revenue) AS catalog
FROM marketing_customers;
-- Result: 	   web	      store	     catalog
--	        412976.64	595624.44	348345.18
--  Insight: Most revenue comes from store purchases, showing customers still prefer offline shopping. Web sales are growing but haven’t matched store performance yet, while catalog contributes the least. This suggests the company could increase revenue by strengthening its online channel.


-- 3. CUSTOMER BEHAVIOUR INSIGHT
-- a. Business Question: Analyse the average amount spend by each section of customers segmented by income.
SELECT Inc_group, AVG(Total_Spend)
FROM marketing_customers
GROUP BY Inc_group
ORDER BY AVG(Total_Spend) DESC;
-- Result: 
-- Upper middle	1097.6000
-- Lower middle	1019.0908
-- High income	662.1250
-- Low income	148.0415
-- Insight: Middle-income customers drive the highest spending, with both upper-middle and lower-middle groups contributing far more than others. High-income customers are not spending proportionally more, suggesting the store’s pricing or product mix is better aligned to mid-market shoppers than premium buyers. Low-income customers contribute minimal revenue and are not a key growth segment.


-- b. Business Question: Analyse how much purchases are being done by each age group of customers.
SELECT Age_group, AVG(Total_Purchases)
FROM marketing_customers
GROUP BY Age_group;
-- Result:
-- 40-55	11.1442
-- 55-70	13.1044
-- 70+	    14.5598
-- Under40  12.1905
-- Insight: Spending increases with age — the older the customers, the more they spend on average, with the 70+ group leading. This suggests older customers are the most valuable segment and marketing, loyalty perks, or premium bundles should target them first.


-- 4. CAMPAIGN EFFECTIVENESS
-- a. Business Question: Analyse how effective the different campaigns are.
SELECT 
SUM(Response)/COUNT(*)*100 AS response_rate
FROM marketing_customers;
-- Result: 14.9107
-- Insight: A ~14.9% response rate is actually decent for marketing campaigns — it means roughly 1 in 7 customers engaged. The campaign is working, but there’s still large untapped potential, so improving targeting (age, income, past spend) could significantly boost returns without increasing cost.


-- b. Business Question:  Now Analyse how responsive different customers are based on income to different campaigns.
SELECT Inc_group, AVG(Response)*100 AS response_rate
FROM marketing_customers
GROUP BY Inc_group
ORDER BY response_rate DESC;
-- Result:
-- Upper middle	80.0000
-- Lower middle	17.6521
-- Low income	11.6981
-- High income	0.0000
-- Insight: Upper-middle income customers dominate responses by a huge margin, meaning they’re your real paying audience — they have both capacity and willingness to spend.
-- High-income customers showing 0 response is a red flag: either the campaign doesn’t appeal to them or the product positioning feels too low-value for that segment


-- 5. HIGH VALUE CUSTOMER IDENTIFICATION
-- a. Business Question:  Who are the VIP customers?
SELECT ID, Total_Spend
FROM marketing_customers
ORDER BY Total_Spend DESC
LIMIT 3;


-- RECOMMENDED ACTIONS:
-- Prioritize upper-middle income customers — they respond most and spend consistently, so campaigns should primarily target them for reliable revenue.
-- Improve appeal for high-income customers — reposition products or marketing as premium/value-driven, otherwise this segment will keep ignoring you.
-- Strengthen web channel performance — it underperforms store and catalog, so optimize website UX, pricing visibility, and product presentation to lift conversions.
-- Focus on countries already driving volume (Spain, Saudi, Canada, etc.) before expanding elsewhere — scaling proven markets gives faster ROI than chasing new ones.
-- Shift strategy from attracting more customers to increasing spend per customer — current spend is low compared to income, meaning upselling, bundles, and better product placement should be the next focus.