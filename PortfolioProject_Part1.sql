# Create databe or Schema called portfolioproject
Create database portfolio;
#use the database;
use portfolioproject;

# Import two files called coviddeaths and covidvaccination (CSV)

#Querry the data base
select * from coviddeaths
order by 2,3;

select * from covidvaccinations
order by 2,3;

-- Select Data that we are going to be using
select Location, date, total_cases, new_cases, total_deaths, population 
from coviddeaths
order by 1,2;

-- Looking at total cases vs Total Deaths
-- This  shows a likelihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths, format((total_deaths/total_cases),4)* 100 as DeathPercentage
from coviddeaths
-- where location like '%ame%'
order by 1,2;

-- Looking at Total Cases vs Population
-- Show what percentage of population got covid
select Location, date, total_cases, Population, format((total_Cases/population),4)* 100 as TotalCasePercentage
from coviddeaths
-- where location like '%south%'
order by 1,2;

-- Looking at countries with highest population rate compared to Population
select Location, Population, MAX(total_cases) HighestInfectionCount,
 format((total_Cases/population),3)* 100 as TotalCasePercentage
from coviddeaths
-- where location like '%south
group by Location, Population
order by HighestInfectionCount desc;

-- Showing countries with highest death count per population
select Location,  MAX(cast(total_deaths as unsigned)) as TotalDeathCount
from coviddeaths
group by Location
order by TotalDeathCount desc;

-- Lets Break things down by continent

select Location, Population, MAX(total_cases) HighestInfectionCount,
 format((total_Cases/population),3)* 100 as TotalCasePercentage
from coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

-- Global numbers
select date, SUM(total_cases) total_cases,SUM(new_deaths)  total_death, SUM(cast((New_deaths/new_cases)as unsigned))* 100 as DeathPercentage
from coviddeaths
-- where location like '%south%'
group by date
order by 1,2;

-- Joining the two tables using inner join
-- Looking at total population vs Vaccination 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from portfolioproject.coviddeaths dea
join portfolioproject.covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
Where dea.continent is not null
order by 1,2,3;

-- use CTE to get vaccination per population

with popvsvac (continent, location, date, population,new_vaccination, VacPerPopulation)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, count(dea.population) as VacperPopulation
from portfolioproject.coviddeaths dea
join portfolioproject.covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
Where dea.continent is not null
-- order by 1,2,3
)
select *from popvsvac;

-- Create a Temp table

Create table PercentPopulationVaccinated
(
continent varchar(30),
Location varchar(30),
Date datetime,
Population varchar(30)
)
insert into PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from portfolioproject.coviddeaths dea
join portfolioproject.covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
Where dea.continent is not null;

-- Creating to view to store data for later visualisation in Tablue

create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from portfolioproject.coviddeaths dea
join portfolioproject.covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
Where dea.continent is not null;

select *from
percentPopulationVaccinated;







