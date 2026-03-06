
# Data Dictionary - Layoffs Project

This document provides a detailed description of the columns in the `layoffs_staging2` table, the final cleaned version of the dataset.

| Column | Data Type | Description |
| :--- | :--- | :--- |
| **company** | `VARCHAR` | The name of the company that announced layoffs. |
| **location** | `VARCHAR` | The specific city of the company. |
| **industry** | `VARCHAR` | The business sector the company operates in (e.g., Tech, Finance, Retail). |
| **total_laid_off** | `INT` | The total number of employees laid off in that specific event. |
| **percentage_laid_off** | `DECIMAL/FLOAT` | The proportion of the workforce laid off (from 0 to 1). |
| **date** | `DATE` | The date when the layoff was officially announced. |
| **stage** | `VARCHAR` | The funding stage of the company (e.g., Series B, Post-IPO, Seed). |
| **country** | `VARCHAR` | The country where the company is located. |
| **funds_raised_millions** | `INT` | Total amount of capital raised by the company in millions of USD. |

---

### Data Quality Notes
* **Standardization:** The `industry` and `country` fields were cleaned to fix variations (e.g., "Crypto", "Crypto Currency", and "CryptoCurrency" were merged into a single category).
* **Missing Values:** In cases where `total_laid_off` was null, those records were kept for trend analysis but excluded from summation metrics.
