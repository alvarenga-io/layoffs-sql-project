-- 04_null_handling

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
