from pathlib import Path
import sqlite3, pandas as pd

ROOT=Path(__file__).resolve().parents[1]
DB=ROOT/"telecom_analytics.db"
DATA=ROOT/"data"
con=sqlite3.connect(DB)
cur=con.cursor()
cur.executescript("""
PRAGMA foreign_keys=ON;
DROP VIEW IF EXISTS high_risk_customers;
DROP VIEW IF EXISTS customer_segments;
DROP TABLE IF EXISTS support_interactions;
DROP TABLE IF EXISTS complaints;
DROP TABLE IF EXISTS usage;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS customer_services;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS customers;
CREATE TABLE customers(customer_id TEXT PRIMARY KEY,gender TEXT NOT NULL,age INTEGER CHECK(age BETWEEN 18 AND 100),city TEXT,state TEXT,region TEXT,signup_date TEXT NOT NULL,tenure_months INTEGER CHECK(tenure_months>=0),customer_type TEXT,contract_type TEXT,payment_method TEXT,monthly_income REAL CHECK(monthly_income>=0),occupation TEXT,marital_status TEXT,dependents INTEGER CHECK(dependents>=0),churn_flag INTEGER NOT NULL CHECK(churn_flag IN(0,1)),churn_date TEXT);
CREATE TABLE services(service_id TEXT PRIMARY KEY,service_name TEXT NOT NULL,service_category TEXT NOT NULL,monthly_price REAL NOT NULL CHECK(monthly_price>=0));
CREATE TABLE customer_services(customer_id TEXT NOT NULL REFERENCES customers(customer_id),service_id TEXT NOT NULL REFERENCES services(service_id),subscription_start_date TEXT NOT NULL,subscription_end_date TEXT,status TEXT NOT NULL,PRIMARY KEY(customer_id,service_id,subscription_start_date));
CREATE TABLE transactions(transaction_id TEXT PRIMARY KEY,customer_id TEXT NOT NULL REFERENCES customers(customer_id),transaction_date TEXT NOT NULL,service_id TEXT NOT NULL REFERENCES services(service_id),transaction_type TEXT NOT NULL,amount REAL NOT NULL,payment_status TEXT NOT NULL);
CREATE TABLE usage(usage_id TEXT PRIMARY KEY,customer_id TEXT NOT NULL REFERENCES customers(customer_id),usage_date TEXT NOT NULL,data_gb REAL CHECK(data_gb>=0),voice_minutes REAL CHECK(voice_minutes>=0),sms_count INTEGER CHECK(sms_count>=0),roaming_minutes REAL CHECK(roaming_minutes>=0),international_minutes REAL CHECK(international_minutes>=0));
CREATE TABLE complaints(complaint_id TEXT PRIMARY KEY,customer_id TEXT NOT NULL REFERENCES customers(customer_id),complaint_date TEXT NOT NULL,complaint_category TEXT,complaint_channel TEXT,resolution_time_hours REAL CHECK(resolution_time_hours>=0),complaint_status TEXT,severity TEXT);
CREATE TABLE support_interactions(interaction_id TEXT PRIMARY KEY,customer_id TEXT NOT NULL REFERENCES customers(customer_id),interaction_date TEXT NOT NULL,interaction_type TEXT,channel TEXT,resolution_status TEXT,handling_time_minutes INTEGER CHECK(handling_time_minutes>=0));
""")
for name in ["customers","services","customer_services","transactions","usage","complaints","support_interactions"]:
    pd.read_csv(DATA/f"{name}.csv").to_sql(name,con,if_exists="append",index=False)
cur.executescript("""
CREATE INDEX idx_transactions_customer ON transactions(customer_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
CREATE INDEX idx_usage_customer ON usage(customer_id);
CREATE INDEX idx_usage_date ON usage(usage_date);
CREATE INDEX idx_complaints_customer ON complaints(customer_id);
CREATE INDEX idx_support_customer ON support_interactions(customer_id);
CREATE INDEX idx_customer_services_customer ON customer_services(customer_id);
CREATE INDEX idx_customer_services_service ON customer_services(service_id);
""")
con.executescript((ROOT/"sql/08_high_risk_customers.sql").read_text())
con.executescript((ROOT/"sql/07_customer_segmentation.sql").read_text().replace("SELECT customer_id, total_revenue, avg_data_gb, complaint_count, churn_flag,","CREATE VIEW IF NOT EXISTS customer_segments AS SELECT customer_id, total_revenue, avg_data_gb, complaint_count, churn_flag,").replace("FROM f;","FROM f;"))
con.commit(); con.close()
print(f"Created {DB}")
