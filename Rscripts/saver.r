#!/usr/bin/env Rscript

#imports
library(StreamlinR)  
library(emo)
library(dplyr)



concatener <- function(args){
    # current report    
    deaths_confirmed <- read.delim(args[1], sep=',', header=TRUE)
    
    # external dependency (list of countries)
    csv_states_filename<-system.file("extdata", "total_countries.csv", package = "StreamlinR")
    ref_dataframe_states<-read.delim(csv_states_filename, sep=',', header=TRUE)

    # running report
    total_deaths_confirmed <- read.delim(args[2], sep=';', header=TRUE)
    
    out <- tryCatch({ 
        #debug
        print(colnames(total_deaths_confirmed ))
        print(colnames(deaths_confirmed))
        print(colnames(ref_dataframe_states))

        # Left join (to make sure to always have the same number of columns) 
        std_deaths_confirmed <- merge(ref_dataframe_states,
                                        deaths_confirmed, 
                                        by = "Province_State",
                                        all.x = TRUE, 
                                        all.y = FALSE)

        # Columns names of the current report  
        new_cols <- colnames(std_deaths_confirmed)
        old_cols <- colnames(total_deaths_confirmed)

        # Find Duplicate Column Names
        # Remove Duplicate Column Names
        print(new_cols)
        print(old_cols)

        # Combination with previous runs
        total_deaths_confirmed <- total_deaths_confirmed %>% dplyr::select(old_cols[!old_cols %in% new_cols]) %>%
        
        total_deaths_confirmed <- cbind(std_deaths_confirmed,total_deaths_confirmed) 
       
        cols_ <- colnames(total_deaths_confirmed )
        message(paste(c("the columns are:", cols_)))
       

        return(total_deaths_confirmed)
        },
        error=function(cond) {
            
            #
            csv_countries_filename<-system.file("extdata", "total_countries.csv", package = "StreamlinR")
            dataframe_countries<-read.delim(csv_countries_filename, sep=',')

            message(paste("The file (consolidated) you are trying to merge with, may not exist"))
            message("Original error message:", cond)
            
            # Merge with the reference file with country names
            total_deaths_confirmed <- merge(dataframe_countries, 
                        deaths_confirmed, 
                        by = "Province_State", 
                        all.x = TRUE, 
                        all.y = FALSE)


            return(total_deaths_confirmed)
                })
        return(out)
    }



if(!interactive()){
     
    args = commandArgs(trailingOnly=TRUE)

    res = concatener(args)
    
    readr::write_csv(res, 
                file=args[3])

}
