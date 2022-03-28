# functions with prefix: "util" are helper functions
# reused in main functions identified by prefix: "JH"


create_out_name_based_on_url<- function(url, aggregated=FALSE){

  #' Create filename based on url
  #'
  #' create the out_folder format 
  #' 
  #' @param url dataset url (from which is extracted the output filename)
  #' @param aggregated boolean flag to indicate whether data was already aggregated 
  #'
  #' @return dest_file_name
  #' @export
  #'
  #' @examples
  #' # create output filename: create_out_name_based_on_url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/03-04-2021.csv")
  #'  
    
    
  out_name <- sub('\\.csv$', '', basename(url))
  suffix = paste("_pre_aggregation_", aggregated, sep="")
  dest_file_name = paste("./temp/", out_name, suffix,".csv", sep="")
  return(dest_file_name)
}

create_out_name_based_on_date<- function(date='01-01-2021', aggregated=FALSE){

  #' Create filename based on date
  #'
  #' create the out_folder format 
  #' 
  #' @param date queried date for analysis
  #' @param aggregated boolean flag to indicate whether data was already aggregated 
  #'
  #' @return dest_file_name
  #' @export
  #'
  #' @examples
  #' # create output filename: create_out_name_based_on_date("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/03-04-2021.csv")
  #'  


  suffix = paste("_pre_aggregation_", aggregated, sep="")
  dest_file_name = paste("./temp/", date, suffix,".csv", sep="")
  return(dest_file_name)
}

create_full_link <- function(date='01-01-2021', aggregated=FALSE) {
  
  #' Create Link function
  #'
  #' Concatenate date and repository link
  #' 
  #' @param date. queried date for analysis
  #' @param aggregated. boolean flag to indicate whether data was already aggregated
  #'
  #' @return An url string - complete link
  #' @export
  #'
  #' @examples
  #' # Create the url based on date : 01-01-2021
  #' create_link('03-04-2021')

  
  if (aggregated){
      root <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/"
  }
  else {
      root <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"
  }

  out <- tryCatch({
    temp_C <- paste(root, date, sep = "" )
    temp_C <- paste(temp_C, ".csv", sep = "" )
  },
  error=function(cond) {
    message(paste("the link you created is incorrect", date))
    message("Here's the original error message:")
    message(cond)
    # Choose a return value in case of error
    return(NA)
  },
  warning=function(cond) {
    message(paste("the created URL caused a warning:", date))
    message("Here's the original warning message:")
    message(cond)
    # Choose a return value in case of warning
    return(NULL)
  })
  return(out)
}

