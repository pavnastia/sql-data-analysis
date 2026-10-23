# Email Marketing & User Acquisition Analysis

## Project Overview

This project focuses on analyzing user account creation and email marketing activity using **Google BigQuery and SQL**.

The main goal was to calculate key metrics, evaluate email engagement, compare user activity across countries, and identify the top-performing markets.

## Tools Used

- Google BigQuery
- SQL
- Looker Studio

## Analysis Steps

- Combined data from seven tables using SQL JOINs.
- Used CTEs to organize complex queries.
- Calculated the number of created accounts, sent emails, opened emails, and emails with clicks.
- Analyzed user activity by country, date, verification status, subscription status, and email sending interval.
- Applied window functions and `DENSE_RANK()` to identify the top 10 countries by account creation and email activity.
- Prepared an aggregated dataset for visualization in Looker Studio.

## Project Outcome

Created a structured analytical dataset to evaluate user acquisition and email engagement across countries.

The results were used to build a **Looker Studio dashboard** displaying country rankings, key metrics, and email activity trends over time.
