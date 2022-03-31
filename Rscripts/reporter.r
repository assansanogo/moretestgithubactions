#!/usr/bin/env Rscript

#imports
library(StreamlinR)  
library(emo)

if(!interactive()){
args = commandArgs(trailingOnly=TRUE)

# test if there is 3: 
# if not, return an error
  
print(args)
print("#################")

if (length(args)>2){
  # date of the day
  date_queried <- args[1]
  # pre-aggregation
  aggregation <- args[2]
  # country
  queried_country <- args[3]
  
  
  # date 24 hours before
  date_minus_1 <- as.Date(date_queried, "%m-%d-%Y") -1
  date_minus_1 <- format(x=date_minus_1, format="%m-%d-%Y")
  
  message(paste(emo::ji("ok"), 
                "your request will retrieve the data of (DAY-1): ", 
                date_minus_1))
} else{
  error_string <- "Please supply the correct arguments: \n
  * Date (format : mm-dd-yyyy) for which you want to see the results @ D-1\n
  * Aggregation whether you want already aggregated data : TRUE or raw : FALSE"
  stop(paste(emo::ji("boom"), 
              error_string),
              call.=FALSE)
}

# step 1: link creation
neo_link <- StreamlinR::create_full_link(date=date_minus_1, 
                                        aggregated=aggregation)
print(neo_link)

# step 2: download the data
StreamlinR::download_link(url=neo_link, 
                          aggregated=aggregation)

# step 3: clean the data
cleaned <- StreamlinR::JH_clean_data(date=date_minus_1,
                                    country=queried_country,
                                    aggregated=aggregation)

# step 4: summary
summarized_report <- JH_confirmed_death_summarize(dataframe=cleaned,
                                          date=date_minus_1,
                                          aggregated=aggregation)

# step 5: save locally (optional)
outname <- paste("out/data/",
                queried_country,
                 "/", 
                date_minus_1,
                "_pre_aggregation_",
                aggregation,
                "_report",
                ".csv",
                sep="")

readr::write_csv(summarized_report, 
                file=outname)

message(paste(emo::ji("ok"), 
              "the file is available (locally) under: ", 
              outname))

# step 6: output the data
# display the results
print(summarized_report, 
      n=nrow(summarized_report))
}
 
