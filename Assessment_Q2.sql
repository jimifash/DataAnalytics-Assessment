-- Calculate the average number of transactions per customer per month and categorize them
-- High Frequency (>= 10 transactions/month)
-- Medium Frequency (3-9 transactions/month)
-- Low Frequency (<= 2 transactions/month)

-- TABLES: users_customuser
		-- savings_savingsaccount
        

-- STEPS
-- Extract the months and count the number of transactions in every month
-- Get the Average transaction per month
-- Categorize the transactions
-- Count the customers in each category 



-- Extract the months and count the number of transactions in every month
WITH monthly_counts AS(
  SELECT 
    owner_id,
    EXTRACT(MONTH FROM transaction_date) AS month,
    COUNT(*) AS transactions_in_month
  FROM savings_savingsaccount
  GROUP BY owner_id, month
),

-- Categorize the transactions
category AS(
SELECT *,
	CASE
    WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
	WHEN avg_transactions_per_month >= 3 THEN 'Medium Frequency'
	ELSE 'Low Frequency'
    END AS frequency_category
FROM(

    -- Get the Average transaction per month 
	SELECT 
	owner_id,
	AVG(transactions_in_month) AS avg_transactions_per_month
	FROM monthly_counts
	GROUP BY owner_id
    ) average_transactions
)
-- Count the customers in each category 
SELECT 
  frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM category
GROUP BY frequency_category
