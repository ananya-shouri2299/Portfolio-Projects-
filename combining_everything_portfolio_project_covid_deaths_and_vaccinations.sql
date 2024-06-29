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

--global_death_count
SELECT

    SUM(new_cases) AS cases,
    SUM(new_deaths) AS deaths,
    SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM
    covid_deaths
WHERE
    new_cases IS NOT NULL AND
    continent IS NOT NULL
--likelihood of people dying
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
--joining the two database
WITH pop_vs_vac (continent, location, date, population, new_vaccinations, rolling_vaccination)
    AS
    (
         SELECT covid_deaths.continent,
                 covid_deaths.location,
                 covid_deaths.date,
                 covid_deaths.population,
                 covid_vaccinations.new_vaccinations,
                 SUM(covid_vaccinations.new_vaccinations)
                 OVER (PARTITION BY covid_deaths.location ORDER BY covid_deaths.location, covid_deaths.date) AS rolling_vaccination

         FROM covid_deaths
                   INNER JOIN
               covid_vaccinations ON
                   covid_deaths.date = covid_vaccinations.date AND covid_deaths.location = covid_vaccinations.location
         WHERE covid_deaths.continent IS NOT NULL
            AND covid_deaths.location = 'India'
         ORDER BY
            covid_deaths.location,
            covid_deaths.date
    )
SELECT
    continent,
    location,
    date,
    population,
    new_vaccinations,
    rolling_vaccination,
    (rolling_vaccination/population)*100 AS vaccination_percent
FROM
    pop_vs_vac
--creating a temp table
DROP TABLE IF EXISTS percent_population_vaccinated

CREATE TABLE percent_population_vaccinated
(
    continent TEXT,
    location TEXT,
    date DATE,
    population NUMERIC,
    new_vaccinations NUMERIC,
    rolling_vaccination NUMERIC

)
INSERT INTO percent_population_vaccinated
SELECT
    covid_deaths.continent,
    covid_deaths.location,
    covid_deaths.date,
    covid_deaths.population,
    covid_vaccinations.new_vaccinations,
    SUM(covid_vaccinations.new_vaccinations)
    OVER (PARTITION BY covid_deaths.location ORDER BY covid_deaths.location, covid_deaths.date) AS rolling_vaccination

FROM covid_deaths
    INNER JOIN
        covid_vaccinations ON
            covid_deaths.date = covid_vaccinations.date AND covid_deaths.location = covid_vaccinations.location
WHERE
    covid_deaths.continent IS NOT NULL
    --AND covid_deaths.location = 'India'
ORDER BY
    covid_deaths.location,
    covid_deaths.date
SELECT
    continent,
    location,
    date,
    population,
    new_vaccinations,
    rolling_vaccination,
    (rolling_vaccination/population)*100 AS vaccination_percent
FROM
    percent_population_vaccinated
--creating a view
CREATE VIEW percent_population_vaccinated AS
SELECT
    covid_deaths.continent,
    covid_deaths.location,
    covid_deaths.date,
    covid_deaths.population,
    covid_vaccinations.new_vaccinations,
    SUM(covid_vaccinations.new_vaccinations)
    OVER (PARTITION BY covid_deaths.location ORDER BY covid_deaths.location, covid_deaths.date) AS rolling_vaccination

FROM covid_deaths
    INNER JOIN
        covid_vaccinations ON
            covid_deaths.date = covid_vaccinations.date AND covid_deaths.location = covid_vaccinations.location
WHERE
    covid_deaths.continent IS NOT NULL