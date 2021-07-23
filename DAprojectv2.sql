

--select location, date, total_cases, population, (total_cases/population)*100 as Contagiousness
--from PortfolioProject..CovidDeaths
--where location like '%ukr%'
--order by 1,2



--select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as ContagiousnessPercent
--from PortfolioProject..CovidDeaths
--group by location, population
--order by ContagiousnessPercent desc


--select continent,  Max(cast(total_deaths as int)) as HighestDeathCount, Max((total_deaths/population))*100 as LethalityPercentage
--from PortfolioProject..CovidDeaths
--where continent is not null 
--group by continent
--order by HighestDeathCount desc


--select date, sum(new_cases) as New_Cases, sum(cast(new_deaths as int))  as New_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where continent is not null
--group by date
--order by 1,2

--with PopVsVac( Continent, Location, Date, Population, New_Vaccinations, RollingPplVacinated)
--as
--(
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by  dea.location 
--order by  dea.location, dea.date)  as RollingPplVacinated
--from PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVacines vac
--	on dea.location = vac.location
--	and dea.date=vac.date
--where dea.continent is not null
----order by 2,3
-- )

-- Select * , (RollingPplVacinated/Population)*100 as PercentOfVacinated
-- From PopVsVac
-- where Location like 'Ukraine'




 --temp table

 drop table if exists #PercentPopulationVaccinated
 create table #PercentPopulationVaccinated
 (
 Continent nvarchar(255), 
 Location nvarchar(255),
 Date Datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPplVacinated numeric
 )

 
 insert into #PercentPopulationVaccinated
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by  dea.location 
order by  dea.location, dea.date)  as RollingPplVacinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVacines vac
	on dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3

Select * , (RollingPplVacinated/Population)*100 as PercentOfVacinated
 From #PercentPopulationVaccinated
 where Location like 'Ukraine'


 --creating view for further visualization

 create view PercentPopulationVaccinated as
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by  dea.location 
order by  dea.location, dea.date)  as RollingPplVacinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVacines vac
	on dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
