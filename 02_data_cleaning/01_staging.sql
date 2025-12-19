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