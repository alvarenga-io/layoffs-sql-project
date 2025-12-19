-- Exploratory Data Analysis – Layoffs Dataset

-- Retrieve full dataset for initial inspection
SELECT * FROM layoffs_staging2;

-- Identify maximum layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Identify companies that laid off 100% of their workforce
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Aggregate total layoffs by company 
SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Indentify the range date of the dataset
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Aggregate total layoffs by industry
SELECT industry , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry 
ORDER BY 2 DESC;

-- Aggregate total layoffs by year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1;

-- Aggregate total layoffs by company stageeu 
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Calculate average layoff rate by industry
SELECT industry, AVG(percentage_laid_off), ROUND(AVG(percentage_laid_off) * 100, 2)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Analyze monthly layoffs trend
SELECT SUBSTRING(`date`,1,7) AS month, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC
;

-- Calculate cumulative layoffs over time
WITH rolling_total AS 
(
SELECT SUBSTRING(`date`,1,7) AS 'month', SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC
)
SELECT `month`, total_off, SUM(total)OVER(ORDER BY `month`) AS rolling_total
FROM  rolling_total
;

-- Display total layoffs per company per year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company DESC, YEAR(`date`) desc ;

-- Display total layoffs per company (overall)
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Rank top 5 companies by layoffs per year
WITH company_year (company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),
 company_year_ranking AS 
(
SELECT * ,
DENSE_RANK() OVER( PARTITION BY years ORDER BY total_laid_off DESC) as ranking
FROM  company_year
WHERE years IS NOT NULL 
AND total_laid_off IS NOT NULL
)
SELECT * 
FROM company_year_ranking
WHERE ranking <=5
;