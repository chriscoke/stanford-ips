
gdp = read.csv("~/../Documents/Keep/Data Blog/gdppcap_data_normed.csv")
pop = read.csv("~/../Documents/Keep/Data Blog/rurpop_data_normed.csv")
health = read.csv("~/../Documents/Keep/Data Blog/health_data_normed.csv")

#########################################################################################
# QUESTION 1: MATH AND STATISTICS

# 1A.
set = gdp$region_name == 'Argentina' & gdp$year >= 2005 & gdp$year <= 2016
mean( gdp$gdp_pcap[ set ] )

# 1B.
max( health$health_exp[ health$region_name=='Chile' ], na.rm=T )

# 1C.
sum( gdp$gdp_pcap[ gdp$year == 2016 & gdp$region_name %in% c('Belgium', 'Canada') ] )

# 1D.
v1 = median( pop$rural_pop[ pop$year==2010 ], na.rm=T )
v2 = median( pop$rural_pop[ pop$year==2016 ], na.rm=T )
c(v1, v2)

# 1E1.
mean( health$health_exp[ health$year==2014 ], na.rm=T )

# 1E2.
sum(health$health_exp[health$year==2014] * pop$rural_pop[pop$year==2014], na.rm=T ) / 
  sum( pop$rural_pop[pop$year==2014], na.rm=T ) 

# only works if the tables health and pop have all countries in the same order. In case they don't:
new = merge(health, pop, by=c("region_code", "year")) 
names(new) # why does this suck? columns repeated
new = merge(health, pop[,c("region_code","year","rural_pop")], by=c("region_code", "year"))
sum(new$health_exp[new$year==2014] * new$rural_pop[new$year==2014], na.rm=T ) / 
  sum( new$rural_pop[new$year==2014], na.rm=T ) 

# 1F.
sd( health$health_exp[ health$year == 2014 ] , na.rm=T)

# 1G. 
p = c(0.25, 0.5, 0.75)
quantile( health$health_exp[ health$year == 2014 ], p, na.rm=T )

# 1H.
new = merge( health[ ,c("region_name","year","health_exp") ], 
             pop[ ,c("region_name","year","rural_pop") ], 
             by = c("region_name", "year") 
)
new = new[new$region_name %in% c('Zimbabwe', 'Sweden', 'Philippines'), ]   # only certain countries 
new = new[new$year >= 2000 & new$year <= 2014, ]                           # only certain years
new = new[ is.na(new$health_exp)==FALSE & is.na(new$rural_pop)==FALSE, ]   # only full records
cor(new$rural_pop, new$health_exp)

#1I.

new = merge( health[ ,c("region_name","year","health_exp") ], 
             pop[ ,c("region_name","year","rural_pop") ], 
             by = c("region_name", "year") 
)
new = new[new$year >= 2000 & new$year <= 2014, ]                           # only certain years
new = new[ is.na(new$health_exp)==FALSE & is.na(new$rural_pop)==FALSE, ]   # only full records
cor(new$rural_pop, new$health_exp)


#########################################################################################
# QUESTION 2: ROW AND COLUMN OPERATIONS


library(dplyr)

# A. What is the average GDP per capita for each country and region over the period 1995-2005?

subset = gdp[ between(gdp$year, 1995, 2005), ]
tbl = subset %>% group_by(region_name) %>% summarize( avg_gdp = mean(gdp_pcap, na.rm=T) )
tbl

# B. What is the maximum % of Public Expenditure dedicated to health for each year below?

subset = health[ between(health$year, 2009, 2014), ]
tbl = subset %>% group_by(year) %>% summarize( max_health = max(health_exp, na.rm=T))
tbl


#########################################################################################
# QUESTION 3: CONDITIONAL SELECTIONS

# A. What is the rural population in 2016 for the following countries?

pop$rural_pop[ pop$year == 2016 & 
                 pop$region_name %in% c('Argentina', 'Vietnam', 'China', 'United States', 'South Africa', 'Bangladesh') ]
# or:
criteria = pop$year == 2016 & pop$region_name %in% c('Argentina', 'Vietnam', 'China', 'United States', 'South Africa', 'Bangladesh')
pop[criteria, c("region_name","rural_pop")]


