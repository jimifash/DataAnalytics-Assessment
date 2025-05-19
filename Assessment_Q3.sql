-- Find all active accounts(savings or investments) with no transactions in the last year

-- TABLES: savings_savingsaccount
		-- plans_plan

-- STEPS
-- Get the active accounts
-- categorize as Savings or Investment
-- Get the last transaction and calculate the inactive days
-- Sort by inactivity days in descending order



WITH category AS(
SELECT *,
	CASE
    WHEN is_regular_savings = 1 THEN "Savings"
    WHEN is_a_fund = 1 THEN "Investment"
    END AS type
FROM(
	SELECT id, owner_id, is_a_fund, is_regular_savings
	FROM plans_plan
	WHERE is_a_fund = 1 OR is_regular_savings = 1
    )AS active_accounts
),

last_transaction AS(
 SELECT 
    plan_id,
    MAX(transaction_date) AS last_transaction_date
  FROM savings_savingsaccount
  GROUP BY plan_id
)

SELECT c.id AS plan_id,
		c.owner_id AS owner_id,
        type,
        last_transaction_date,
        DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
        
FROM category c
JOIN savings_savingsaccount s
		ON c.id = s.plan_id
JOIN last_transaction l
		ON l.plan_id = s.plan_id
GROUP BY plan_id
ORDER BY inactivity_days DESC