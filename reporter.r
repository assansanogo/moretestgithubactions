#!/usr/bin/env Rscript
library(myfirstpackage)
devtools::install_github("hadley/emo")

if(!interactive()){
args = commandArgs(trailingOnly=TRUE)


# test if there is at least one argument: if not, return an error
if (length(args)!=2) {
  error_string <- "Please supply the correct arguments: \n
  * Date (format : mm-dd-yyyy) for which you want to see the results @ D-1\n
  * Aggregation whether you want already aggregated data : TRUE or raw : FALSE"
  stop(paste(emo::ji("boom"), error_string), call.=FALSE)

} else if (length(args)==2){
  date_queried <- args[1]
  aggregation <- args[2]
  
  date_minus_1 <- as.Date(date_queried, "%d-%m-%Y") -1
  date_minus_1 <- format(x=date_minus_1, format="%d-%m-%Y")
  message(paste(emo::ji("ok"), "your request will treat the data of (DAY-1): ", date_minus_1))
}

# step 1: link creation
neo_link <- myfirstpackage::create_full_link(date_minus_1, aggregated=aggregation)
print(neo_link)

# step 2: download the data
myfirstpackage::download_link(neo_link)

# step 3: clean the data
cleaned <- myfirstpackage::clean_us_data2(date_minus_1, aggregated=aggregation)
out <- cleaned[, c("Province_State", "Country_Region", "Confirmed")]

# step 4: output the data + save locally (optional)
# save
outname <- paste("out/", date_minus_1,"_pre_aggregation_", aggregation,".csv", sep="")
readr::write_csv(out, file=outname)

# display
print(out, n = nrow(out))
message(paste(emo::ji("ok"), "the file is available (locally) under: ", outname))
}