# B. What is the GDP per capita and Health Expenditure % in Iraq for the following years?

new = merge(health, pop[,c("region_code","year","rural_pop")], by=c("region_code", "year"))
new = new[new$region_name == 'Iraq' & between(new$year,1999,2010), ]
new[,c("region_name","year","health_exp","rural_pop")]

# C. What are the GDPs per capita for the following countries and years? (fill out the table)

library(reshape2)

criteria = between(gdp$year, 2010, 2016) & gdp$region_name %in% c('Argentina','Vietnam','China','United States','South Africa','Bangladesh')
temp = gdp[criteria, ]
temp = dcast(temp, region_name ~ year, value.var="gdp_pcap")


#########################################################################################
# QUESTION 4: TRANSPOSING

# A. Fill out the following table using the GDP.PCAP data 

criteria = between(gdp$year, 1968, 1985) & gdp$region_name %in% c('Argentina','Bangladesh','United States','Ethiopia','Turkey','Germany')
temp = gdp[criteria, ]
temp = dcast(temp, year ~ region_name, value.var="gdp_pcap")
temp


#########################################################################################
# QUESTION 5: AGGREGATING

# A. What is the average Rural Population in 2016 for each region type?

pop[pop$year==2016,] %>% group_by(region_type) %>% summarize(avg_pop = mean(rural_pop, na.rm=T))

# B. What is the total Rural Population in 2016 for all countries starting with 'T'?

sum( pop$rural_pop[ substring(pop$region_name, 1, 1)=="T" & pop$year==2016 ] )

# C. What is the avg Rural Population in the period 2010-2016 for the following countries?

criteria = between(pop$year, 2010, 2016) & 
  pop$region_name %in% c('Madagascar', 'Fiji', 'Nigeria', 'Papua New Guinea', 'Korea, Rep.', 'Philippines', 'Nicaragua')
pop[criteria, ] %>% group_by(region_name) %>% summarize(avg_pop = mean(rural_pop))

# D. What is the average of the sums of 2016 Rural populations for each of the following groups?

group1 = c('Nicaragua','Madagascar')
group2 = c('Philippines','Fiji','Nigeria')
mean( 
  sum(pop$rural_pop[pop$year==2016 & pop$region_name %in% group1]),  
  sum(pop$rural_pop[pop$year==2016 & pop$region_name %in% group2]) 
)


#########################################################################################
# QUESTION 6: SUBSETTING

# A. What were the top 5 largest GDPs per capita in 2000, only among countries with a rural population of at least 20 million in 2016

candidate.regions = pop$region_code[ pop$year==2016 & pop$rural_pop >= 20000000 & pop$region_type == 'C' ]
tbl = gdp[ gdp$region_code %in% candidate.regions & gdp$year == 2000, ]
top = order(tbl$gdp_pcap, decreasing = T)[1:5]
tbl[top, ]


#########################################################################################
# QUESTION 7: CASE MATCHING

# A. Which countries had the largest and smallest % change in their GDP per capita in any two-year period? 
# For what % change and in what year? Excluding periods where reporting of data went in/out.

pchange = gdp[gdp$region_type=='C',] %>% arrange(region_name, year) %>% mutate(perc_change = (gdp_pcap / lag(gdp_pcap)) - 1)
pchange[pchange$year==1960,"perc_change"] = NA
pchange[which.min(pchange$perc_change),]
pchange[which.max(pchange$perc_change),]

# B1.	What is the year of largest GDP per capita for each country?

nogdp = gdp %>% group_by(region_name) %>% summarize(none = all(is.na(gdp_pcap)))
candidates = gdp$region_name %in% nogdp$region_name[nogdp$none==F] & gdp$region_type == 'C'
max.gdp = gdp[candidates, ] %>% group_by(region_name) %>% summarize(best.year = year[which.max(gdp_pcap)])
max.gdp

# B2.	In what year on average did the world's countries have peak GDP per capita?

mean(max.gdp$best.year)

# B3.	For which country has the most years passed since is its highest GDP per capita? And in what year was that peak?

max.gdp[which.min(max.gdp$best.year),]

