# Power BI semantic model

## Tables
**Dimensions**
- Customers (customer_id PK)
- Services (service_id PK)
- Date (Date PK)

**Facts**
- Transactions
- Usage
- Complaints
- SupportInteractions
- CustomerServices
- HighRisk (SQL view)
- CustomerSegments (SQL view)

## Relationships
- Customers[customer_id] 1:* Transactions[customer_id]
- Services[service_id] 1:* Transactions[service_id]
- Customers[customer_id] 1:* Usage[customer_id]
- Customers[customer_id] 1:* Complaints[customer_id]
- Customers[customer_id] 1:* SupportInteractions[customer_id]
- Customers[customer_id] 1:* CustomerServices[customer_id]
- Services[service_id] 1:* CustomerServices[service_id]
- Date[Date] 1:* Transactions[transaction_date]
- Date[Date] 1:* Usage[usage_date]
- Date[Date] 1:* Complaints[complaint_date]
- Date[Date] 1:* SupportInteractions[interaction_date]

## Dashboard pages
1. Executive Overview — KPI cards, revenue trend, churn trend, revenue by service, region map/bar, filters.
2. Customer & Churn — churn by contract/tenure/region/demographics, complaint vs churn, usage vs churn.
3. Revenue & Services — monthly revenue, MoM growth, ARPU, service revenue/adoption, customer value.
4. Customer Segmentation — segment size, revenue, churn, segment matrix.
5. Retention & Risk — high-risk count, risk level distribution, risk table with customer, score, drivers.
6. Data Quality — row counts, null/duplicate checks, refresh timestamp, quality flags.

## Slicers
Date, Region, State, Customer Type, Contract Type, Service, Segment, Risk Level.
