# Layoffs Data Cleaning Project

## Overview
This project focuses on cleaning and standardizing a dataset containing global layoff information.
The goal is to prepare the data for exploratory data analysis and reporting.

## Dataset
- Source: Layoffs dataset
- Format: SQL table
- Issues identified:
  - Duplicate records
  - Inconsistent text formatting
  - Null and blank values
  - Invalid rows

## Cleaning Steps
1. Created staging tables
2. Removed duplicates using ROW_NUMBER()
3. Standardized text fields (company, industry, country)
4. Converted date fields to proper DATE format
5. Handled null and blank industry values using self-join
6. Removed invalid records

## Tools
- MySQL 8.0
- SQL (Window Functions, CTEs, Joins)

## Next Steps
- Exploratory Data Analysis (EDA)
- Trend analysis by industry and country