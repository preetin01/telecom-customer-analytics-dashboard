-- Customer segments: value + loyalty + activity + risk
WITH rev AS (SELECT customer_id, SUM(CASE WHEN payment_status='Paid' THEN amount ELSE 0 END) total_revenue, AVG(CASE WHEN payment_status='Paid' THEN amount END) avg_transaction FROM transactions GROUP BY customer_id),
u AS (SELECT customer_id, AVG(data_gb) avg_data_gb FROM usage GROUP BY customer_id),
co AS (SELECT customer_id, COUNT(*) complaint_count FROM complaints GROUP BY customer_id),
f AS (
SELECT c.*, COALESCE(rev.total_revenue,0) total_revenue, COALESCE(u.avg_data_gb,0) avg_data_gb, COALESCE(co.complaint_count,0) complaint_count
FROM customers c LEFT JOIN rev USING(customer_id) LEFT JOIN u USING(customer_id) LEFT JOIN co USING(customer_id)
)
SELECT customer_id, total_revenue, avg_data_gb, complaint_count, churn_flag,
CASE
 WHEN tenure_months<6 THEN 'New Customers'
 WHEN churn_flag=1 AND total_revenue >= (SELECT AVG(total_revenue) FROM f) THEN 'High Value At Risk'
 WHEN churn_flag=1 THEN 'Low Value At Risk'
 WHEN tenure_months>=24 AND total_revenue >= (SELECT AVG(total_revenue) FROM f) THEN 'High Value Loyal'
 WHEN tenure_months>=24 THEN 'Low Value Loyal'
 ELSE 'Developing Customers' END segment
FROM f;
