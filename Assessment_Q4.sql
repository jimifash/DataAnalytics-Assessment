-- CLV = (total_transactions/ tenure_in_months) * 12 * profit_per_transaction(i.e 0.1 of transactional_value)
-- Account tenure(How long the customer has had an account) =  Current_date -  Signup_date 

-- TABLES: users_customuser
		-- savings_savingsaccount
        


-- STEPS:
-- Calculating Account tenure
-- Count the number of successful transactions per customer
-- Calculate average transaction value per customer
-- Apply the CLV formula: (transactions/month) * 12 * avg_profit_per_transaction
-- Sort results to show customers with highest estimated CLV at the top

WITH tenure AS (SELECT id AS Customer_id,
					CONCAT(first_name, ' ', last_name) AS name,
					TIMESTAMPDIFF(month,  created_on, CURDATE()) AS account_tenure
			FROM users_customuser),


transactions AS (SELECT 
	customer_id,
    tenure.name,
    tenure.account_tenure AS tenure_months,
    count(*) AS total_transactions,
    AVG(s.confirmed_amount) AS avg_transaction_value
    
FROM savings_savingsaccount s
LEFT JOIN tenure
	ON s.owner_id = tenure.customer_id
WHERE transaction_status LIKE '%success%'
GROUP BY s.owner_id, tenure.name, tenure.account_tenure
)

SELECT
	customer_id,
    name,
    tenure_months,
    total_transactions,
     ROUND((total_transactions / tenure_months) * 12 * (0.001 * avg_transaction_value), 2) AS estimated_clv
FROM transactions
WHERE tenure_months > 0 -- Null check to avoid zero division errors
ORDER BY estimated_clv DESC