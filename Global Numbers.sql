SELECT 
    
    SUM(new_cases) AS cases,
    SUM(new_deaths) AS deaths,
    SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM 
    covid_deaths
WHERE 
    new_cases IS NOT NULL AND
    continent IS NOT NULL

