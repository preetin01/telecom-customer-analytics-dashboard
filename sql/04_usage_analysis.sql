SELECT ROUND(AVG(data_gb),2) avg_data_gb, ROUND(AVG(voice_minutes),2) avg_voice_minutes, ROUND(AVG(sms_count),2) avg_sms FROM usage;
SELECT strftime('%Y-%m',usage_date) month, ROUND(AVG(data_gb),2) avg_data_gb, ROUND(AVG(voice_minutes),2) avg_voice_minutes FROM usage GROUP BY 1 ORDER BY 1;
SELECT c.region, ROUND(AVG(u.data_gb),2) avg_data_gb, ROUND(AVG(u.voice_minutes),2) avg_voice_minutes FROM usage u JOIN customers c USING(customer_id) GROUP BY c.region;
