-- Data Cleaning Project: Layoffs Dataset

SELECT * 
FROM layoffs;

-- Cleaning steps overview:
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or blank values
-- 4. Remove any unnecessary columns


-- Create a  staging table with the same columns and no data 
CREATE TABLE layoffs_staging
LIKE layoffs;  

SELECT * 
FROM layoffs_staging;

-- Insert raw data into staging table
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- 01_remove_duplicates


-- Assign row numbers to identify duplicate records
-- Rows with row_num > 1 are considered duplicates
SELECT *,
	ROW_NUMBER() OVER( PARTITION BY company, total_laid_off, percentage_laid_off, `date`) as row_num
FROM layoffs_staging
;

-- Use a CTE to inspect duplicate records
WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER( 
	PARTITION BY company, location, 
	total_laid_off, percentage_laid_off,
	`date`, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging
WHERE company = 'Yahoo';

-- Create a new staging table including a helper column (row_num)
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

-- Trasfer data and add new column
INSERT INTO layoffs_staging2
SELECT * , ROW_NUMBER () OVER
(
	PARTITION BY  company, location, 
    total_laid_off, percentage_laid_off,
    `date`, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num >1;

-- Delete duplicates
DELETE FROM layoffs_staging2
WHERE row_num >1;

-- 02_standardization

-- Remove leading/trailing spaces from company names
SELECT company, TRIM(company) -- Removes additional spaces in the charset 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Checking if industry names are all standardized 
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'
;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country , TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

-- Remove trailing dots from country names
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');-- Convert date column from text to DATE format

ALTER TABLE layoffs_staging2 -- Update column data type after formatting
MODIFY COLUMN `date` DATE ;

SELECT * FROM layoffs_staging2
WHERE total_laid_off;

-- 03_null_handling

-- Identify missing industry values
SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = "Juul"
;

-- Initial manual fixes (applied earlier)
-- These were replaced by a generalized solution
/*
UPDATE layoffs_staging2
SET industry = 'Travel'
WHERE company = 'Airbnb';
UPDATE layoffs_staging2
SET industry = 'Transportation'
WHERE company = 'Carvana';
UPDATE layoffs_staging2
SET industry = 'Consumer'
WHERE company= 'Juul';
*/
-- Manual updates were used initially due to a small number of affected records.
-- Replaced by generalized self-join update

SELECT 
	t1.company,
    t1.industry AS industry_vazia,
    t2.industry AS industry_preenchida
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL
AND t2.industry <> ''
;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL
AND t2.industry <> ''
;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS null;

-- Remove records with insufficient layoff information
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS null;

-- 04_cleanup

-- Drop helper column used for deduplication
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;