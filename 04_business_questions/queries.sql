-- Identify most impacted industry by total layoffs

SELECT industry, 
		SUM(total_laid_off) as total_layoffs
FROM layoffs_staging2
WHERE industry IS NOT NULL
GROUP BY industry
ORDER BY total_layoffs DESC;

-- Answer whether the layoffs happened over time or all at once
SELECT industry, 
		YEAR(`date`) as year,
        SUM(total_laid_off) as total_layoffs
FROM layoffs_staging2
WHERE industry IS NOT NULL
GROUP BY industry, year
ORDER BY total_layoffs DESC;

-- Answer if the top industry is winning by far
-- 

