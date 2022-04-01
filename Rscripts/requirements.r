#!/usr/bin/env Rscript

# packages that are stored on the CRAN & then on github (not on the CRAN)
if(!interactive()){
install.packages('prob')
devtools::install_github("assansanogo/moretestgithubactions") #streamline repository(JH analysis)
devtools::install_github("hadley/emo") #emoji repository
}
