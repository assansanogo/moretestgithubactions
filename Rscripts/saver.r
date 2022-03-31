#!/usr/bin/env Rscript

#imports
library(StreamlinR)  
library(emo)

if(!interactive()){
    args = commandArgs(trailingOnly=TRUE)
    
    concatener <- function(){
        
    deaths_confirmed <- read.delim(args[1], sep=',')

    csv_countries_filename<-system.file("extdata", "total_countries.csv", package = "StreamlinR")
    dataframe_countries<-read.delim(csv_countries_filename, sep=',')


    out <- tryCatch({ 
    total_deaths_confirmed <- read.delim(args[2], sep=',')


    #left join
    total_deaths_confirmed <- merge(total_deaths_confirmed, 
                                    deaths_confirmed, 
                                    by.x = "State", 
                                    by.y = "Sate", 
                                    all.x = TRUE, 
                                    all.y = FALSE)
    return(total_deaths_confirmed)
    },
    error=function(cond) {
                message(paste("The file (consolidated) you are trying to merge with, may not exist"))
                message("Original error message:",cond)
                # Choose a return value in case of error
                return(deaths_confirmed)
            })
    return(out)
    }
    print(args[1])
    res = concatener()
    readr::write_csv(res, 
                file=args[3])

}
