
-- --------------------------------
-- 1. MATH AND STATISTICS 

-- MATH

-- A. What is the average annual GDP per Capita of Argentina from 2005 through 2016?

select avg(gdp_pcap)
from gdp_pcap
where region_name = 'Argentina'
and year between 2005 and 2016

-- B. What is the maximum % of Public Expenditure on health for any recorded year in Chile?

select max(health_exp)
from health_exp
where region_name = 'Chile'

-- C. What would you expect a transatlantic, working, married couple from Canada and Belgium to be earning annually in 2016?

select sum(gdp_pcap)
from gdp_pcap
where region_name in ('Belgium','Canada')
and year = 2016

-- D	What is the median rural population among all countries and regions in the world in 2010 vs. 2016?


-- E1	What is the average % of Public Expenditure on health in 2014?

select avg(health_exp)
from health_exp
where year = 2014

-- E2	What is the average % of Public Expenditure on health in 2014, weighted by Rural Population in the same year?

select sum(rp.rural_pop * he.health_exp)/sum(rp.rural_pop)
from rural_pop rp
join health_exp he 
	on he.region_code = rp.region_code 
	and he.year = rp.year
where rp.year = 2014

-- STATS

-- F. What was the standard deviation of % health expenditure among all countries and regions in 2014?

select std(health_exp)
from health_exp
where year = 2014

-- G. What is the 25th, 50th, and 75th percentiles of % health expenditure among all countries and regions in 2014?

-- oh c'mon, seriously?

-- H. What is the correlation between Rural Population and % spent on healthcare in the following countries for 2000-2014?

-- again? ok fine, I'll try it

select region_name, p1 / (sqrt(p2)*sqrt(p3)) as correl_coef
from (
select 
	region_name, 
	sum((x-xbar)*(y-ybar)) as p1,
	sum(power(x-xbar,2)) as p2,
	sum(power(y-ybar,2)) as p3
from (
select 
	rp.region_name, 
	rp.rural_pop as x, 
	x.avg_pop as xbar, 
	he.health_exp as y, 
	x.avg_health as ybar
from rural_pop rp
join health_exp he on he.region_code = rp.region_code and he.year = rp.year
join (
	select 
		rp.region_name,
		avg(rp.rural_pop) as avg_pop, 
		avg(he.health_exp) as avg_health 
	from rural_pop rp
	join health_exp he 
		on he.region_code = rp.region_code 
		and he.year = rp.year
	where rp.region_name in ('Zimbabwe', 'Sweden', 'Philippines')
	and rp.year between 2000 and 2014
	group by rp.region_name
) x on x.region_name = rp.region_name
where rp.region_name in ('Zimbabwe', 'Sweden', 'Philippines')
and rp.year between 2000 and 2014
order by rp.region_name
) y
group by region_name
) z

-- I. Correlation between Rural Population and % spent on healthcare over all countries for 2000-2014?

select p1 / (sqrt(p2)*sqrt(p3)) as correl_coef
from (
select 
	sum((x-xbar)*(y-ybar)) as p1,
	sum(power(x-xbar,2)) as p2,
	sum(power(y-ybar,2)) as p3
from (
select 
	rp.rural_pop as x, 
	x.avg_pop as xbar, 
	he.health_exp as y, 
	x.avg_health as ybar
from rural_pop rp
join health_exp he on he.region_code = rp.region_code and he.year = rp.year
cross join (
	select 
		avg(rp.rural_pop) as avg_pop, 
		avg(he.health_exp) as avg_health 
	from rural_pop rp
	join health_exp he 
		on he.region_code = rp.region_code 
		and he.year = rp.year
	where rp.year between 2000 and 2014
) x 
where rp.year between 2000 and 2014
) y
) z

-- --------------------------------
-- 2. ROW AND COLUMN OPERATIONS
	
-- A. What is the average GDP per capita for each country and region over the period 1995-2005?

select region_name, avg(gdp_pcap)
from gdp_pcap
where year between 1995 and 2005
group by region_name

-- B. What is the maximum % of Public Expenditure dedicated to health for each year below?

select year, max(health_exp)
from health_exp
where year between 2009 and 2014
group by year

-- --------------------------------
-- 3. CONDITIONAL SELECTIONS

-- A. What is the rural population in 2016 for the following countries?

select region_name, rural_pop
from rural_pop
where region_name in (
'Argentina',
'Vietnam',
'China',
'United States',
'South Africa',
'Bangladesh')
and year = 2016

-- B. What is the GDP per capita and Health Expenditure % in Iraq for the following years?

select he.year, he.health_exp, gdp.gdp_pcap
from health_exp he
join gdp_pcap gdp 
	on gdp.region_code = he.region_code 
	and gdp.year = he.year
where he.region_name = 'Iraq' and he.year between 1999 and 2010

-- C. What are the GDPs per capita for the following countries and years? (fill out the table)

