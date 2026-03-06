# 📉 Layoffs Data Cleaning & Analysis (SQL)

## Project Overview
This project demonstrates a complete **end-to-end data pipeline** using MySQL. It transforms a messy, raw dataset of global layoffs (2020-2023) into a structured database.  The goal was to ensure data integrity by removing duplicates, standardizing naming conventions, and handling missing values to provide accurate business insights.

---

## 🛠️ Tech Stack & Skills
* **Database:** MySQL
* **SQL Techniques:** Window Functions (`ROW_NUMBER`), CTEs, Joins, String Manipulation, Date Formatting.
* **Documentation:** Data Dictionary, Business Logic mapping.

---

## 📂 Repository Structure
* `01_raw_data/`: Contains the original CSV and the [Data Dictionary](./01_raw_data/data_dictionary.md).
* `02_data_cleaning/`: SQL scripts for staging, deduplication, and standardization.
* `03_eda/`: Exploratory Data Analysis scripts.
* `04_business_questions/`: SQL queries for [Key Insights](./04_business_questions/insights.md).

---

## 🚀 The Data Cleaning Pipeline
1.  **Staging:** Created a staging table to keep the raw data intact.
2.  **Deduplication:** Used `ROW_NUMBER()` over all columns to identify and remove 100% identical rows.
3.  **Standardization:** * Trimmed whitespace from strings.
    * Unified industry names (e.g., merged 'Crypto' variations).
    * Fixed trailing punctuation in country names.
4.  **Date Conversion:** Converted text-based dates into proper `DATE` format for time-series analysis.
5.  **Null Handling:** Populated missing `industry` values by cross-referencing company names.

---

## 📊 Business Insights (Highlights)
* **Peak Period:** Layoffs spiked significantly in **Q1 2023**.
* **Top Industry:** The **Tech/Consumer** sector was the most affected by volume.
* **Capital vs. Stability:** Even companies with billions in funding (Post-IPO) faced massive staff reductions.

> 📝 **Check out the full [Insights Report](./04_business_questions/insights.md) for detailed queries and findings.**

---

