# Methodology

## Data generation
Synthetic customers are generated with plausible demographic, contract, tenure, service, usage and transaction distributions. Churn probability is influenced by customer characteristics rather than sampled uniformly.

## Revenue
Paid transaction amounts are summed by transaction date. Refund transactions are negative and therefore reduce revenue.

## Churn
`churn_flag=1` represents a customer who has churned within the synthetic observation window. The generated population is intentionally around 15–25% churn.

## Complaint analysis
Complaint frequency is aggregated at customer level and compared with churn status. The project reports association, not causation.

## Usage analysis
Data, voice and messaging usage are recorded at approximately monthly customer grain. Churned customers have a mild decline in usage near their churn date.

## Segmentation
Segmentation combines tenure, customer value and churn state. Customer value is based on paid transaction revenue.

## Risk scoring
The risk score is a transparent business heuristic. It uses complaint volume, support activity, tenure, contract type, usage and revenue. It is not a machine-learning probability.

## Power BI
Power BI is used for interactive slicing, KPI calculation and storytelling. SQL is used for reusable analytical logic; Python is used for EDA and visual validation.
