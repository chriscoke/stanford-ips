
################################################################################

# Normalize data tables for import into SQL database
# ccoke
# 2017.10.26

################################################################################

library(reshape2)

d1 = read.csv("~/../Documents/Keep/Data Blog/rurpop_data.csv")
d2 = read.csv("~/../Documents/Keep/Data Blog/gdppcap_data.csv")
d3 = read.csv("~/../Documents/Keep/Data Blog/health_data.csv")

dmelt1 = melt(d1, id.vars=1:3, measure.vars=6:ncol(d1))
names(dmelt1) = c("region_name","region_type","region_code","year","rural_pop")
dmelt1$year = as.numeric(gsub("X","",dmelt1$year))
dmelt1$region_name = gsub("'","",dmelt1$region_name)

dmelt2 = melt(d2, id.vars=c(1,3:4), measure.vars=7:ncol(d2))
names(dmelt2) = c("region_name","region_type","region_code","year","gdp_pcap")
dmelt2$year = as.numeric(gsub("X","",dmelt2$year))
dmelt2$region_name = gsub("'","",dmelt2$region_name)

dmelt3 = melt(d3, id.vars=1:3, measure.vars=6:ncol(d3))
names(dmelt3) = c("region_name","region_type","region_code","year","health_exp")
dmelt3$year = as.numeric(gsub("X","",dmelt3$year))
dmelt3$region_name = gsub("'","",dmelt3$region_name)

write.csv(dmelt1, "~/../Documents/Keep/Data Blog/rurpop_data_normed.csv", na="", row.names=F)
write.csv(dmelt2, "~/../Documents/Keep/Data Blog/gdppcap_data_normed.csv", na="", row.names=F)
write.csv(dmelt3, "~/../Documents/Keep/Data Blog/health_data_normed.csv", na="", row.names=F)




