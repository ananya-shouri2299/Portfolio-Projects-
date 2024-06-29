--likelyhood of people dying
SELECT 
    location, 
    date,
    total_cases,
    total_deaths,
    population,
    (total_deaths/total_cases)*100 AS deaths_percent
FROM 
    covid_deaths
WHERE 
    total_cases IS NOT NULL AND
    location = 'India'
ORDER BY
    location,
    date
