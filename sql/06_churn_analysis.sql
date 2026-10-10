SELECT ROUND(100.0*AVG(churn_flag),2) churn_rate_pct FROM customers;
SELECT gender, COUNT(*) customers, ROUND(100.0*AVG(churn_flag),2) churn_rate_pct FROM customers GROUP BY gender;
SELECT region, COUNT(*) customers, ROUND(100.0*AVG(churn_flag),2) churn_rate_pct FROM customers GROUP BY region ORDER BY churn_rate_pct DESC;
SELECT contract_type, COUNT(*) customers, ROUND(100.0*AVG(churn_flag),2) churn_rate_pct FROM customers GROUP BY contract_type ORDER BY churn_rate_pct DESC;
SELECT CASE WHEN tenure_months<6 THEN '<6m' WHEN tenure_months<12 THEN '6-11m' WHEN tenure_months<24 THEN '12-23m' WHEN tenure_months<36 THEN '24-35m' ELSE '36m+' END tenure_band, COUNT(*) customers, ROUND(100.0*AVG(churn_flag),2) churn_rate_pct FROM customers GROUP BY tenure_band;
WITH cc AS (SELECT customer_id,COUNT(*) complaints FROM complaints GROUP BY customer_id) SELECT CASE WHEN COALESCE(cc.complaints,0)=0 THEN '0' WHEN cc.complaints=1 THEN '1' ELSE '2+' END complaint_band, COUNT(*) customers, ROUND(100.0*AVG(c.churn_flag),2) churn_rate_pct FROM customers c LEFT JOIN cc USING(customer_id) GROUP BY complaint_band ORDER BY complaint_band;
