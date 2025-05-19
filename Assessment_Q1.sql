-- Goal: Write a query to find customers with at least 
	-- one funded savings plan AND one funded investment plan, 
    -- sorted by total deposits.

-- TABLES: users_customuser
	-- savings_savingsaccount
		-- plans_plan


-- STEPS:
-- 1. Join users with their plans to get customer info and plan types
-- 2. Left join savings accounts to include plans without transactions
-- 3. Count distinct savings and investment plans per customer
-- 4. Sum confirmed amounts as total deposits
-- 5. Filter customers with at least one savings and one investment plan
-- 6. Convert total deposits from kobo to naira and order by total deposits descending

WITH savings_summary AS (
    SELECT 
        u.id AS owner_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
        COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
        SUM(s.confirmed_amount) AS total_kobo
    FROM users_customuser u
    JOIN plans_plan p ON u.id = p.owner_id
    LEFT JOIN savings_savingsaccount s ON p.id = s.plan_id -- Extracts all plans created even if no transaction has been made in the account
    GROUP BY u.id, name
)
SELECT 
    owner_id,
    name,
    savings_count,
    investment_count,
    ROUND(total_kobo / 100.0, 2) AS total_deposits
FROM savings_summary
WHERE savings_count >= 1 AND investment_count >= 1
ORDER BY total_deposits DESC;
