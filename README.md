# Telecom Customer Analytics Dashboard

Portfolio-ready end-to-end telecom analytics project using **SQL + SQLite + Python/Pandas/NumPy + Matplotlib/Seaborn + Power BI/DAX/Power Query**.

> All customer data is synthetic and designed for portfolio/interview use. It is not production telecom data.

## Business objective
Analyze customer acquisition, demographics, services, usage, transactions, revenue, complaints, churn, segmentation and retention risk.

### Questions answered
- Total / active / churned customers
- Overall churn rate
- Monthly revenue and MoM growth
- ARPU and revenue by service/region
- Churn by contract, tenure, geography and demographics
- Complaint frequency vs churn
- Usage vs churn
- Customer segments
- High-risk customers and retention opportunities

## Dataset
Generated with a fixed random seed for reproducibility.

| Dataset | Rows |
|---|---:|
| customers | 12,000 |
| services | 10 |
| customer_services | 21,291 |
| transactions | 369,981 |
| usage | 207,773 |
| complaints | 2,630 |
| support_interactions | 10,493 |

Synthetic churn rate is **24.36%**. Paid transaction revenue across the 20-month transaction window is **₹194,424,492**.

## Architecture
```text
CSV source data
     |
     +--> SQLite normalized database
     |       |
     |       +--> SQL data quality / revenue / usage / complaint / churn analysis
     |       +--> customer_segments view
     |       +--> high_risk_customers view
     |
     +--> Python EDA
     |       +--> charts
     |
     +--> Power BI
             +--> Power Query transformations
             +--> star-schema semantic model
             +--> DAX measures
             +--> interactive dashboard pages
```

## Repository structure
```text
telecom_customer_analytics/
├── data/
│   ├── customers.csv
│   ├── services.csv
│   ├── customer_services.csv
│   ├── transactions.csv
│   ├── usage.csv
│   ├── complaints.csv
│   ├── support_interactions.csv
│   ├── customer_segments.csv
│   └── high_risk_customers.csv
├── sql/
│   ├── 01_data_quality.sql
│   ├── 02_customer_analysis.sql
│   ├── 03_revenue_analysis.sql
│   ├── 04_usage_analysis.sql
│   ├── 05_complaints_analysis.sql
│   ├── 06_churn_analysis.sql
│   ├── 07_customer_segmentation.sql
│   └── 08_high_risk_customers.sql
├── python/
│   ├── telecom_eda.py
│   ├── telecom_eda.ipynb
│   └── output/charts/
├── powerbi/
│   ├── measures.dax
│   ├── power_query_template.m
│   └── model_and_pages.md
├── docs/
│   ├── data_dictionary.md
│   ├── database_schema.md
│   └── methodology.md
├── scripts/
│   └── setup_database.py
├── telecom_analytics.db
├── requirements.txt
└── README.md
```

## Quick start

### 1. Python
Python 3.11+ is recommended.

```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS/Linux
source .venv/bin/activate

pip install -r requirements.txt
python python/telecom_eda.py
```

The script reads `telecom_analytics.db` and regenerates charts under `python/output/charts/`.

### 2. SQLite
The included `telecom_analytics.db` is ready to query.

Example:
```sql
SELECT contract_type,
       COUNT(*) AS customers,
       ROUND(100.0 * AVG(churn_flag),2) AS churn_rate_pct
FROM customers
GROUP BY contract_type
ORDER BY churn_rate_pct DESC;
```

### 3. Power BI
Open Power BI Desktop.

**Recommended import approach:** load the CSVs from `data/` using Power Query. This keeps the project portable across Windows machines.

Load:
- Customers
- Services
- CustomerServices
- Transactions
- Usage
- Complaints
- SupportInteractions
- CustomerSegments
- HighRiskCustomers

Create the Date table from `powerbi/measures.dax`, then create the relationships documented in `powerbi/model_and_pages.md`.

Paste the DAX measures into the model. The Power Query template in `powerbi/power_query_template.m` contains a reusable folder-ingestion pattern.

## Risk scoring methodology
The portfolio model is intentionally transparent rather than a black-box ML model.

Risk score components:
- Up to 60 points from complaint frequency
- Up to 60 points from support interactions
- 20 points for tenure under 6 months / 12 points for 6–11 months
- 15 points for monthly/prepaid contract
- 15 points for low average data usage
- 5 points for high average monthly revenue

The final score is capped at 100:
- **0–29:** Low
- **30–59:** Medium
- **60–100:** High

This is a prioritization heuristic, not a probability of churn.

## Segmentation logic
- **New Customers:** tenure < 6 months
- **High Value At Risk:** churned + above-average customer revenue
- **Low Value At Risk:** churned + below-average customer revenue
- **High Value Loyal:** tenure ≥ 24 months + above-average revenue
- **Low Value Loyal:** tenure ≥ 24 months + below-average revenue
- **Developing Customers:** remaining customers

The labels are business segments, not ML clusters.

## Suggested Power BI pages
### Executive Overview
KPI cards:
- Total Customers
- Active Customers
- Churn Rate
- Revenue
- ARPU
- High-Risk Customers

Visuals:
- Monthly revenue and MoM growth
- Revenue by service
- Churn by region
- Customer mix

### Customer & Churn
- Churn by contract
- Churn by tenure
- Churn by age group
- Churn by region
- Complaint frequency vs churn
- Usage vs churn

### Revenue & Services
- Revenue trend
- Revenue by service
- Revenue by region
- ARPU by customer type
- Service adoption

### Segmentation
- Segment size
- Segment revenue
- Segment churn
- Segment-level customer table

### Retention & Risk
- High/Medium/Low risk distribution
- Risk score distribution
- High-risk customer table
- Key risk drivers

## Interview discussion points
1. Why SQLite? — It is lightweight, reproducible and removes Docker/cloud dependencies.
2. Why a star schema? — It separates reusable dimensions from transaction/usage/support facts and keeps DAX measures predictable.
3. Why DAX instead of precomputing every KPI in SQL? — Business metrics remain interactive with Power BI filter context.
4. Why a rule-based risk score? — It is explainable and auditable for a portfolio project; a production system could replace it with a validated churn model.
5. How did you avoid random churn? — Churn probability is influenced by contract type, tenure, service count, age and latent customer behavior; complaints/support activity and declining usage are also associated with churn.
6. What would you do next? — Build an ML churn model, calibrate probabilities, add model monitoring, estimate retention ROI and connect to a CRM action workflow.

## Important analytical caveats
- Data is synthetic; relationships are designed to be plausible rather than estimates of a real telecom operator.
- Revenue includes positive charges and negative refunds.
- "ARPU" in the Power BI example is revenue divided by active customers for the selected filter context.
- High-risk score is a heuristic and should not be interpreted as a calibrated churn probability.
