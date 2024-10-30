-- Data Cleaning 

SELECT * 
FROM layoffs;
-- create work Table
CREATE TABLE  layoffs_workt
LIKE layoffs;

SELECT * 
FROM layoffs_workt;
-- insert information 
INSERT layoffs_workt
SELECT* 
FROM layoffs;

-- 1. Delete duplicates
SELECT *,
row_number() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off,`date`) AS  row_num
FROM layoffs_workt;
-- Filter Duplicates
WITH duplicate_cte as 
(
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,  funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1 ; 

SELECT * 
FROM layoffs_workt
WHERE company = "Casper";

-- Create a new work table to filter 
CREATE TABLE `layoffs_workt2` (
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
-
SELECT * 
FROM layoffs_workt2; 
-- insert what was done before in duplicate_cte 
INSERT INTO layoffs_workt2
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,  funds_raised_millions) AS row_num
FROM layoffs_workt;

SELECT * 
FROM layoffs_workt2
WHERE row_num > 1;
-- remove duplicates 
DELETE 
FROM layoffs_workt2
WHERE row_num > 1;


-- 2. STANDARIZING DATA: looking for data quality problems 
-- see spaces in company
SELECT company, (TRIM(company))
FROM  layoffs_workt2; 
-- remove spaces
UPDATE layoffs_workt2
SET company = TRIM(company); 

 -- see industry by unique values
SELECT DISTINCT (industry)
FROM  layoffs_workt2
ORDER BY 1;
-- changes quality problems in values 
-- filter
SELECT DISTINCT (industry)
FROM  layoffs_workt2
WHERE industry LIKE 'Crypto%';
-- update with change
UPDATE layoffs_workt2 
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- check LOCATION 
SELECT DISTINCT (location)
FROM  layoffs_workt2
ORDER BY 1;-- check ok

-- check country 
SELECT DISTINCT (country)
FROM  layoffs_work2
ORDER BY 1;
-- see issue with . in some data
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_workt2
ORDER BY 1 ;  
-- update change
UPDATE layoffs_workt2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE  'United States%';

-- Setting suitable data type
ALTER TABLE layoffs_workt2
MODIFY COLUMN `date` DATE;

-- 3. Manage NUll 
-- check nulls 
SELECT *
FROM layoffs_workt2
WHERE total_laid_off IS NULL
AND  percentage_laid_off IS NULL; 
-- check nulls in industry
SELECT * 
FROM layoffs_workt2
WHERE industry IS NULL 
OR  industry = '';
-- it was found AIrbnb with nulls values  and others
SELECT * 
FROM layoffs_workt2
WHERE company = 'Airbnb';
-- to manage is take the value from other row with the same company name 
-- first check
SELECT * 
FROM layoffs_workt2 AS t1
JOIN layoffs_workt2 AS t2
    ON  t1.company = t2.company -- firts condition
    and t1.location = t2.location -- second condition
WHERE  (t1.industry IS NULL OR t1.industrY = '')
AND t2.industry IS NOT NULL;
-- update information
UPDATE layoffs_workt2
SET industry = NULL 
WHERE industry = '';
-- update changes
UPDATE layoffs_workt2 AS t1
 JOIN  layoffs_workt2 AS t2
     ON t1.company = t2.company 
SET t1.industry = t2.industry -- setting changes
WHERE (t1.industry IS NULL) 
AND t2.industry IS NOT NULL; 

-- check  informacition
SELECT * 
FROM layoffs_workt2
WHERE industry IS NULL 
OR  industry = '';
-- one value null , that just have 1 value 
-- to manage decide to check info in the next columns 
SELECT * 
FROM layoffs_workt2;
SELECT *
FROM layoffs_workt2
WHERE total_laid_off IS NULL
AND  percentage_laid_off IS NULL; 
-- Insecurity   of nulls , due to in not knowledge of layoff lack in those dates
-- corresponding data removing 
DELETE 
FROM layoffs_workt2
WHERE total_laid_off IS NULL
AND  percentage_laid_off IS NULL; 

-- 4.remove unnecesary columns
ALTER TABLE layoffs_workt2
DROP COLUMN row_num; 

