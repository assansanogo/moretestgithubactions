#!/usr/bin/env Rscript
library(myfirstpackage)
if(!interactive()){
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)!=2) {
  stop("Please supply the correct arguments: \n
  * Date (format : mm-dd-yyyy) for which you want to see the results @ D-1\n
  * Aggregation whether you want already aggregated data : TRUE or raw : FALSE", call.=FALSE)

} else if (length(args)==2){
  # default output file
  date_queried <- args[1]
  aggregation <- args[2]
}
neo_link <- myfirstpackage::create_link(date_queried, aggregated=aggregation)
myfirstpackage::download_link(neo_link)
cleaned <- myfirstpackage::clean_us_data2(date_queried)
}