# B4. For which country has the fewest years passed since is its highest GDP per capita? And in what year was that peak?

max.gdp[which.max(max.gdp$best.year),]


#########################################################################################
# QUESTION 8: WINDOWS CALCULATIONS

# A. What percent of 2016's total world rural population do the following countries represent? (topic: percent of total)
# China, India, United States, Egypt, Arab Rep., Brazil, Germany

question.countries = c("China", "India", "United States", "Egypt, Arab Rep.", "Brazil", "Germany")

# remember, you don't HAVE to always use dplyr functions...

selection = pop$year==2016 & pop$region_name %in% question.countries
countries = pop[selection,]
denominator = sum(pop$rural_pop[pop$year==2016], na.rm=T)
numerator = countries$rural_pop
countries$perc_of_total = numerator / denominator
countries

# But it's usually simpler and shorter

countries = pop %>% group_by(region_name) %>% summarize(perc_of_total = rural_pop[year==2016] / sum(pop$rural_pop[pop$year==2016]))
countries[countries$region_name %in% question.countries, ]

# B. What is the percent change in % of Public Expenditure on Healthcare for the following countries and years? (topic: difference from previous)
# United States, Brazil, Ukraine
# 2000 - 2016

q.countries = c("United States", "Brazil", "Ukraine")
q.years = seq(2000,2016, by=1)

tbl = 
  health[health$region_name %in% q.countries, ] %>% 
  arrange(region_name, year) %>% 
  mutate( perc_change = health_exp / lag(health_exp) - 1)

tbl2 = dcast(tbl[tbl$year %in% q.years, ], year ~ region_name, value.var = "perc_change" )
tbl2

# you can format the numbers for display, too

tbl2[,2:4] = round(tbl2[,2:4]*100, 2)
tbl2[,2:4] = t( apply( tbl2[,2:4], 1, function(x) paste0(x,"%") ) )
tbl2

# C. Repeat B, indexing each country's expenditure in the year 2000 = 1.00 (topic: difference from first)

base1 = health %>% group_by(region_name) %>% summarize(index = health_exp[year==2000])
base2 = merge(health, base1, by="region_name", all.x=T)

tbl = 
  base2[base2$region_name %in% q.countries, ] %>% 
  arrange(region_name, year) %>% 
  mutate(health_index = health_exp/index)

tbl2 = dcast(tbl[tbl$year %in% q.years, ], year ~ region_name, value.var = "health_index" )
tbl2

# D.	What is the 3-year moving average % Public Expenditure for healthcare, for the following countries and periods?

library(zoo)

q.countries = c("United States", "Brazil", "Ukraine")
q.years = seq(2000,2016, by=1)

tbl = 
  health[health$region_name %in% q.countries, ] %>% 
  arrange(region_name, year) %>% 
  mutate( MA3yr = rollmean(health_exp, k=3, na.pad=TRUE, na.rm=T) )  

# hmm all NAs, what's up?
# ?rollmean
# 'The default methods of rollmean and rollsum do not handle inputs that contain NAs. In such cases, use rollapply instead.'

tbl = 
  health[health$region_name %in% q.countries, ] %>% 
  arrange(region_name, year) %>% 
  mutate( MA3yr = rollapply(health_exp, width=3, FUN='mean', align='right', fill=TRUE, na.rm=T) )  
dcast(tbl[tbl$year %in% q.years, ], year ~ region_name, value.var = "MA3yr")

# Finding a package that already did the work is great. 
# But sometimes, you can't, or don't want the next person to have to learn the function
# So, create your own moving average function!

my.MA.fn = function(x, k){
  x[is.na(x)] = 0
  ma = ( cumsum(x) - lag(cumsum(x), k) ) / k
  return(ma)
}

tbl = 
  health[health$region_name %in% q.countries, ] %>% 
  arrange(region_name, year) %>% 
  mutate( MA3yr =  my.MA.fn(health_exp, k=3))
dcast(tbl[tbl$year %in% q.years, ], year ~ region_name, value.var = "MA3yr")

# ^^ as written, doesn't deal with partials (i.e. when a k-period mean does not have all values filled in, like years 2015-2016)

