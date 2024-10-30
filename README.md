# Layoff Trends Analysis Project

This project explores company layoffs data, focusing on industries, dates, and stages of companies affected by layoffs. Using SQL, the analysis includes data cleaning, transformation, and exploratory data insights to understand layoffs by industry, date, company stage, and company rankings over time.

## Project Structure

### 1. Data Preparation and Cleaning
- **Working Table**: Established a `layoffs_workt2` table to safely modify data without altering the original dataset.
- **Duplicate Removal**: Identified and removed duplicates using `row_number()` partitioned by key columns.
- **Data Standardization**: Standardized values in `company`, `industry`, and `country` columns to ensure consistency.
- **Data Type Conversion**: Converted the `date` column from text to `DATE` for temporal analysis.
- **Null Value Handling**: Replaced null values in the `industry` column with available data from other rows, removing rows with non-repairable nulls in essential columns.

### 2. Exploratory Data Analysis (EDA)
- **Key Metrics**:
  - **Company Layoffs**: Identified companies with the highest layoffs, such as Amazon and Google.
  - **Layoffs by Industry**: Consumer and Retail industries had the largest layoffs.
  - **Stage-Based Layoff Trends**: Post-IPO companies experienced the most layoffs, indicating restructuring in established firms.
  - **Monthly Layoffs**: Layoffs peaked in January, showing a start-of-year trend in workforce adjustments.
  - **Yearly Top Companies**: Tracked top companies in layoffs per year, highlighting yearly trends and industry-specific shifts.

### 3. Data Insights
- **Temporal Trends**: Identified monthly and annual peaks in layoffs, especially in the first quarter and November.
- **Industry-Specific Impact**: Consumer and Retail sectors were highly impacted, with significant workforce reductions.

## Key Findings
- **Highest Layoffs by Industry**: Consumer and Retail industries experienced major layoffs.
- **Top Companies by Layoffs**: Companies such as Amazon, Meta, and Microsoft saw significant layoff totals.
- **Layoff Stages**: Post-IPO companies had the largest workforce reductions, indicating trends in restructuring after public offerings.
