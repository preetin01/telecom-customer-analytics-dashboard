SELECT COUNT(*) total_customers, SUM(churn_flag) churned_customers, COUNT(*)-SUM(churn_flag) active_customers, ROUND(100.0*SUM(churn_flag)/COUNT(*),2) churn_rate_pct FROM customers;
SELECT region, COUNT(*) customers, ROUND(100.0*AVG(churn_flag),2) churn_rate_pct FROM customers GROUP BY region ORDER BY churn_rate_pct DESC;
SELECT contract_type, COUNT(*) customers, ROUND(100.0*AVG(churn_flag),2) churn_rate_pct FROM customers GROUP BY contract_type ORDER BY churn_rate_pct DESC;
SELECT CASE WHEN age<25 THEN '<25' WHEN age<35 THEN '25-34' WHEN age<45 THEN '35-44' WHEN age<55 THEN '45-54' ELSE '55+' END age_group, COUNT(*) customers, ROUND(100.0*AVG(churn_flag),2) churn_rate_pct FROM customers GROUP BY age_group ORDER BY age_group;
