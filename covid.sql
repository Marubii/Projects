SELECT *
FROM PortfolioProjects.dbo.CovidDeaths
WHERE continent is not null
ORDER BY location, date;



--SELECT *
--FROM PortfolioProjects.dbo.CovidVaccinations
--ORDER BY location, date;



SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjects.dbo.CovidDeaths
ORDER BY 1,2;

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProjects.dbo.CovidDeaths
ORDER BY 1,2;

--probability of dying of covid once you contract it, in Italy
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProjects.dbo.CovidDeaths
WHERE location = 'Italy'
ORDER BY 1,2;

SELECT location, date, total_cases, population, (total_cases/population*100) AS percentage_of_population_infected
FROM PortfolioProjects.dbo.CovidDeaths
-- WHERE location = 'Italy'
ORDER BY 1,2;

-- Finding countries with highest infection rate
SELECT location, population, MAX(total_cases) AS highest_infection_number, MAX((total_cases/population))*100 AS percentage_of_population_infected
FROM PortfolioProjects.dbo.CovidDeaths
-- WHERE location = 'Italy'
GROUP BY location, population
ORDER BY 4 DESC;


SELECT location, population, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM PortfolioProjects.dbo.CovidDeaths
-- WHERE location = 'Italy'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY total_death_count DESC;



 SELECT continent, MAX(CAST(total_deaths AS int)) AS total_death_count
FROM PortfolioProjects.dbo.CovidDeaths
-- WHERE location = 'Italy'
WHERE continent IS NOT NULL
	AND continent NOT LIKE '%income'
GROUP BY continent
ORDER BY total_death_count DESC;


-- A more global view

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_cases, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS death_percentage --date
FROM PortfolioProjects.dbo.CovidDeaths
WHERE continent IS NOT NULL
-- GROUP BY date
ORDER BY 1,2;

-- looking at total population and vaccinations

SELECT death.continent, death.location, death.date, death.population, vax.new_vaccinations
FROM PortfolioProjects.dbo.CovidDeaths AS death
 JOIN PortfolioProjects.dbo.CovidVaccinations AS vax
ON death.location = vax.location
AND death.date = vax.date
WHERE death.continent IS NOT NULL
	AND death.continent NOT LIKE '%income'
ORDER BY 1, 2, 3;

-- CTE

WITH population_and_vaccinations (continent, location, date, population, rolling_people_vaccinated)
AS 
(
SELECT death.continent, death.location, death.date, death.population, SUM(CAST(vax.new_vaccinations AS BIGint)) OVER (PARTITION BY death.location ORDER BY death.date) AS rolling_people_vaccinated
FROM PortfolioProjects.dbo.CovidDeaths AS death
 JOIN PortfolioProjects.dbo.CovidVaccinations AS vax
ON death.location = vax.location
AND death.date = vax.date
WHERE death.continent IS NOT NULL
	AND death.continent NOT LIKE '%income'
)
SELECT *, (rolling_people_vaccinated/population)*100 AS vaccinated_percentage
FROM population_and_vaccinations


-- create view for visualization
CREATE VIEW PopulationAndVaccines AS
SELECT death.continent, death.location, death.date, death.population, SUM(CAST(vax.new_vaccinations AS BIGint)) OVER (PARTITION BY death.location ORDER BY death.date) AS rolling_people_vaccinated
FROM PortfolioProjects.dbo.CovidDeaths AS death
 JOIN PortfolioProjects.dbo.CovidVaccinations AS vax
ON death.location = vax.location
AND death.date = vax.date
WHERE death.continent IS NOT NULL
	AND death.continent NOT LIKE '%income'


