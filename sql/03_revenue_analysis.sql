SELECT ROUND(SUM(amount),2) total_revenue FROM transactions WHERE payment_status='Paid';
SELECT strftime('%Y-%m',transaction_date) month, ROUND(SUM(amount),2) revenue FROM transactions WHERE payment_status='Paid' GROUP BY month ORDER BY month;
SELECT s.service_name, ROUND(SUM(t.amount),2) revenue FROM transactions t JOIN services s USING(service_id) WHERE t.payment_status='Paid' GROUP BY s.service_name ORDER BY revenue DESC;
SELECT c.region, ROUND(SUM(t.amount),2) revenue FROM transactions t JOIN customers c USING(customer_id) WHERE t.payment_status='Paid' GROUP BY c.region ORDER BY revenue DESC;
WITH m AS (SELECT strftime('%Y-%m',transaction_date) month,SUM(amount) revenue FROM transactions WHERE payment_status='Paid' GROUP BY 1) SELECT month,revenue,ROUND(100.0*(revenue-LAG(revenue) OVER(ORDER BY month))/NULLIF(LAG(revenue) OVER(ORDER BY month),0),2) mom_growth_pct FROM m;
