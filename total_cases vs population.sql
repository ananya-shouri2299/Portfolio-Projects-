--total_cases vs population
--what percentage of population got covid
SELECT 
    location, 
    date,
    total_cases,
    population,
    (total_cases/population)*100 AS cases_percent
FROM 
    covid_deaths
WHERE 
    total_cases IS NOT NULL AND
    location = 'India'
ORDER BY
    location,
    date
