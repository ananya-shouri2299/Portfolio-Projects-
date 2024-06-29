--Countries with highest death count
SELECT 
    location, 
    population,
    MAX(total_deaths) AS total_dead_bodies,
    (MAX(total_deaths/population)) * 100 AS death_percent 
FROM
    covid_deaths
WHERE
    total_deaths IS NOT NULL AND
    continent IS NOT NULL
GROUP BY
    location, 
    population
ORDER BY
    total_dead_bodies DESC
--Continents with highest death count
SELECT 
    location, 
    population,
    MAX(total_deaths) AS total_dead_bodies,
    (MAX(total_deaths/population)) * 100 AS death_percent 
FROM
    covid_deaths
WHERE
    total_deaths IS NOT NULL AND
    continent IS NULL AND
    location NOT LIKE '%income%'
GROUP BY
    location, 
    population
ORDER BY
    total_dead_bodies DESC