select 
	region_name, 
	max(case when year = '2010' then gdp_pcap end) as gdp_pcap_2010,
	max(case when year = '2011' then gdp_pcap end) as gdp_pcap_2011,
    max(case when year = '2012' then gdp_pcap end) as gdp_pcap_2012,
	max(case when year = '2013' then gdp_pcap end) as gdp_pcap_2013,
	max(case when year = '2014' then gdp_pcap end) as gdp_pcap_2014,
	max(case when year = '2015' then gdp_pcap end) as gdp_pcap_2015,
	max(case when year = '2016' then gdp_pcap end) as gdp_pcap_2016
from gdp_pcap
where region_name in (
'Argentina',
'Vietnam',
'China',
'United States',
'South Africa',
'Bangladesh')
and year between 2010 and 2016
group by region_name

-- --------------------------------
-- 4. TRANSPOSING

-- A. Fill out the following table using the GDP.PCAP data 

select 
	year,
	max(case when region_name = 'Argentina' then gdp_pcap end) as argentina_gdp,
	max(case when region_name = 'Bangladesh' then gdp_pcap end) as banglaehsh_gdp,
	max(case when region_name = 'United States' then gdp_pcap end) as usa_gdp,
	max(case when region_name = 'Ethiopia' then gdp_pcap end) as ethiopia_gdp,
	max(case when region_name = 'Turkey' then gdp_pcap end) as turkey_gdp,
	max(case when region_name = 'Germany' then gdp_pcap end) as germany_gdp 
from gdp_pcap
where region_name in (
	'Argentina','Bangladesh','United States','Ethiopia','Turkey','Germany')
and year between 1968 and 1985
group by year


-- --------------------------------
-- 5. AGGREGATING

-- A. What is the average Rural Population in 2016 for each region type?

select region_type, avg(rural_pop)
from rural_pop
where year = 2016
group by region_type

-- B. What is the total Rural Population in 2016 for all countries starting with 'T'?

select sum(rural_pop)
from rural_pop
where substring(region_name,1,1) = 'T'
and year = 2016
and region_type = 'C'

-- C. What is the avg Rural Population in the period 2010-2016 for the following countries?

select region_name, avg(rural_pop)
from rural_pop
where year between 2010 and 2016
and region_name in (
	'Madagascar',
	'Fiji',
	'Nigeria',
	'Papua New Guinea',
	'Korea, Rep.',
	'Philippines',
	'Nicaragua')
group by region_name

-- D. What is the average of the sums of 2016 Rural populations for each of the following groups?

select (grp1 + grp2)/2 as average
from (
	select 
	sum(case when region_name in ('Nicaragua','Madagascar') then rural_pop end) as grp1,
	sum(case when region_name in ('Philippines','Fiji','Nigeria') then rural_pop end) as grp2
	from rural_pop
	where year = 2016
) x


-- --------------------------------
-- 6. SUBSETTING

-- A. What were the top 5 largest GDPs per capita in 2000, only among countries with a rural population of at least 20 million in 2016

-- This is wrong (explain why)
select g.region_name, g.gdp_pcap
from gdp_pcap g
join rural_pop r 
	on r.region_code = g.region_code
	and r.year = g.year
where g.region_type = 'C'
and r.rural_pop >= 20000000 and r.year = 2016
order by g.gdp_pcap desc
limit 5

-- This is right
select 
	g.region_name,
	g.gdp_pcap
from gdp_pcap g
join (
	select region_code
	from rural_pop 
	where rural_pop >= 20000000
	and year = 2016
) r on r.region_code = g.region_code
where g.region_type = 'C'
and g.year = 2000
order by g.gdp_pcap desc
limit 5

-- --------------------------------
-- 7. CASE MATCHING

-- A. Which countries had the largest and smallest % change in their GDP per capita in any two-year period? For what % change and in what year? Excluding periods where reporting of data went in/out.

-- easiest to do it in 2 parts?

select 
	g1.region_name, 
	g1.gdp_pcap as metric1, 
	g1.year as year1, 
	g2.gdp_pcap as metric2, 
	g2.year as year2,
	g2.gdp_pcap / g1.gdp_pcap - 1 as perc_change
from gdp_pcap g1
join gdp_pcap g2 
	on g2.region_code = g1.region_code
	and g2.year = g1.year + 1
order by g2.gdp_pcap / g1.gdp_pcap - 1 desc
limit 1

select 
	g1.region_name, 
	g1.gdp_pcap as metric1, 
	g1.year as year1, 
	g2.gdp_pcap as metric2, 
	g2.year as year2,
	g2.gdp_pcap / g1.gdp_pcap - 1 as perc_change
from gdp_pcap g1
join gdp_pcap g2 
	on g2.region_code = g1.region_code
	and g2.year = g1.year + 1
order by g2.gdp_pcap / g1.gdp_pcap - 1 asc -- only difference
limit 1

