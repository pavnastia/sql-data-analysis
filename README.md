
# SQL Data Analysis

## Overview

This repository contains a collection of SQL queries and analytical case studies completed using **Google BigQuery**.

The work focuses on exploring e-commerce data, analyzing user behavior, calculating business metrics, and developing SQL skills through different analytical tasks.

The repository includes SQL fundamentals, advanced query techniques, query optimization, and data visualization projects using Looker Studio.

## Tools & Technologies

- Google BigQuery
- SQL (GoogleSQL)
- Looker Studio
- Data Analysis & Visualization

## SQL Topics Covered

The repository includes SQL queries organized by topic:

| Topic | Description |
|---|---|
| **[JOINs & Aggregations](01_joins_aggregations)** | Combining tables and calculating business metrics using JOIN, COUNT, SUM, AVG, and GROUP BY |
| **[CASE WHEN](02_sql_case_when)** | Conditional calculations and data classification |
| **[UNION](03_sql_union)** | Combining query results using UNION ALL |
| **[Subqueries](04_sql_subqueries)** | Nested queries and conditional data filtering |
| **[String Functions](05_sql_string_functions)** | Text manipulation and data transformation |
| **[Date & Time Functions](06_sql_date_time_functions)** | Working with dates, timestamps, and time-based metrics |
| **[Window Functions](07_sql_window_functions)** | Ranking, cumulative calculations, and analytical functions |
| **[Common Table Expressions](08_sql_ctes)** | Structuring complex SQL queries using CTEs |
| **[SQL Views](09_sql_views)** | Creating reusable database views |
| **[UNNEST & Nested Data](10_sql_unnest)** | Working with nested and repeated fields in BigQuery |

## Analytical Case Studies

In addition to topic-based SQL queries, the repository includes analytical case studies.

### 1. Email Marketing & User Acquisition Analysis

**[View Case Study](email_marketing_analysis)**

Analyzed user account creation and email marketing activity across different countries.

- Combined data from multiple tables using CTEs and JOINs.
- Calculated email engagement and account creation metrics.
- Analyzed user segments and geographical performance.
- Applied window functions to rank countries.
- Created a Looker Studio dashboard.

### 2. Email Metrics Visualization

**[View Case Study](email_metrics_visualization)**

Prepared an analytical dataset for visualizing e-commerce and email marketing performance.

- Calculated revenue and advertising costs.
- Analyzed sent, opened, and clicked emails.
- Calculated email open and click rates.
- Analyzed account registrations.
- Combined metrics using CTEs and UNION ALL.
- Prepared monthly data for visualization in Looker Studio.

### 3. SQL Query Optimization

**[View Case Study](sql_query_optimization)**

Analyzed and improved SQL query execution performance in Google BigQuery.

- Compared query performance before and after optimization.
- Simplified SQL query structure.
- Reduced intermediate processing steps.
- Analyzed execution time and resource consumption.

**Performance Improvements:**

| Metric | Before | After |
|---|---|---|
| Execution Time | 3.687 s | 1.059 s |
| Slot Time Consumed | 13.154 s | 2.909 s |
| Bytes Shuffled | 57.57 MB | 354 B |

The optimized query demonstrated a **71.3% reduction in execution time** and a **77.9% reduction in slot time consumption**.

Further validation is required to confirm that both query versions produce equivalent analytical results.

## Key Skills Demonstrated

- Writing SQL queries for data analysis
- Combining relational tables using JOINs
- Performing data aggregation and filtering
- Using conditional logic and string functions
- Working with date and timestamp data
- Applying subqueries, CTEs, and window functions
- Analyzing sales, user activity, and email engagement
- Preparing datasets for business intelligence dashboards
- Evaluating SQL query performance
- Creating visualizations in Looker Studio

## Conclusion

This repository demonstrates the practical application of SQL for data exploration, transformation, and business analysis.

It brings together SQL techniques, analytical problem-solving, and data visualization to demonstrate skills relevant to a **Data Analyst** role.
