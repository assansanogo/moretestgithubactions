#!/usr/bin/env Rscript

#imports
library(StreamlinR)  
library(emo)
library(dplyr)


concatener <- function(args){
    
    #' Create the consolidated report (daily runs appended to file)
    #'
    #' 
    #' 
    #' @param args (from which is extracted the path of previous report,current report & output path)
    #' 
    #' @importFrom magrittr "%>%"
    #' @return dest_file_name
    #' @export
    #'

    
 
    
    # current report (for the queried date)

    deaths_confirmed <- read.delim(args[1], sep=',', header=TRUE)

    # reference file shipped with R package
    # external dependency (list of countries)
    csv_states_filename<-system.file("extdata", 
                                     "total_states_US.csv", 
                                     package = "StreamlinR")
    
    ref_dataframe_states<-read.delim(csv_states_filename, 
                                     sep=',', 
                                     header=TRUE)

    # running report (includes previous days/runs)
    total_deaths_confirmed <- read.delim(args[2], 
                                         sep=',', 
                                         header=TRUE)

    out <- tryCatch({ 
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
        print((old_cols %in% new_cols))

        # Combination with previous runs
        # The columns must be checked for appending the day results only once.
        difference_in_cols <- old_cols[setdiff(old_cols, new_cols)]

        if (!rlang::is_empty(difference_in_cols)){

        total_deaths_confirmed <- total_deaths_confirmed %>% dplyr::select(difference_in_cols)
        } else {
            message("the pipeline was previously computed for this day - will overwrite the previous data")
            total_deaths_confirmed <- total_deaths_confirmed %>% dplyr::select(-one_of(new_cols))
            }

        total_deaths_confirmed <- cbind(std_deaths_confirmed, total_deaths_confirmed) 

        cols_ <- colnames(total_deaths_confirmed )
        message(paste(c("the columns are:", cols_)))

        return(total_deaths_confirmed)
        },
        error=function(cond) {

            # reference file shipped with R package
            # referrence states dataframe
            csv_states_filename<-system.file("extdata", 
                                                "total_states_US.csv", 
                                                package = "StreamlinR")
            ref_dataframe_states<-read.delim(csv_states_filename, 
                                            sep=',')

            message(paste("ERROR", 
                          "1. The file (consolidated) you are trying to merge with, may not exist",
                          "2. The file (consolidated) might have the wrong type of separator",
                          sep="\n"))

            message("Original error message:", cond)

            # Merge with the reference file with states names
            total_deaths_confirmed <- merge(ref_dataframe_states, 
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
