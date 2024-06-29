--Countries with highest infection rate
SELECT 
    location, 
    population,
    MAX(total_cases) AS total_infections,
    (MAX(total_cases/population)) * 100 AS cases_percent 
FROM
    covid_deaths
WHERE
    total_cases IS NOT NULL
GROUP BY
    location, 
    population
ORDER BY
    cases_percent DESC