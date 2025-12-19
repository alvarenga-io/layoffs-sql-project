-- Exploratory Analysis 

SELECT * FROM layoffs_staging2;

-- Select largests layoff 
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Display witch companies laid off the biggest amount of people
SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Verify the range date of the data
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Shows total layoffs by industry
SELECT industry , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry 
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT industry, AVG(percentage_laid_off), ROUND(AVG(percentage_laid_off) * 100, 2)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`,1,7) AS 'month', SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC
;

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
GROUP BY `month`;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company DESC, YEAR(`date`) desc ;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

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