targetPackages <- c('stringr') 
newPackages <- targetPackages[!(targetPackages %in% installed.packages()[,"Package"])]
if(length(newPackages)) install.packages(newPackages, repos = "http://cran.ism.ac.jp")
for(package in targetPackages) library(package, character.only = T)