
-- View what's in the tables (before normalization)

select * 
from gdp_pcap_nonorm 
limit 10

select * 
from rural_pop_nonorm 
limit 10

select * 
from health_exp_nonorm 
limit 10

-- View what's in the tables

select * 
from gdp_pcap
limit 10

select * 
from rural_pop
limit 10

select * 
from health_exp
limit 10


-- Where clauses: Look at a few countries and years

select * 
from health_exp
where region_code = 'USA'

select * 
from health_exp
where region_code in ('USA','ITA')

select * 
from health_exp
where region_code in ('USA','ITA')
order by region_code asc, year desc

select region_name, year, health_exp
from health_exp
where year = 2010

select region_name, year, health_exp
from health_exp
where year between 2010 and 2011


-- join clauses: bring the tables together

select *
from rural_pop rp
join gdp_pcap gdp 
	on gdp.region_code = rp.region_code 
	and gdp.year = rp.year
where rp.region_code = 'USA' and rp.year=2000


select rp.*, gdp.gdp_pcap
from rural_pop rp
join gdp_pcap gdp 
	on gdp.region_code = rp.region_code 
	and gdp.year = rp.year
where rp.region_code = 'USA' and rp.year=2000


select rp.*, he.health_exp, gdp.gdp_pcap
from rural_pop rp
join gdp_pcap gdp on gdp.region_code = rp.region_code and gdp.year = rp.year
join health_exp he on he.region_code = rp.region_code and he.year = rp.year
where rp.region_code = 'USA' and rp.year='2000'


-- group by clauses: averages

select he.region_name, avg(he.health_exp)
from health_exp he
where he.region_code = 'USA'
group by he.region_name

-- calculate yourself
select he.region_name, he.year, he.health_exp
from health_exp he
where he.region_code = 'USA'


-- Understanding data types (integers, strings or characters, float)

-- NULLS
select he.region_code, he.year, he.health_exp
from health_exp he
where he.region_code = 'USA'
and year in (2014,2015) 

select he.region_code, sum(he.health_exp) as sum_health, avg(he.health_exp) as avg_health
from health_exp he
where he.region_code = 'USA'
and year in (2014,2015) 
group by he.region_code

-- Operations on Strings or Characters vs. Integers or Floats
select he.region_code, avg(he.region_name), avg(he.year)
from health_exp he
where he.region_code = 'USA'
and year in (2014,2015) 
group by he.region_code



