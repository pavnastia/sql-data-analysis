# SQL Query Optimization | Google BigQuery

## Overview

This project focuses on optimizing a SQL query in Google BigQuery to improve execution performance and reduce computational resource usage.

The query analyzes email engagement metrics, including sent emails, opened emails, clicks, open rates, click rates, and click-to-open rates across operating systems.

## Tools Used

- Google BigQuery
- SQL
- Query Execution Plan
- Performance Analysis

## Optimization Process

The optimization involved:

- Simplifying the SQL query structure;
- Reducing intermediate processing steps;
- Moving metric calculations into the final SELECT statement;
- Analyzing query performance before and after optimization.

## Performance Comparison

| Metric | Before | After | Improvement |
|---|---|---|---|
| Execution Time | 3.687 s | 1.059 s | 71.3% reduction |
| Slot Time Consumed | 13.154 s | 2.909 s | 77.9% reduction |
| Bytes Shuffled | 57.57 MB | 354 B | Over 99.99% reduction |
| Output Rows | 6 | 6 | Unchanged |

## Project Documentation

📄 **[Google Docs — SQL Query Optimization Report](https://docs.google.com/document/d/16EZE2aR33uDjVB4XZgWn80AbPCSQ4nxF4Gw19Bk_2JI/edit?usp=sharing)**

The document includes the original and optimized SQL queries, BigQuery execution plan screenshots, performance comparisons, and conclusions.

## Conclusion

The optimized query demonstrated significantly improved execution performance, reducing execution time by 71.3% and slot time consumption by 77.9%.

Data shuffling was also reduced by more than 99.99%, indicating a substantial decrease in intermediate data processing.

Both queries returned six rows. However, further validation is required to confirm that the optimized query produces the same metric values as the original version.
