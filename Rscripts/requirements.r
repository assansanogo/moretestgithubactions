#!/usr/bin/env Rscript

# packages that are stored on github (not on the CRAN)
if(!interactive()){
devtools::install_github("assansanogo/moretestgithubactions") #streamline repository(JH analysis)
devtools::install_github("hadley/emo") #emoji repository
}
