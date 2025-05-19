Per-Question Explanations: Explain your approach to each question.
Challenges: Document any particular difficulties you encountered and how you resolved them.


## ASSESSMENT_Q1:
#### GOAL:
Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

#### APPROACH:
After examining the database schema and understanding the purpose of each relevant column and table, I identified the necessary tables: users_customuser, plans_plan, and savings_savingsaccount.

I joined these tables to associate customers with their plans and related transactions. To ensure each plan was counted only once, I used the DISTINCT clause when counting plans.

I calculated total deposits by summing the confirmed amounts from savings accounts. Since these amounts were stored in kobo, I converted them to naira by dividing by 100 and rounding to two decimal places.

Finally, I filtered the results to include only customers who have at least one savings plan and one investment plan and sorted the output by total deposits in descending order.

## ASSESSMENT_Q2:
#### GOAL:
Calculate the average number of transactions per customer per month and categorize customers into frequency groups:

High Frequency (≥ 10 transactions/month)
Medium Frequency (3–9 transactions/month)
Low Frequency (≤ 2 transactions/month)

#### APPROACH:
I began by analyzing the relevant tables, focusing on savings_savingsaccount for transaction records and users_customuser for customer details.

To measure transaction frequency, I first extracted transactions grouped by customer and month using the EXTRACT(MONTH FROM transaction_date) function. This allowed me to count the total number of transactions each customer made in every month.

Next, I calculated each customer's average transactions per month by averaging their monthly transaction counts.

I then categorized customers based on their average monthly transaction count using a CASE statement with the defined frequency thresholds.

Finally, I grouped the results by these categories and calculated the number of customers in each group, along with the average transactions per month per category, rounding to one decimal place for clarity.



## ASSESSMENT_Q3:
#### GOAL:
Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .

#### APPROACH:
I started by filtering the plans_plan table to get only active accounts, which are identified by flags is_regular_savings or is_a_fund. I categorized each account as either "Savings" or "Investment" using a CASE statement for clarity and placed it all in a CTE.

Next, I made a subquery for the most recent transaction date for each plan by grouping transactions from savings_savingsaccount.

I then joined the active accounts with their last transaction date and calculated the number of days since that transaction to measure inactivity, using DATEDIFF against the current date.

Finally, I sorted the results by inactivity days in descending order to highlight the accounts that have been inactive the longest.



## ASSESSMENT_Q4:
#### GOAL:
For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
Account tenure (months since signup)
Total transactions
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
Order by estimated CLV from highest to lowest


#### APPROACH:
I structured the query using two main Common Table Expressions (CTEs) for clarity and modularity:

tenure CTE: Calculated each customer's account tenure in months by subtracting their signup date (created_on) from the current date. It also concatenated their first and last names for easier reference.

transactions CTE: Joined the savings_savingsaccount table with the tenure CTE to get each customer’s total count of successful transactions and their average transaction value. The join was on customer ID to align transaction data with account tenure.

Using these CTEs, I applied the CLV formula in the final SELECT:

 CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction
where profit per transaction is 0.1% of the average transaction value (i.e., multiplied by 0.001).

I included a filter to exclude customers with zero or undefined tenure to prevent division errors and sorted customers by their estimated CLV in descending order to highlight the most valuable customers.

## CHALLENGES
-- Joining tha Data Across Different tables accurately, ensuring the correct join keys and alias was used posed a little challenge. To resolve this, I carefully  validated the table schemas and join conditions before finalizing my query

-- Structuring the query into multiple CTEs and subqueries to calculate tenure, transaction counts, and averages step-by-step was challenging. I ensured each CTE had a clear purpose and validated intermediate results to maintain accuracy and clarity in the final output.