
-- ## 🔹 Technical Questionnaire – **BI Analyst Role**

-- > **Instructions:** Please complete the questions below. Where applicable, include SQL queries, screenshots of dashboards (if allowed), or sample outputs.

-- ---

-- ### **Section A: SQL & Data Interpretation (BigQuery Compatible)**

-- 1. **SQL Task:**
--    You have a table `transactions` with the following schema:

--    * `user_id` (STRING)
--    * `transaction_date` (DATE)
--    * `amount` (FLOAT64)
--    * `merchant_name` (STRING)

--    ** Write a SQL query to get the total amount spent by each user in the last 3 months, grouped by merchant.
--    ** Only include users who have transacted more than 3 times in this period.

WITH recent_transactions AS (
    SELECT
        user_id
        , merchant_name
        , amount
        , transaction_date
    FROM
        transactions
    WHERE
        transaction_date >= DATEADD(month, -3, CURRENT_DATE())
)
, user_txn_counts AS (
    SELECT
        user_id
    FROM
        recent_transactions
    GROUP BY
        1
    HAVING
        COUNT(*) > 3
)
SELECT
    A.user_id
    , A.merchant_name
    , SUM(A.amount) AS total_amount
FROM
    recent_transactions A
JOIN
    user_txn_counts B ON A.user_id = B.user_id
GROUP BY
    1, 2
ORDER BY
    1, 2 DESC
;


-- 2. **SQL Analysis:**
--    Based on your query results above, how would you identify the top 3 merchants by revenue for each month?

SELECT
    DATE_TRUNC('month', transaction_date) AS month
    , merchant_name
    , SUM(amount) AS total_revenue
FROM
    transactions
WHERE
    transaction_date >= DATEADD(month, -3, CURRENT_DATE())
GROUP BY
    1, 2
QUALIFY
    ROW_NUMBER() OVER (PARTITION BY month ORDER BY SUM(amount) DESC) <= 3
ORDER BY
    1, 2 DESC
;

-- ---

-- ### **Section B: Dashboarding & BI Tools**

-- 3. **Dashboard Task:**
--    Imagine your stakeholder wants to understand how customer engagement varies across merchants and weekdays.

--    * What charts would you use?
--    * What filters or drill-downs would you provide?
--    * Describe how you would approach building this in Tableau or Redash.

-- 4. **KPI Design:**
--    A marketing team wants to measure the success of a new campaign.

--    * What KPIs would you recommend tracking?
--    * How would you attribute changes in performance to the campaign?

-- ---

-- ### **Section C: Case Question**

-- 5. **Business Insight Case:**
--    You observe a 20% drop in redemption rates for a loyalty program this month.
--
--    * What steps would you take to investigate this?
--    * What kinds of data would you look at?

-- Answer:
-- 1. Quantify the drop: Confirm the 20% decrease by comparing current and previous months’ redemption rates.
-- 2. Segment analysis: Break down redemption rates by member (e.g., between sign up early or late, tier) to identify where the drop is most pronounced.
-- 3. Funnel analysis: Examine each step in the redemption process to locate where drop-offs increased.
-- 4. Campaign and offer review: Check if there were changes in loyalty offers, campaign communication, or eligibility criteria.
-- 5. External factors: Investigate seasonality, competitor promotions, or macroeconomic events that could impact customer behavior.

-- Data to review:
-- - Historical redemption rates (daily/weekly/monthly)
-- - Member Dimension data, like tier, sign up
-- - Loyalty program offer details and changes
-- - Marketing campaign logs and communications

-- ---

