

--Select *
--FROM PortfolioProject.dbo.CovidDeaths
--Where continent is not null
--order by 3,4

--Select *
--From PortfolioProject.dbo.CovidVaxx
--order by 3,4

--Select data that we are going to be using

--Select Location, date, total_cases, new_cases, total_deaths, population
--From PortfolioProject..CovidDeaths
--order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract COVID-19 in your country

--Select location, date, total_cases, total_deaths, CONVERT(float, total_deaths/NULLIF(CONVERT(float,total_cases),0))*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
--Where location like '%states%'
--order by 1,2

-- Looking at Total Cases vs Population
--Select location, date, total_cases, population, CONVERT(float, total_cases/NULLIF(convert(float, population),0))*100 as InfectedPercentage
--From PortfolioProject..CovidDeaths
--Where location like '%states%'
--order by 1,2



--Looking at Countries with Highest Infection Rate compared to population

--Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)*100) as PercentPopulationAffected	
--From PortfolioProject..CovidDeaths
--Group by location, population
--order by PercentPopulationAffected desc


-- Showing Countries with highest death count per population

--Select location, MAX(Cast(total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
--Where continent is not null
--Group by location
--order by TotalDeathCount desc



-- Lets break things down by continent
--SHowing the continents with the highest death count per population


--Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
--Where continent is null
--Group by location
--order by TotalDeathCount desc



-- Looking at total population vs vaccinations

-- USE CTE

--With PopVsVac (continent, location, date, population, new_vaccinations, PeopleVaccinated)
--as
--(
--Select  dth.continent, dth.location, dth.date, dth.population, vaxx.new_vaccinations
--, SUM(CONVERT(float, vaxx.new_vaccinations)) OVER (Partition by dth.location Order by dth.location , dth.date) as PeopleVaccinated
--From PortfolioProject..CovidDeaths dth
--Join PortfolioProject..CovidVaxx vaxx
--	On dth.location = vaxx.location
--	and dth.date = vaxx.date
--where dth.continent is not null 
--and new_vaccinations is not null
--order by 2,3
--)

--Select *, (PeopleVaccinated/population)*100 as PercentVaccinated
--From PopVsVac


--TempTable
--DROP Table if exists #PercentPopulationVaccinated 

--Create Table #PercentPopulationVaccinated
--(Continent nvarchar(255), Location nvarchar(255), Date datetime, Population numeric, New_vaccinations numeric, PeopleVaccinated numeric)

--Insert Into #PercentPopulationVaccinated
--Select  dth.continent, dth.location, dth.date, dth.population, vaxx.new_vaccinations
--, SUM(CONVERT(float, vaxx.new_vaccinations)) OVER (Partition by dth.location Order by dth.location , dth.date) as PeopleVaccinated
--From PortfolioProject..CovidDeaths dth
--Join PortfolioProject..CovidVaxx vaxx
--	On dth.location = vaxx.location
--	and dth.date = vaxx.date
--where dth.continent is not null 
--and new_vaccinations is not null
--order by 2,3

--Select *, (PeopleVaccinated/Population)*100
--From #PercentPopulationVaccinated


--Creating View to Store data for later visualizations

--Create View PercentPopulationVaxxed as 
--Select  dth.continent, dth.location, dth.date, dth.population, vaxx.new_vaccinations
--, SUM(CONVERT(float, vaxx.new_vaccinations)) OVER (Partition by dth.location Order by dth.location , dth.date) as PeopleVaccinated
--From PortfolioProject..CovidDeaths dth
--Join PortfolioProject..CovidVaxx vaxx
--	On dth.location = vaxx.location
--	and dth.date = vaxx.date
--where dth.continent is not null 
--and new_vaccinations is not null


--Select *
--From PercentPopulationVaxxed
