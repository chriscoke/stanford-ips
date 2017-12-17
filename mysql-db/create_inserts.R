################################################################################

# Create SQL INSERT statements
# ccoke
# 2017.10.26

################################################################################

d1 = read.csv("~/Documents/Data Curriculum/rurpop_data.csv",stringsAsFactors=F)
d2 = read.csv("~/Documents/Data Curriculum/gdppcap_data.csv",stringsAsFactors=F)
d3 = read.csv("~/Documents/Data Curriculum/health_data.csv",stringsAsFactors=F)

dmelt1 = read.csv("~/Documents/Data Curriculum/rurpop_data_normed.csv",stringsAsFactors=F)
dmelt2 = read.csv("~/Documents/Data Curriculum/gdppcap_data_normed.csv",stringsAsFactors=F)
dmelt3 = read.csv("~/Documents/Data Curriculum/health_data_normed.csv",stringsAsFactors=F)

dmelt1$rural_pop[is.na(dmelt1$rural_pop)] = 'NULL'
dmelt2$gdp_pcap[is.na(dmelt2$gdp_pcap)] = 'NULL'
dmelt3$health_exp[is.na(dmelt3$health_exp)] = 'NULL'

d1[is.na(d1)] = 'NULL'
d2[is.na(d2)] = 'NULL'
d3[is.na(d3)] = 'NULL'

d1$Country.Name[d1$Country.Name == 'Korea, Dem. People\x92s Rep.'] = "Korea, Dem. Peoples Rep."
d2$Country.Name[d2$Country.Name == 'Korea, Dem. People\x92s Rep.'] = "Korea, Dem. Peoples Rep."
d3$Country.Name[d3$Country.Name == 'Korea, Dem. People\x92s Rep.'] = "Korea, Dem. Peoples Rep."
d1$Country.Name[d1$Country.Name == "Cote d'Ivoire"] = "Cote dIvoire"
d2$Country.Name[d2$Country.Name == "Cote d'Ivoire"] = "Cote dIvoire"
d3$Country.Name[d3$Country.Name == "Cote d'Ivoire"] = "Cote dIvoire"

dmelt1$region_name[dmelt1$region_name == 'Korea, Dem. People\x92s Rep.'] = "Korea, Dem. Peoples Rep."
dmelt2$region_name[dmelt2$region_name == 'Korea, Dem. People\x92s Rep.'] = "Korea, Dem. Peoples Rep."
dmelt3$region_name[dmelt3$region_name == 'Korea, Dem. People\x92s Rep.'] = "Korea, Dem. Peoples Rep."

d2 = d2[,-which(names(d2)=='Row')]

#### 1

txt.all = NULL
txt.start = "INSERT INTO rural_pop VALUES ("
txt.end = ");"
table = dmelt1

for(i in 1:nrow(table)){
  values1 = as.matrix(table[i,1:3])
  values2 = as.matrix(table[i,4:5])
  txt.mid1 = paste0("'",paste0(values1, collapse="','"),"'")
  txt.mid2 = paste0(values2, collapse=",")
  txt.mid = paste(txt.mid1, txt.mid2, sep=",")
  #txt.mid = substring(txt.mid, 1, nchar(txt.mid)-1)
  txt.rw = paste0(txt.start, txt.mid, txt.end)
  txt.all = paste(txt.all, txt.rw, sep="\n")
}
insert1 = txt.all

#### 2

txt.all = NULL
txt.start = "INSERT INTO gdp_pcap VALUES ("
txt.end = ");"
table = dmelt2

for(i in 1:nrow(table)){
  values1 = as.matrix(table[i,1:3])
  values2 = as.matrix(table[i,4:5])
  txt.mid1 = paste0("'",paste0(values1, collapse="','"),"'")
  txt.mid2 = paste0(values2, collapse=",")
  txt.mid = paste(txt.mid1, txt.mid2, sep=",")
  #txt.mid = substring(txt.mid, 1, nchar(txt.mid)-1)
  txt.rw = paste0(txt.start, txt.mid, txt.end)
  txt.all = paste(txt.all, txt.rw, sep="\n")
}
insert2 = txt.all

#### 3

txt.all = NULL
txt.start = "INSERT INTO health_exp VALUES ("
txt.end = ");"
table = dmelt3

for(i in 1:nrow(table)){
  values1 = as.matrix(table[i,1:3])
  values2 = as.matrix(table[i,4:5])
  txt.mid1 = paste0("'",paste0(values1, collapse="','"),"'")
  txt.mid2 = paste0(values2, collapse=",")
  txt.mid = paste(txt.mid1, txt.mid2, sep=",")
  #txt.mid = substring(txt.mid, 1, nchar(txt.mid)-1)
  txt.rw = paste0(txt.start, txt.mid, txt.end)
  txt.all = paste(txt.all, txt.rw, sep="\n")
}
insert3 = txt.all

writeLines(insert1, con="~/Documents/Data Curriculum/insert_rural_pop.sql", sep="\n")
writeLines(insert2, con="~/Documents/Data Curriculum/insert_gdp_pcap.sql", sep="\n")
writeLines(insert3, con="~/Documents/Data Curriculum/insert_health_exp.sql", sep="\n")

#### 4

txt.all = NULL
txt.start = "INSERT INTO rural_pop_nonorm VALUES ("
txt.end = ");"
table = d1

for(i in 1:nrow(table)){
  values1 = as.matrix(table[i,1:5])
  values2 = as.matrix(table[i,6:ncol(table)])
  txt.mid1 = paste0("'",paste0(values1, collapse="','"),"'")
  txt.mid2 = paste0(values2, collapse=",")
  txt.mid = paste(txt.mid1, txt.mid2, sep=",")
  txt.rw = paste0(txt.start, txt.mid, txt.end)
  txt.all = paste(txt.all, txt.rw, sep="\n")
}
insert4 = txt.all

#### 5

txt.all = NULL
txt.start = "INSERT INTO gdp_pcap_nonorm VALUES ("
txt.end = ");"
table = d2

for(i in 1:nrow(table)){
  values1 = as.matrix(table[i,1:5])
  values2 = as.matrix(table[i,6:ncol(table)])
  txt.mid1 = paste0("'",paste0(values1, collapse="','"),"'")
  txt.mid2 = paste0(values2, collapse=",")
  txt.mid = paste(txt.mid1, txt.mid2, sep=",")
  txt.rw = paste0(txt.start, txt.mid, txt.end)
  txt.all = paste(txt.all, txt.rw, sep="\n")
}
insert5 = txt.all

#### 6

txt.all = NULL
txt.start = "INSERT INTO health_exp_nonorm VALUES ("
txt.end = ");"
table = d3

for(i in 1:nrow(table)){
  values1 = as.matrix(table[i,1:5])
  values2 = as.matrix(table[i,6:ncol(table)])
  txt.mid1 = paste0("'",paste0(values1, collapse="','"),"'")
  txt.mid2 = paste0(values2, collapse=",")
  txt.mid = paste(txt.mid1, txt.mid2, sep=",")
  txt.rw = paste0(txt.start, txt.mid, txt.end)
  txt.all = paste(txt.all, txt.rw, sep="\n")
}
insert6 = txt.all

writeLines(insert4, con="~/Documents/Data Curriculum/insert_rural_pop_orig.sql", sep="\n")
writeLines(insert5, con="~/Documents/Data Curriculum/insert_gdp_pcap_orig.sql", sep="\n")
writeLines(insert6, con="~/Documents/Data Curriculum/insert_health_exp_orig.sql", sep="\n")




