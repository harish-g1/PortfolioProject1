-- GLOBAL NUMBERS

select date , sum(cast(new_cases as signed)) total_infections, sum(cast(new_deaths as signed)) total_deaths,
concat(round((sum(cast(new_deaths as signed))/sum(cast(new_cases as signed)))*100,4),'%') DeatchPercentage
from project_covid19.covid_deaths
where continent <> ''
group by date 
order by cast(date as date) ;

select  sum(cast(new_cases as signed)) total_infections, sum(cast(new_deaths as signed)) total_deaths,
concat(round((sum(cast(new_deaths as signed))/sum(cast(new_cases as signed)))*100,4),'%') DeatchPercentage
from project_covid19.covid_deaths
where continent <> ''
-- group by date 
order by cast(date as date) ;

select location, date, cast(new_cases as signed), new_deaths
from project_covid19.covid_deaths
where date = '11 March 2020' and continent <> '';

select location, date, new_cases, new_deaths
from project_covid19.covid_deaths
where date = '23 January 2021' and continent <> '' and location = 'Israel';

create table PercentPopulationVaccinated
( continent varchar(300),
location varchar(300),
date date,
population int(255),
new_vaccinations int(255),
runningVaccinationsByLocation int(255),
runningPercentageVaccination double(255,4));

INSERT INTO project_covid19.percentpopulationvaccinated
select d.continent, d.location, str_to_date(d.date, '%d-%m-%Y') date, cast(d.population as signed), 
cast(v.new_vaccinations as signed),
sum(cast(new_vaccinations as signed)) over (partition by d.location order by d.location, str_to_date(d.date, '%d-%m-%Y')) runningVaccinationsByLocation,
(sum(cast(new_vaccinations as signed)) over (partition by d.location order by d.location, str_to_date(d.date, '%d-%m-%Y'))/d.population)*100 runningPercentageVaccination
from project_covid19.covid_deaths d
join project_covid19.vaccinations v
on d.date = v.date
and d.location = v.location
-- where d.continent <> ''
order by d.location;

create view project_covid19.V_percentpopulationvaccinated as
select d.continent, d.location, str_to_date(d.date, '%d-%m-%Y') date, cast(d.population as signed) population, 
cast(v.new_vaccinations as signed) new_vaccinations,
sum(cast(new_vaccinations as signed)) over (partition by d.location order by d.location, str_to_date(d.date, '%d-%m-%Y')) runningVaccinationsByLocation
from project_covid19.covid_deaths d
join project_covid19.vaccinations v
on d.date = v.date
and d.location = v.location
where d.continent <> '';
