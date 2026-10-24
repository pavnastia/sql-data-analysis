WITH session_country AS (
    -- Keep unique session-country pairs
    -- to prevent duplicate session metadata from affecting the results
    SELECT DISTINCT
        ga_session_id,
        country
    FROM `data-analytics-mate.DA.session_params`
),


account_base AS (
    -- Retrieve basic account information and account creation session data
    SELECT DISTINCT
        a.id AS account_id,
        s.date AS account_created_date,
        sc.country,
        a.send_interval,
        a.is_verified,
        a.is_unsubscribed
    FROM `data-analytics-mate.DA.account` AS a
    JOIN `data-analytics-mate.DA.account_session` AS acs
        ON a.id = acs.account_id
    JOIN `data-analytics-mate.DA.session` AS s
        ON acs.ga_session_id = s.ga_session_id
    LEFT JOIN session_country AS sc
        ON acs.ga_session_id = sc.ga_session_id
),


email_open_unique AS (
    -- An email can be opened multiple times,
    -- but only unique opened messages are counted
    SELECT DISTINCT
        id_account,
        id_message
    FROM `data-analytics-mate.DA.email_open`
),


email_visit_unique AS (
    -- An email can receive multiple clicks,
    -- but only unique messages with clicks are counted
    SELECT DISTINCT
        id_account,
        id_message
    FROM `data-analytics-mate.DA.email_visit`
),


account_metrics AS (
    -- Calculate account creation metrics
    SELECT
        account_created_date AS date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,

        COUNT(DISTINCT account_id) AS account_cnt,
        0 AS sent_msg,
        0 AS open_msg,
        0 AS visit_msg

    FROM account_base
    GROUP BY
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed
),


email_metrics AS (
    -- Calculate email activity metrics
    SELECT
        DATE_ADD(
            ab.account_created_date,
            INTERVAL es.sent_date DAY
        ) AS date,

        ab.country,
        ab.send_interval,
        ab.is_verified,
        ab.is_unsubscribed,

        0 AS account_cnt,
        COUNT(DISTINCT es.id_message) AS sent_msg,
        COUNT(DISTINCT eo.id_message) AS open_msg,
        COUNT(DISTINCT ev.id_message) AS visit_msg

    FROM `data-analytics-mate.DA.email_sent` AS es
    JOIN account_base AS ab
        ON es.id_account = ab.account_id
    LEFT JOIN email_open_unique AS eo
        ON es.id_account = eo.id_account
        AND es.id_message = eo.id_message
    LEFT JOIN email_visit_unique AS ev
        ON es.id_account = ev.id_account
        AND es.id_message = ev.id_message

    GROUP BY
        date,
        ab.country,
        ab.send_interval,
        ab.is_verified,
        ab.is_unsubscribed
),


unified_metrics AS (
    -- Combine account creation and email activity metrics
    -- into a single dataset using UNION DISTINCT
    SELECT
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        account_cnt,
        sent_msg,
        open_msg,
        visit_msg
    FROM account_metrics

    UNION DISTINCT

    SELECT
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        account_cnt,
        sent_msg,
        open_msg,
        visit_msg
    FROM email_metrics
),


aggregated_metrics AS (
    -- Aggregate account and email metrics when they share
    -- the same date and grouping dimensions
    SELECT
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,

        SUM(account_cnt) AS account_cnt,
        SUM(sent_msg) AS sent_msg,
        SUM(open_msg) AS open_msg,
        SUM(visit_msg) AS visit_msg

    FROM unified_metrics
    GROUP BY
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed
),


country_totals AS (
    -- Calculate country-level totals across the entire period
    SELECT
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        account_cnt,
        sent_msg,
        open_msg,
        visit_msg,

        SUM(account_cnt) OVER (
            PARTITION BY country
        ) AS total_country_account_cnt,

        SUM(sent_msg) OVER (
            PARTITION BY country
        ) AS total_country_sent_cnt

    FROM aggregated_metrics
),


ranked_metrics AS (
    -- Rank countries by total created accounts
    -- and total sent emails
    SELECT
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        account_cnt,
        sent_msg,
        open_msg,
        visit_msg,
        total_country_account_cnt,
        total_country_sent_cnt,

        DENSE_RANK() OVER (
            ORDER BY total_country_account_cnt DESC
        ) AS rank_total_country_account_cnt,

        DENSE_RANK() OVER (
            ORDER BY total_country_sent_cnt DESC
        ) AS rank_total_country_sent_cnt

    FROM country_totals
)


-- Return metrics for countries ranked in the top 10
-- by either account creation or email sending activity
SELECT
    date,
    country,
    send_interval,
    is_verified,
    is_unsubscribed,
    account_cnt,
    sent_msg,
    open_msg,
    visit_msg,
    total_country_account_cnt,
    total_country_sent_cnt,
    rank_total_country_account_cnt,
    rank_total_country_sent_cnt

FROM ranked_metrics
WHERE
    rank_total_country_account_cnt <= 10
    OR rank_total_country_sent_cnt <= 10

ORDER BY
    date,
    country,
    send_interval,
    is_verified,
    is_unsubscribed
