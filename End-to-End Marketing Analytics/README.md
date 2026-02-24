# Marketing Campaign Performance & Customer Revenue Analysis

---

## Business Objective

The objective of this project is to analyze customer demographics, purchasing behavior, and marketing campaign performance to identify revenue-driving segments and improve marketing effectiveness.

### The goal is to answer:

- Which customer segments generate the most revenue?
- Which sales channel performs best?
- How effective are marketing campaigns?
- Where should the business focus to increase revenue?

---

## Dataset Description

The dataset contains customer-level data including:

- Demographics (Age, Education, Marital Status, Income, Country)
- Purchase behavior (Product spend, Channel purchases)
- Campaign response indicators
- Customer tenure and recency
- Derived fields such as Total Spend, Revenue by Channel, Income Group, Age Group  

**Total records analyzed:** ~2,200+ customers

---

## Tools & Technologies Used

### Excel
- Data cleaning
- Feature engineering (Total Spend, Income Group, Age Group)
- Pivot table analysis

### MySQL
- Aggregations (Revenue, Avg Income, Response Rate)
- Customer segmentation analysis
- Channel performance metrics

### Python (Pandas, Matplotlib, Seaborn)
- Missing value analysis
- Distribution plots (Age, Income, Spend)
- Correlation heatmap
- Segment-based revenue visualization

### Power BI
- KPI dashboard (Total Revenue, Avg Order Value, Conversion %)
- Channel & product revenue analysis
- Campaign response tracking
- Drillthrough and tooltip features for interactive insights

---

## Key Findings

- Physical stores generate the highest revenue, followed by catalog sales, while web revenue is comparatively lower.
- Middle-aged and upper/lower-middle income groups contribute the largest share of total revenue.
- Average customer income (~52K) is significantly higher than average spend (~500), indicating untapped purchasing potential.
- Marketing campaign response rate is ~15%, showing moderate effectiveness but room for improvement.

---

## Business Recommendations

- Prioritize store-based promotions and loyalty programs, as stores drive the majority of revenue.
- Improve digital channel strategy to increase web-based sales.
- Focus targeted marketing on middle-aged, mid-income customers who generate the highest revenue.
- Implement personalized offers to increase spending per customer rather than focusing only on customer acquisition.
- Optimize campaign targeting to improve response rate and marketing ROI.

---

## Conclusion

The analysis highlights that revenue growth can be driven by optimizing high-performing customer segments and strengthening underperforming channels like web sales. By combining customer segmentation and channel strategy, the business can improve campaign effectiveness and overall profitability.

---

## Files Included

- `marketing_analysis.csv` – raw data 
- `marketing_data_cleaned.csv.xlsx` – Initial data cleaning, feature engineering, and pivot analysis 
- `analysis_queries.sql` – SQL queries used for segmentation and performance analysis  
- `Marketing_Customers.ipynb` – Python notebook containing EDA, visualizations, and insights  
- `End_to_End.pbix` – Power BI dashboard file with KPIs and interactive visuals  
- `README.md` – Project documentation and summary