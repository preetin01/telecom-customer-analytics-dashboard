# Database schema

## customers
Primary key: `customer_id`

## services
Primary key: `service_id`

## customer_services
Composite primary key: `(customer_id, service_id, subscription_start_date)`.
Foreign keys: customer_id -> customers, service_id -> services.

## transactions
Primary key: `transaction_id`.
Foreign keys: customer_id -> customers, service_id -> services.

## usage
Primary key: `usage_id`.
Foreign key: customer_id -> customers.

## complaints
Primary key: `complaint_id`.
Foreign key: customer_id -> customers.

## support_interactions
Primary key: `interaction_id`.
Foreign key: customer_id -> customers.

## Analytical views
- `customer_segments`
- `high_risk_customers`

The database contains indexes on all high-volume fact foreign keys and transaction/usage dates.
