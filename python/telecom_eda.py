"""
Telecom Customer Analytics - reproducible EDA
Run: python python/telecom_eda.py
"""
from pathlib import Path
import sqlite3, pandas as pd, numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

ROOT=Path(__file__).resolve().parents[1]
DB=ROOT/"telecom_analytics.db"
OUT=ROOT/"python/output/charts"; OUT.mkdir(parents=True,exist_ok=True)
con=sqlite3.connect(DB)
customers=pd.read_sql("select * from customers",con,parse_dates=["signup_date","churn_date"])
transactions=pd.read_sql("select * from transactions",con,parse_dates=["transaction_date"])
usage=pd.read_sql("select * from usage",con,parse_dates=["usage_date"])
complaints=pd.read_sql("select * from complaints",con,parse_dates=["complaint_date"])
services=pd.read_sql("select * from services",con)
segments=pd.read_sql("select * from customer_segments",con)
risk=pd.read_sql("select * from high_risk_customers",con)
con.close()

customers["age_group"]=pd.cut(customers.age,[17,24,34,44,54,100],labels=["<25","25-34","35-44","45-54","55+"])
monthly=transactions[transactions.payment_status=="Paid"].assign(month=lambda x:x.transaction_date.dt.to_period("M").astype(str)).groupby("month",as_index=False).amount.sum()
churn_contract=customers.groupby("contract_type",as_index=False).churn_flag.mean().assign(churn_rate=lambda x:100*x.churn_flag)
complaint_counts=complaints.groupby("customer_id").size().rename("complaint_count")
cust=customers.set_index("customer_id").join(complaint_counts).fillna({"complaint_count":0}).reset_index()

sns.set_theme(style="whitegrid")
plt.figure(figsize=(10,5)); sns.lineplot(data=monthly,x="month",y="amount",marker="o"); plt.xticks(rotation=45); plt.title("Monthly Revenue"); plt.tight_layout(); plt.savefig(OUT/"monthly_revenue.png",dpi=160); plt.close()
plt.figure(figsize=(8,5)); sns.barplot(data=churn_contract,x="contract_type",y="churn_rate",hue="contract_type",legend=False); plt.ylabel("Churn rate (%)"); plt.title("Churn Rate by Contract Type"); plt.tight_layout(); plt.savefig(OUT/"churn_by_contract.png",dpi=160); plt.close()
plt.figure(figsize=(9,5)); sns.barplot(data=customers.groupby("region",as_index=False).churn_flag.mean().assign(churn_rate=lambda x:100*x.churn_flag).sort_values("churn_rate",ascending=False),x="region",y="churn_rate",hue="region",legend=False); plt.ylabel("Churn rate (%)"); plt.title("Churn Rate by Region"); plt.tight_layout(); plt.savefig(OUT/"churn_by_region.png",dpi=160); plt.close()
plt.figure(figsize=(8,5)); sns.boxplot(data=cust,x="churn_flag",y="tenure_months"); plt.xticks([0,1],["Retained","Churned"]); plt.title("Tenure Distribution by Churn Status"); plt.tight_layout(); plt.savefig(OUT/"tenure_vs_churn.png",dpi=160); plt.close()
plt.figure(figsize=(8,5)); sns.boxplot(data=cust,x="churn_flag",y="complaint_count"); plt.xticks([0,1],["Retained","Churned"]); plt.title("Complaint Frequency vs Churn"); plt.tight_layout(); plt.savefig(OUT/"complaints_vs_churn.png",dpi=160); plt.close()
plt.figure(figsize=(9,5)); sns.barplot(data=services.merge(transactions[transactions.payment_status=="Paid"].groupby("service_id",as_index=False).amount.sum(),on="service_id",how="left"),x="service_name",y="amount",hue="service_name",legend=False); plt.xticks(rotation=35,ha="right"); plt.ylabel("Revenue"); plt.title("Revenue by Service"); plt.tight_layout(); plt.savefig(OUT/"revenue_by_service.png",dpi=160); plt.close()
print("Customers:",len(customers),"Churn rate:",round(customers.churn_flag.mean()*100,2),"%")
print("Revenue:",round(transactions.loc[transactions.payment_status=="Paid","amount"].sum(),2))
print("High-risk customers:",(risk.risk_level=="High").sum())
