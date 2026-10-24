
-- ============================================================
-- Email Metrics & Revenue Visualization
-- Topics: CTEs, JOIN, UNION ALL, DATE_ADD,
-- DATE_TRUNC, SUM, COUNT DISTINCT, SAFE_DIVIDE
-- Dataset: E-commerce (Google BigQuery)
-- ============================================================


-- 1. Daily Revenue
-- Calculate total revenue from product orders by date.

WITH revenue_usd AS (
    SELECT
        s.date,
        SUM(p.price) AS revenue
    FROM `data-analytics-mate.DA.order` AS o
    JOIN `data-analytics-mate.DA.product` AS p
        ON o.item_id = p.item_id
    JOIN `data-analytics-mate.DA.session` AS s
        ON o.ga_session_id = s.ga_session_id
    GROUP BY s.date
),


-- 2. Email Engagement Metrics
-- Calculate the number of sent, opened, and clicked emails.
-- Convert email sending offsets into actual dates.

email_metrics AS (
    SELECT
        DATE_ADD(
            s.date,
            INTERVAL ems.sent_date DAY
        ) AS sent_date,

        COUNT(DISTINCT ems.id_message) AS sent_msg,
        COUNT(DISTINCT eo.id_message) AS open_msg,
        COUNT(DISTINCT ev.id_message) AS click_msg

    FROM `data-analytics-mate.DA.email_sent` AS ems
    JOIN `data-analytics-mate.DA.account_session` AS acs
        ON ems.id_account = acs.account_id
    JOIN `data-analytics-mate.DA.session` AS s
        ON acs.ga_session_id = s.ga_session_id
    LEFT JOIN `data-analytics-mate.DA.email_open` AS eo
        ON ems.id_message = eo.id_message
        AND ems.id_account = eo.id_account
    LEFT JOIN `data-analytics-mate.DA.email_visit` AS ev
        ON ems.id_message = ev.id_message
        AND ems.id_account = ev.id_account

    GROUP BY sent_date
),


-- 3. Account Registrations
-- Count registered accounts by session date.

registrations AS (
    SELECT
        s.date,
        COUNT(ac.account_id) AS account_cnt
    FROM `data-analytics-mate.DA.account_session` AS ac
    JOIN `data-analytics-mate.DA.session` AS s
        ON ac.ga_session_id = s.ga_session_id
    GROUP BY s.date
),


-- 4. Combine All Metrics
-- Combine revenue, advertising costs, email activity,
-- and registrations into a unified dataset.

final AS (
    SELECT
        date,
        revenue,
        0 AS cost,
        0 AS sent_msg,
        0 AS open_msg,
        0 AS click_msg,
        0 AS account_cnt
    FROM revenue_usd

    UNION ALL

    SELECT
        date,
        0 AS revenue,
        cost,
        0 AS sent_msg,
        0 AS open_msg,
        0 AS click_msg,
        0 AS account_cnt
    FROM `data-analytics-mate.DA.paid_search_cost`

    UNION ALL

    SELECT
        sent_date AS date,
        0 AS revenue,
        0 AS cost,
        sent_msg,
        open_msg,
        click_msg,
        0 AS account_cnt
    FROM email_metrics

    UNION ALL

    SELECT
        date,
        0 AS revenue,
        0 AS cost,
        0 AS sent_msg,
        0 AS open_msg,
        0 AS click_msg,
        account_cnt
    FROM registrations
)


-- 5. Monthly Metrics for Looker Studio
-- Aggregate metrics by month and calculate
-- email open and click rates.

SELECT
    DATE_TRUNC(date, MONTH) AS date,
    SUM(revenue) AS revenue,
    SUM(cost) AS cost,
    SUM(sent_msg) AS sent_msg,

    SAFE_DIVIDE(
        SUM(open_msg),
        SUM(sent_msg)
    ) AS open_rate,

    SAFE_DIVIDE(
        SUM(click_msg),
        SUM(sent_msg)
    ) AS click_rate,

    SUM(account_cnt) AS registrations

FROM final
GROUP BY date
ORDER BY date;
