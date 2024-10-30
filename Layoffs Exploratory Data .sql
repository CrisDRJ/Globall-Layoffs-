-- Exploratory Data Analysis
-- Basic Layoffs Analysis: 
SELECT* 
FROM layoffs_staging2;
-- max and min 
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;
-- companys total layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
-- check max total_laid_off
SELECT* 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;
-- see min and max dates of layoffs
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- check by industry the totals of layoffs 
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry 
ORDER BY 2 DESC; 

--  check by date the totals of layoffs 
SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`  
ORDER BY 1 DESC; 
-- check by stage of funds the totals of layoffs 
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC; 
-- desactivation of only full group by 
SET SESSION sql_mode = (SELECT REPLACE(@@SESSION.sql_mode, 'ONLY_FULL_GROUP_BY', ''));
-- identification of industries with the most layoffs in 2023:
SELECT YEAR(`date`) as year, industry, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
WHERE YEAR(`date`) = 2023
GROUP BY industry
ORDER BY total_laid_off DESC;
-- group by company to see the percentaje of layoffs
SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company -- 
ORDER BY 2 DESC;

--  group by month to check  total laid off
SELECT substring(`date`,1,7) AS `month`,SUM(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC;
SELECT MONTH(`date`) AS `month`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
WHERE`date` IS NOT NULL
GROUP BY `month`
ORDER BY total_laid_off DESC;

SELECT * 
FROM layoffs_staging2;

-- accumulate total laif off by month 
WITH Rolling_Total AS
(
SELECT substring(`date`,1,7) AS `month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY 1 ASC
)
SELECT `month`, total_off
 ,SUM(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM Rolling_Total;

-- group by company  , year per total laid off Asc
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;
-- -- group by company  , year per total laid off Desc
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Create a ranking per company #1
WITH Company_Year (company, years, total_laid_off)AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT * , DENSE_RANK () OVER(PARTITION BY years ORDER BY total_laid_off DESC ) AS  Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ASC;

-- Create a ranking per company #2
WITH Company_Year (company, years, total_laid_off)AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS

(SELECT * ,
DENSE_RANK () OVER(PARTITION BY years ORDER BY total_laid_off DESC ) AS  Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5;-- rank filter
