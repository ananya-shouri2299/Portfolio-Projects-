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