-- B1. What is the year of largest GDP per capita for each country?

select region_name, year
from gdp_pcap g
where g.gdp_pcap = (select max(gdp_pcap) from gdp_pcap where region_name = g.region_name group by region_name)
order by region_name

-- B2. In what year on average did the world's countries have peak GDP per capita?

select avg(year)
from gdp_pcap g
where g.gdp_pcap = (select max(gdp_pcap) from gdp_pcap where region_name = g.region_name group by region_name)
and region_type = 'C'

-- B3. For which country has the most years passed since its highest GDP per capita? And in what year was that peak?

select region_name, year
from gdp_pcap g
where g.gdp_pcap = (select max(gdp_pcap) from gdp_pcap where region_name = g.region_name group by region_name)
and region_type = 'C'
order by year asc
limit 1

-- B4. For which country has the fewest years passed since its highest GDP per capita? And in what year was that peak?

select region_name, year, now() as today, now() - year as elapsed
from gdp_pcap g
where region_type = 'C'
and gdp_pcap = (select max(gdp_pcap) from gdp_pcap where region_name = g.region_name group by region_name)
and now() - year =  (
	select min(now() - year) as shortest_elapsed
	from gdp_pcap g
	where g.gdp_pcap = (select max(gdp_pcap) from gdp_pcap where region_name = g.region_name group by region_name)
	and region_type = 'C'
)

-- --------------------------------
-- 8. WINDOW CALCULATIONS

-- A. What percent of 2016's total world rural population do the following countries represent? (topic: percent of total)
-- China, India, United States, Egypt, Arab Rep., Brazil, Germany

-- using case logic
select 
	china_pop / tot, 
	brazil_pop / tot,
	india_pop / tot,
	usa_pop / tot,
	egypt_pop / tot,
	german_pop / tot
from (
select 
	max(case when region_name = 'China' then rural_pop else null end) china_pop,
	max(case when region_name = 'Brazil' then rural_pop else null end) brazil_pop,
	max(case when region_name = 'India' then rural_pop else null end) india_pop,
	max(case when region_name = 'United States' then rural_pop else null end) usa_pop,
	max(case when region_name = 'Egypt, Arab Rep.' then rural_pop else null end) egypt_pop,
	max(case when region_name = 'Germany' then rural_pop else null end) german_pop,
	sum(rural_pop) as tot
from rural_pop
where year = 2016 and region_type = 'C'
) x

-- Using cross join
select region_name, rural_pop, x.total_2016_population, rural_pop / total_2016_population
from rural_pop r
cross join (
	select sum(rural_pop) as total_2016_population
	from rural_pop
	where year = 2016
	and region_type = 'C'
) x
where year = 2016
and region_name in ("China", "India", "United States", "Egypt, Arab Rep.", "Brazil", "Germany")


-- B. What is the percent change in % of Public Expenditure on Healthcare for the following countries and years? (topic: difference from previous)
-- United States, Brazil, Ukraine
-- 2000 - 2016

select 
	h1.region_name, 
	h2.year, 
	h1.health_exp as prior_exp, 
	h2.health_exp as current_exp,
	h2.health_exp / h1.health_exp - 1 as perc_change
from health_exp h1
join health_exp h2 
	on h2.region_code = h1.region_code
	and h2.year = h1.year + 1
where h1.region_name in ("United States", "Brazil", "Ukraine")
and h2.year between 2000 and 2016

-- C. Repeat B, indexing each country's expenditure in the year 2000 = 1.00 (topic: difference from first)

select 
	h1.region_name, 
	h2.year, 
	h1.health_exp as prior_exp, 
	h2.health_exp as current_exp, 
	h3.health_exp as yr2000_exp,
	h2.health_exp / h3.health_exp as health_index
from health_exp h1
join health_exp h2 
	on h2.region_code = h1.region_code
	and h2.year = h1.year + 1
join (
	select region_name, health_exp
	from health_exp
	where year = 2000
) h3 on h3.region_name = h1.region_name
where h1.region_name in ("United States", "Brazil", "Ukraine")
and h2.year between 2000 and 2016

-- D. What is the 3-year moving average % Public Expenditure for healthcare, for the following countries and periods? (topic: MA)

-- ok I get it, some things still suck in SQL
-- think about how much this would suck if they said a 20-year moving average
select 
	h1.region_name, 
	h1.year, h2.year, h3.year,
	h1.health_exp, 
	h2.health_exp, 
	h3.health_exp,
	(h1.health_exp + h2.health_exp + h3.health_exp) / 3 as health_3yr_MA
from health_exp h1
join health_exp h2 
	on h2.region_code = h1.region_code
	and h2.year = h1.year + 1
join health_exp h3 
	on h3.region_code = h1.region_code
	and h3.year = h1.year + 2
where h1.region_name in ("United States", "Brazil", "Ukraine")
and h1.year between 1998 and 2016

