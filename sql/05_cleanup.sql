-- 05_cleanup

-- Drop helper column used for deduplication
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;