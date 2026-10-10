-- Data quality checks
SELECT 'customers_nulls' check_name, SUM(customer_id IS NULL)+SUM(signup_date IS NULL)+SUM(gender IS NULL) issue_count FROM customers;
SELECT 'duplicate_customer_ids' check_name, COUNT(*) issue_count FROM (SELECT customer_id FROM customers GROUP BY customer_id HAVING COUNT(*)>1);
SELECT 'negative_transactions' check_name, COUNT(*) issue_count FROM transactions WHERE amount < 0 AND transaction_type <> 'Refund';
SELECT 'invalid_customer_fk' check_name, COUNT(*) issue_count FROM transactions t LEFT JOIN customers c USING(customer_id) WHERE c.customer_id IS NULL;
SELECT 'invalid_service_fk' check_name, COUNT(*) issue_count FROM transactions t LEFT JOIN services s USING(service_id) WHERE s.service_id IS NULL;
SELECT 'churn_date_without_flag' check_name, COUNT(*) issue_count FROM customers WHERE churn_date IS NOT NULL AND churn_flag=0;
SELECT 'churn_before_signup' check_name, COUNT(*) issue_count FROM customers WHERE churn_date IS NOT NULL AND churn_date < signup_date;
SELECT 'negative_usage' check_name, COUNT(*) issue_count FROM usage WHERE data_gb<0 OR voice_minutes<0 OR sms_count<0 OR roaming_minutes<0 OR international_minutes<0;
