CREATE VIEW IF NOT EXISTS high_risk_customers AS
WITH cc AS (SELECT customer_id,COUNT(*) complaint_count FROM complaints GROUP BY customer_id),
si AS (SELECT customer_id,COUNT(*) support_count FROM support_interactions GROUP BY customer_id),
u AS (SELECT customer_id,AVG(data_gb) avg_data_gb FROM usage GROUP BY customer_id),
rev AS (SELECT customer_id,AVG(CASE WHEN payment_status='Paid' THEN amount END) avg_monthly_revenue FROM transactions GROUP BY customer_id),
base AS (
SELECT c.*, COALESCE(cc.complaint_count,0) complaint_count,COALESCE(si.support_count,0) support_count,
COALESCE(u.avg_data_gb,0) avg_data_gb,COALESCE(rev.avg_monthly_revenue,0) avg_monthly_revenue
FROM customers c LEFT JOIN cc USING(customer_id) LEFT JOIN si USING(customer_id) LEFT JOIN u USING(customer_id) LEFT JOIN rev USING(customer_id)
), scored AS (
SELECT *, MIN(100, 20*MIN(3,complaint_count) + 15*MIN(4,support_count) + CASE WHEN tenure_months<6 THEN 20 WHEN tenure_months<12 THEN 12 ELSE 0 END +
CASE WHEN contract_type IN ('Monthly','Prepaid') THEN 15 ELSE 0 END + CASE WHEN avg_data_gb<8 THEN 15 ELSE 0 END + CASE WHEN avg_monthly_revenue>1000 THEN 5 ELSE 0 END) risk_score
FROM base)
SELECT customer_id,risk_score,CASE WHEN risk_score>=60 THEN 'High' WHEN risk_score>=30 THEN 'Medium' ELSE 'Low' END risk_level,
complaint_count,support_count,avg_data_gb,avg_monthly_revenue,region,contract_type,tenure_months,churn_flag
FROM scored;
