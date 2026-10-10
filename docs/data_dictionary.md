# Data Dictionary

| Table | Column | Meaning |
|---|---|---|
| customers | customer_id | Unique customer key |
| customers | churn_flag | 1 if churned, 0 otherwise |
| customers | churn_date | Date customer churned |
| customers | tenure_months | Months since signup |
| services | monthly_price | Standard monthly list price |
| customer_services | status | Active or Cancelled subscription |
| transactions | amount | Transaction amount; refunds are negative |
| transactions | payment_status | Paid, Pending or Failed |
| usage | data_gb | Monthly data usage |
| usage | voice_minutes | Monthly voice minutes |
| complaints | resolution_time_hours | Hours from complaint to resolution |
| complaints | severity | Low, Medium or High |
| support_interactions | handling_time_minutes | Support handling duration |
| high_risk_customers | risk_score | 0-100 rule-based retention risk score |
| high_risk_customers | risk_level | Low, Medium, High |
