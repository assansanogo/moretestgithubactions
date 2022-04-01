#!/usr/bin/env Rscript

#imports
library(StreamlinR)  
library(emo)



concatener <- function(args){
    # current report    
    deaths_confirmed <- read.delim(args[1], sep=',')
    
    # external dependency (list of countries)
    csv_countries_filename<-system.file("extdata", "total_countries.csv", package = "StreamlinR")
    dataframe_countries<-read.delim(csv_countries_filename, sep=',')

    # running report
    total_deaths_confirmed <- read.delim(args[2], sep=',')
    
    out <- tryCatch({ 
        

        print(colnames(total_deaths_confirmed ))
        print(colnames(deaths_confirmed))



        # Left join (to make sure to always have the same number of columns) 
        std_deaths_confirmed <- merge(csv_countries_filename,
                                        deaths_confirmed, 
                                        by = "Province_State",
                                        all.x = TRUE, 
                                        all.y = FALSE)

        # Columns names of the current report  
        new_cols <- colnames(std_deaths_confirmed)

        # Find Duplicate Column Names
        # Remove Duplicate Column Names

        duplicated_names <- duplicated(colnames(total_deaths_confirmed))
        total_deaths_confirmed[!duplicated_names]

        # Combination with previous runs
        if (!total_deaths_confirmed.columns.isin(new_cols).any()){
            total_deaths_confirmed <- cbind(total_deaths_confirmed, std_deaths_confirmed, check) 
            cols_ <- colnames(total_deaths_confirmed )
            message(paste("the columns are:", cols_) )
            } else {
            message("the columns already exist")
            }

        return(total_deaths_confirmed)
        },
        error=function(cond) {
            
            #
            csv_countries_filename<-system.file("extdata", "total_countries.csv", package = "StreamlinR")
            dataframe_countries<-read.delim(csv_countries_filename, sep=',')

            message(paste("The file (consolidated) you are trying to merge with, may not exist"))
            message("Original error message:",cond)
            
            # Merge with the reference file with country names
           total_deaths_confirmed <- merge(dataframe_countries, 
                        deaths_confirmed, 
                        by = "Province_State", 
                        all.x = TRUE, 
                        all.y = FALSE)


            return(deaths_confirmed)
                })
        return(out)
    }



if(!interactive()){
     
    args = commandArgs(trailingOnly=TRUE)

    res = concatener(args)
    
    readr::write_csv(res, 
                file=args[3])

}
