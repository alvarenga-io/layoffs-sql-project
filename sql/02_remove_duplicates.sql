-- 02_remove_duplicates


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