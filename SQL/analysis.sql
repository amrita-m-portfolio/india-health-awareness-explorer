-- ============================================================
-- India Health Awareness Explorer - SQL Analysis
-- Table: health_data (loaded from CLEAN_DATA.csv)
-- Columns: State_UT, Area, Glucose_Women_Pct, Glucose_Men_Pct,
--          BP_Women_Pct, BP_Men_Pct, Overweight_Women_Pct,
--          Overweight_Men_Pct, Data_Quality_Flag
-- ============================================================

-- 1. Confirm the table loaded correctly
SELECT * FROM health_data LIMIT 10;

-- 2. National average blood sugar level among women (excluding the
--    'India' row itself, and using Total area only, not Urban/Rural)
SELECT ROUND(AVG(Glucose_Women_Pct), 2) AS national_avg_glucose_women
FROM health_data
WHERE Area = 'Total' AND State_UT != 'India';

-- 3. Rank states by blood pressure in men, highest first
SELECT State_UT, BP_Men_Pct
FROM health_data
WHERE Area = 'Total' AND State_UT != 'India'
ORDER BY BP_Men_Pct DESC
LIMIT 10;

-- 4. Find states above the national average for overweight/obesity in women
--    (this uses a subquery - a query inside a query)
SELECT State_UT, Overweight_Women_Pct
FROM health_data
WHERE Area = 'Total' AND State_UT != 'India'
AND Overweight_Women_Pct > (
    SELECT AVG(Overweight_Women_Pct)
    FROM health_data
    WHERE Area = 'Total' AND State_UT != 'India'
)
ORDER BY Overweight_Women_Pct DESC;

-- 5. Compare Urban vs Rural values within a single state (example: Kerala)
--    Change 'Kerala' to any other state name to explore it
SELECT State_UT, Area, Glucose_Women_Pct, BP_Women_Pct, Overweight_Women_Pct
FROM health_data
WHERE State_UT = 'Kerala';

-- 6. Categorize states into awareness-friendly labels using CASE WHEN
--    (Notice: we avoid words like "worst" or "unhealthy" - see dashboard design rules)
SELECT State_UT, BP_Men_Pct,
CASE
    WHEN BP_Men_Pct >= 30 THEN 'Higher reported level'
    WHEN BP_Men_Pct >= 20 THEN 'Moderate reported level'
    ELSE 'Lower reported level'
END AS BP_Category
FROM health_data
WHERE Area = 'Total' AND State_UT != 'India'
ORDER BY BP_Men_Pct DESC;
