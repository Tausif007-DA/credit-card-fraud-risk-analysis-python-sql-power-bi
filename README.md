# credit-card-fraud-risk-analysis-python-sql-power-bi

An end-to-end data analysis project on 1.29 million+ credit card transactions to detect fraud patterns, engineer risk features, and build production-ready SQL views for business intelligence.

---

## Project Overview

This project analyzes real-world-style credit card transaction data to answer one core business question: **what separates a fraudulent transaction from a legitimate one?**

The analysis covers exploratory data analysis, feature engineering, behavioral and temporal pattern detection, demographic profiling, and 10 SQL analytical views ready to deploy in any data warehouse.

**Important:** Only 0.58% of transactions are fraudulent. This severe class imbalance means accuracy is a useless metric here. All model evaluation must use Precision-Recall.

---

## Dataset

- Total Records: 1,296,675 transactions
- Fraud Cases: 7,506 (0.58%)
- Legitimate Cases: 1,289,169 (99.42%)
- Time Span: January 2019 to December 2020
- Coverage: All 50 US States
- Source: Simulated Credit Card Transaction Dataset (Kaggle)

---

## Files in This Repository

- `CREDIT_CARD_RISK_ANALYSIS.ipynb` — Main analysis notebook with full EDA and visualizations
- `credit_card_sql.sql` — PostgreSQL table schema and 10 analytical SQL views
- `README.md` — This file

---

## Feature Engineering

Seven new columns were created from the raw data:

- `age` — Calculated from date of birth (2026 minus birth year)
- `hour` — Hour extracted from transaction timestamp
- `distance` — Haversine distance in km between cardholder location and merchant location
- `avg_amt_per_user` — Each cardholder's average transaction amount (grouped by cc_num)
- `amt_deviation` — How much the current transaction deviates from the cardholder's personal average
- `distance_bin` — Distance bucketed into 5 ranges for categorical analysis
- `age_group` — Age bucketed into groups: 0-25, 26-35, 36-50, 51-65, 65+

---

## Key Findings

**Time-based patterns**
- Midnight to 3AM is the highest fraud risk window, roughly 3.5x higher than daytime
- Weekend fraud rate is 25% higher than weekdays
- Fraud spikes in Q4 (October to December) during holiday shopping season

**Category risk**
- grocery_pos has the highest fraud rate at 1.18%
- shopping_net and misc_net follow at 0.92% and 0.87%
- These two categories alone drive over 40% of all fraud cases

**Demographics**
- Customers aged 65+ are 38% more vulnerable than the 18-25 age group
- Gender difference is marginal and not a reliable signal on its own
- High-risk occupations include Material Movers, Sales Executives, and Professional Drivers

**Transaction signals**
- Transactions above $200 have 2x the fraud rate of transactions below $50
- The amt_deviation feature is a strong real-time fraud signal
- Cards with more than one fraud incident represent systemic compromise

**Geographic signals**
- Transactions over 2,000 miles from the cardholder's home carry a 94%+ fraud rate
- Small cities (population under 5,000) show 38% higher fraud rates than large cities

---

## SQL Views Built

All views are defined in `credit_card_sql.sql` and ready to run on PostgreSQL.

| View | Purpose |
|---|---|
| Daily_Fraud_Trend | Track daily fraud rate to catch emerging spikes |
| fraud_pattern | Monthly aggregation for seasonal reporting |
| fraud_merchants | Top 10 highest-risk merchants |
| fraud_by_city | Compare fraud rates across small, mid, and large cities |
| Same_Card | Cards with repeated fraud events |
| repeat_fraud | First fraud timestamp and total fraud count per card |
| High_Value_Fraud | Fraud rate broken down by transaction amount bucket |
| Transaction_Frequency | Top cards by transaction volume for anomaly detection |
| State_Category_Combined | State and category cross-tab for regional risk mapping |
| Weekend_vs_Weekday_Fraud | Day-of-week fraud rate comparison |


**3. Download the dataset**

Get the CSV from Kaggle (Credit Card Transactions Fraud Detection dataset) and place it in the project folder.



## Tech Stack

- Python 3.10+
- Pandas, NumPy
- Matplotlib, Seaborn
- PostgreSQL 14+
- SQLAlchemy, psycopg2
- Jupyter Notebook

---

## Business Recommendations

1. Activate stronger authentication for all transactions between 12AM and 3AM
2. Set up real-time alerts using the amt_deviation feature to catch spend anomalies instantly
3. Auto-flag any transaction occurring more than 2,000 miles from the cardholder's home address
4. Apply enhanced monitoring rules to grocery_pos and shopping_net categories
5. Launch targeted fraud awareness programs for customers aged 65 and above
6. Schedule fraud operations staffing peaks on weekend nights for maximum coverage

---

## Author
TAUSIF RAZA