download_link <-function(url, aggregated=FALSE){
    
  #' Download Link function
  #'
  #' Download link available on J.H website 
  #' 
  #' @param url dataset url
  #' @param aggregated boolean flag to indicate whether data was already aggregated 
  #'
  #' @return None
  #' @export
  #'
  #' @examples
  #' # Download the url : "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/03-04-2021.csv"
  #' download_link('03-04-2021')

    out <- tryCatch({
    dest_file_name <- create_out_name_based_on_url(url, aggregated)
    print(dest_file_name)
    download.file(url, 
                  destfile = dest_file_name, 
                  mode = "wb", quiet = FALSE)
  },
  error=function(cond) {
    message ("There was an error while downloading,
    please check the path or the file availability")
    
    message(cond)  
    return(NA)
  })
  return(out)
}



util_JH_general_clean <- function(dataframe, country){

 dataframe <- dataframe %>%
  # format region name
  mutate(Country_Region = toupper(Country_Region)) %>%
  dplyr::filter(Country_Region == country)  %>%
  
  # keep only numeric data (Confirmed - Deaths)
  dplyr::filter(is.numeric(Confirmed)) %>%
  dplyr::filter(is.numeric(Deaths)) %>%  
  dplyr::filter(Confirmed >=0) %>% 
  dplyr::filter(Deaths >=0) %>% 
  dplyr::filter(!grepl("Princess", Province_State)) %>%

  # clean Province_ State
  tidyr::separate(Province_State, c("Province_State", NA), sep = ",") %>%
  tidyr::separate(Province_State, c("Province_State", NA), sep = " County") %>%
  dplyr::mutate(Province_State = stringr::str_to_title(Province_State)) %>%
  return(dataframe)
}

util_clean_no_aggregation <- function(csv_file, country){
    
  #' clean_no_aggregation
  #'
  #' general clean function for J.H website gather daily data 
  #' for data not aggregated/filtered
  #' 
  #' @param csv_file input csv_file
  #' @param country country for which the report is issued
  #' @return None
  #' @export
  #'
  #' @examples
  #' # Clean the dataset : "03-04-2021.csv"
  #' clean_no_aggregation('03-04-2021.csv')


  df_r <- readr::read_csv(csv_file)

  # if the format does not comprises (Confirmed or Deaths) -> early stop
  if (!("Deaths" %in% colnames(df_r)) | 
      !("Confirmed" %in% colnames(df_r))){   
        stop("the Confirmed cases and Deaths columns are absent from the data", call.=FALSE)
      }


  # if the format comprises (Province_State, Country region, Admin2) -> Data refinement
  # filter numeric data
  # standardize columns text style

  if (("Admin2" %in% colnames(df_r)) & 
      ("Province_State" %in% colnames(df_r)) & 
      ("Country_Region" %in% colnames(df_r))){
    
      df_r <- util_JH_general_clean(df_r,country) 
      df_r <- df_r %>%
              tidyr::separate(Admin2, c("Admin2",NA), sep = ",") %>%
              tidyr::separate(Admin2, c("Admin2",NA), sep = " County") %>%                   
              dplyr::mutate(Admin2 = stringr::str_to_title(Admin2)) %>%
      return(df_r)

  }

  # in some cases (old reports) the headers are formatted with "/"
  # clause try/catch inspired from Python
  # filter numeric data
  # standardize columns text style

  else if (!("Admin2" %in% colnames(df_r))) {
    
   out <- tryCatch({
     df_r <- df_r %>% 
                dplyr::rename(`Country_Region` = `Country/Region`, `Province_State` = `Province/State`) 
     df_r <-  util_JH_general_clean(df_r,country) 
     df_r <-  df_r%>%
              tidyr::separate(Admin2, c("Admin2",NA), sep = ",") %>%
              tidyr::separate(Admin2, c("Admin2",NA), sep = " County") %>%
              dplyr::mutate(Admin2 = stringr::str_to_title(Admin2)) %>%


     return(df_r)},

  # in case of a format with "/" in the columns names and without Admin2
  error = function(cond){

              df_r <- df_r %>% dplyr::rename(`Country_Region` = `Country/Region`, `Province_State` = `Province/State`) 
              df_r <- util_JH_general_clean(df_r,country) 
              df_r <- df_r%>%

              return(df_r)
      })
  return(out)
  }

  # unsupported format
  else{
      stop(message("the data format is different please refer to data of: 15-25-2020 for reference"), call.=FALSE)
      return(NA) 
  }
}

util_clean_aggregation <- function(csv_file, country){
  #' clean_aggregation
  #'
  #' general clean function for J.H website gather daily data 
  #' for data already aggregated/filtered
  #' 
  #' @param csv_file input csv_file
  #' @param country country for which the report is issued
  #'
  #' @return None
  #' @export
  #'
  #' @examples
  #' # Clean the dataset: "03-04-2021.csv"
  #' clean_aggregation('03-04-2021.csv')

  df_r <- util_JH_general_clean(df_r, country)

  df_r <- dplyr::filter(df_r, Province_State != "Recovered")
  df_r <- dplyr::filter(df_r, Province_State != "Diamond Princess")  
  df_r <- dplyr::filter(df_r, Province_State != "Grand Princess")
  df_r <- dplyr::filter(df_r, Country_Region == country )
  return(df_r)
}

JH_clean_data <- function(date='01-01-2021', country, aggregated=FALSE){
    
  #' Clean_us_data
  #'
  #' clean J.H website to limit data in the US 
  #' 
  #' @param date queried date for analysis
  #' @param country queried country for analysis
  #' @param aggregated boolean flag to indicate whether data was already aggregated
  #'
  #' @return None
  #' @export
  #'
  #' @examples
  #' # Filter the dataset to US entries: "03-04-2021.csv"
  #' clean_us_data2('03-04-2021.csv')

  
  csv_filename = create_out_name_based_on_date(date,aggregated)
  df_r <- readr::read_csv(csv_filename)
  print(df_r)
  if (aggregated){
    return(util_clean_aggregation(df_r,country))
    }
  else {
    return(util_clean_no_aggregation(df_r,country))
  }
}

util_confirmed_death_summarize_state <- function(dataframe) {

  #' Create a report with confirmed cases and deaths
  #' for each State (Helper function)
  #'
  #' create the daily report
  #' 
  #' @param dataframe input (cleaned) dataframe - contains Admin2
  #'
  #' @return summarized_dataframe
  #' @export
  #'
  #' @examples
  #' # create a report: confirmed_death_summarize_county(dataframe)
  #'  
    
  summarized_dataframe <- dataframe %>% 
  # In case there are k>1 entry per county
  # need to sum values for the same county

  group_by(Province_State) %>%
  dplyr::summarize(total_confirmed_state = sum(Confirmed, na.rm = FALSE),
                  total_deaths_state = sum(Deaths, na.rm = FALSE)) %>%

  # we can then group by State averaging Deaths & Confirmed cases
  # & averaging per county
  group_by(Province_State) %>%
  dplyr::summarize(avg_confirmed_state = mean(total_confirmed_state, na.rm = FALSE),
  avg_deaths_state = mean(total_deaths_state, na.rm = FALSE))

  return(summarized_dataframe)
}

util_confirmed_death_summarize_county <- function(dataframe) {

  #' Create a report with confirmed cases and deaths
  #' averaged over counties for each State (Helper function)
  #'
  #' create the daily report
  #' 
  #' @param dataframe input (cleaned) dataframe - does not contain Admin2
  #'
  #' @return summarized_dataframe
  #' @export
  #'
  #' @examples
  #' # create a report: confirmed_death_summarize_county(dataframe)
  #'  
    
  summarized_dataframe <- dataframe %>% 
  # In case there are k>1 entry per county
  # need to sum values for the same county

  group_by(Admin2, Province_State) %>%
  dplyr::summarize(total_confirmed_county = sum(Confirmed, na.rm = FALSE),
                  total_deaths_county = sum(Deaths, na.rm = FALSE)) %>%

  # we can then group by State averaging Deaths & Confirmed cases
  # & averaging per county
  group_by(Province_State) %>%
  summarize(avg_confirmed_state = mean(total_confirmed_county, na.rm = FALSE),
  avg_deaths_state = mean(total_deaths_county, na.rm = FALSE))

  return(summarized_dataframe)
}

JH_confirmed_death_summarize <- function(dataframe, aggregated=FALSE){

  #' Create a report with confirmed cases and deaths
  #' averaged over counties for each State
  #'
  #' create the daily report
  #' 
  #' @param dataframe input (cleaned) dataframe
  #' @param aggregated boolean flag to indicate whether data was already aggregated

  #' @return summarized_dataframe
  #' @export
  #'
  #' @examples
  #' # create a report: confirmed_death_summarize_county(dataframe)
  #'  

  if (aggregated){
    return(util_confirmed_death_summarize_state(dataframe))
  } else{
    return(util_confirmed_death_summarize_county(dataframe))
  }
}