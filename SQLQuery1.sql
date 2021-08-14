
Select Location, date, total_cases, new_cases, total_deaths, population
From covidProject..[covid-deaths]
Where continent is not null 
order by 1,2


--Death Percentage

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From covidProject..[covid-deaths]
Where continent is not null 
order by 1,2


-- Infected Precentage

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentInfected
From covidProject..[covid-deaths]
order by 1,2

-- Countries with Highest Infection Rate wrt to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PopulationInfected
From covidProject..[covid-deaths]
Group by Location, Population
order by PopulationInfected desc

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as DeathCount
From covidProject..[covid-deaths]
Where continent is not null 
Group by Location
order by DeathCount desc

-- Contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From covidProject..[covid-deaths]
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From covidProject..[covid-deaths]
where continent is not null 
order by 1,2



--Population that has recieved at least one Covid Vaccine

With PopvsVacc (Continent, Location, Date, Population, New_Vaccinations, VaccinatedTillDate)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as VaccinatedTillDate
--, (RollingPeopleVaccinated/population)*100
From covidProject..[covid-deaths] dea
Join covidProject..[covid-vaccines] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (VaccinatedTillDate/Population)*100
From PopvsVacc

--View

Create View PopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as VaccinatedTillDate
--, (RollingPeopleVaccinated/population)*100
From covidProject..[covid-deaths] dea
Join covidProject..[covid-vaccines] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
