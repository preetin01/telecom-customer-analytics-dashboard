SELECT COUNT(*) total_complaints, COUNT(DISTINCT customer_id) affected_customers, ROUND(AVG(resolution_time_hours),2) avg_resolution_hours FROM complaints;
SELECT complaint_category, COUNT(*) complaints, ROUND(AVG(resolution_time_hours),2) avg_resolution_hours FROM complaints GROUP BY complaint_category ORDER BY complaints DESC;
SELECT severity, COUNT(*) complaints FROM complaints GROUP BY severity ORDER BY complaints DESC;
SELECT c.churn_flag, ROUND(AVG(COALESCE(x.complaints,0)),2) avg_complaints_per_customer FROM customers c LEFT JOIN (SELECT customer_id,COUNT(*) complaints FROM complaints GROUP BY customer_id) x USING(customer_id) GROUP BY c.churn_flag;
