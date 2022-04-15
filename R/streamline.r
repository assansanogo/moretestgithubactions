# functions with prefix: "util" are helper functions
# reused in main functions identified by prefix: "JH"

create_out_name_based_on_url<- function(url, aggregated=FALSE){

  #' Create filename based on url
  #'
  #' create the out_folder format 
  #' 
  #' @param url dataset url (from which is extracted the output filename)
  #' @param aggregated boolean flag to indicate whether data was already aggregated 
  #' @importFrom magrittr "%>%"
  #' @return dest_file_name
  #' @export
  #'
  #' @examples
  #' # create_out_name_based_on_url: create_out_name_based_on_url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/03-04-2021.csv")
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
  #' @importFrom magrittr "%>%"
  #' @return dest_file_name
  #' @export
  #'
  #' @examples
  #' # create a filename with info about date and aggregation
  #' create_out_name_based_on_date: create_out_name_based_on_date('01-01-2021')  
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
  #' @importFrom magrittr "%>%"
  #' @return An url string - complete link
  #' @export
  #'
  #' @examples
  #' # Create the url based on date : 01-01-2021 & non aggregated
  #' create_full_link('03-04-2021')

  
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
  #' @importFrom magrittr "%>%"
  #' @return None
  #' @export
  #'
  #' @examples
  #' # Download the url for aggregated data: "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/03-04-2021.csv"
  #' download_link( "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/03-04-2021.csv",TRUE)

    out <- tryCatch({
    dest_file_name <- create_out_name_based_on_url(url, aggregated)
    
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

util_JH_general_clean <- function(dataframe, country="US"){

  #' general cleaner for JH
  #'
  #' create a general clean
  #' 
  #' @param dataframe queried dataframe
  #' @param country filtered on
  #' @importFrom magrittr "%>%"
  #' @return dataframe
  #' @export
  #'
  #' @examples
  #' # create output filename: 
  #'  util_JH_general_clean(dataframe,"US")



  # format region name
  dataframe <- dataframe %>%
  dplyr::mutate(Country_Region = toupper(Country_Region)) %>%
  dplyr::filter(Country_Region == country)  %>%
  
  # keep only numeric data (Confirmed - Deaths)
  dplyr::filter(is.numeric(Confirmed)) %>%
  dplyr::filter(is.numeric(Deaths)) %>%  
  dplyr::filter(!is.na(Confirmed)) %>% 
  dplyr::filter(!is.na(Deaths)) %>% 
  dplyr::filter(!grepl("Princess", Province_State)) %>%

  # clean Province_ State
  tidyr::separate(Province_State, c("Province_State", NA), sep = ",") %>%
  tidyr::separate(Province_State, c("Province_State", NA), sep = " County") %>%
  dplyr::mutate(Province_State = stringr::str_to_title(Province_State))
  print(dataframe)
  return(dataframe)
}

util_clean_no_aggregation <- function(csv_file, country="US"){
    
  #' clean_no_aggregation
  #'
  #' general clean function for J.H website gather daily data 
  #' for data not aggregated/filtered
  #' 
  #' @param csv_file input csv_file
  #' @param country country for which the report is issued
  #' @importFrom magrittr "%>%"
  #' @return None
  #' @export
  #'
  #' @examples
  #' # Clean the dataset : "03-04-2021.csv" for the "US"
  #' util_clean_no_aggregation('03-04-2021.csv','US')

  # change separator to be ";"
  df_r <- readr::read_csv(csv_file)
        write.csv2(df_r, 
                  file=csv_file)
  # use df_r
  df_r <- readr::read_delim(csv_file, delim=";")

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

util_clean_aggregation <- function(csv_file, country="US"){
  #' clean_aggregation
  #'
  #' general clean function for J.H website gather daily data 
  #' for data already aggregated/filtered
  #' 
  #' @param csv_file input csv_file
  #' @param country country for which the report is issued
  #' @importFrom magrittr "%>%"
  #' @return None
  #' @export
  #'
  #' @examples
  #' # Clean the dataset: "03-04-2021.csv"
  #' util_clean_aggregation('03-04-2021.csv','US')

  df_r <- readr::read_csv(csv_file)

  df_r <- util_JH_general_clean(df_r, country)
  

  df_r <- dplyr::filter(df_r, Province_State != "Recovered")
  df_r <- dplyr::filter(df_r, Province_State != "Diamond Princess")  
  df_r <- dplyr::filter(df_r, Province_State != "Grand Princess")
  df_r <- dplyr::filter(df_r, Province_State != "Unknown")
  df_r <- dplyr::filter(df_r, Country_Region == country )
  return(df_r)
}

JH_clean_data <- function(date='01-01-2021', country="US", aggregated=FALSE){
    
  #' Clean_us_data
  #'
  #' clean J.H website to limit data in the US 
  #' 
  #' @param date queried date for analysis
  #' @param country queried country for analysis
  #' @param aggregated boolean flag to indicate whether data was already aggregated
  #' @importFrom magrittr "%>%"
  #' @return None
  #' @export
  #'
  #' @examples
  #' # Filter the dataset to US entries: "03-04-2021.csv"
  #' clean_us_data2('03-04-2021.csv')

  
  csv_filename = create_out_name_based_on_date(date, aggregated)

  if (aggregated){
    return(util_clean_aggregation(csv_filename, country))
    }
  else {
    return(util_clean_no_aggregation(csv_filename, country))
  }
}

util_confirmed_death_summarize_state <- function(dataframe, date='01-01-2021') {

  #' Create a report with confirmed cases and deaths
  #' for each State (Helper function)
  #'
  #' create the daily report
  #' 
  #' @param dataframe input (cleaned) dataframe - contains Admin2
  #' @importFrom magrittr "%>%"
  #' @return summarized_dataframe
  #' @export
  #'
  #' @examples
  #' # create a report: confirmed_death_summarize_county(dataframe)
  #'  
  
  
  col_tot_confirmed_state<-stringr::str_interp("total_confirmed_state_${date}")
  col_tot_death_state<-stringr::str_interp("total_deaths_state_${date}")
  col_avg_confirmed_state<-stringr::str_interp("total_confirmed_state_${date}")
  col_avg_death_state<-stringr::str_interp("total_deaths_state_${date}")
  
  summarized_dataframe <- dataframe %>% 
  # In case there are k>1 entry per state
  # need to sum values for the same state

  dplyr::group_by(Province_State) %>%
  dplyr::summarize(col_tot_confirmed_state=sum(Confirmed, na.rm = FALSE),
                   col_tot_death_state=sum(Deaths, na.rm = FALSE)) %>%


  return(summarized_dataframe)
}

util_confirmed_death_summarize_county <- function(dataframe, date='01-01-2021') {

  #' Create a report with confirmed cases and deaths
  #' averaged over counties for each State (Helper function)
  #'
  #' create the daily report
  #' 
  #' @param dataframe input (cleaned) dataframe - does not contain Admin2
  #' @importFrom magrittr "%>%"
  #' @return summarized_dataframe
  #' @export
  #'
  #' @examples
  #' # create a report per county: 
  #' # util_confirmed_death_summarize_county (dataframe)
   
  # we define new columns names for export
  col_tot_confirmed_county<-stringr::str_interp("total_confirmed_county_${date}")
  col_tot_death_county<-stringr::str_interp("total_deaths_county_${date}")
  col_avg_confirmed_state<-stringr::str_interp("total_confirmed_state_${date}")
  col_avg_death_state<-stringr::str_interp("total_deaths_state_${date}")
  
  summarized_dataframe <- dataframe %>% 
  # In case there are k>1 entry per county
  # need to sum values for the same county

  dplyr::group_by(Admin2, Province_State) %>%
  dplyr::summarize(col_tot_confirmed_county=sum(Confirmed, na.rm = FALSE),
                   col_tot_death_county=sum(Deaths, na.rm = FALSE)) %>%

  # we can then group by State averaging Deaths & Confirmed cases
  # & averaging per county (keep 2 digits)
  
  
  dplyr::group_by(Province_State) %>%
  dplyr::summarize(col_avg_confirmed_state=round(mean(col_tot_confirmed_county, na.rm = FALSE), 2),
                   col_avg_death_state=round(mean(col_tot_death_county, na.rm = FALSE), 2)) %>%
  dplyr::rename(
    !!col_avg_confirmed_state := col_avg_confirmed_state,
    !!col_avg_death_state := col_avg_death_state
    )
  return(summarized_dataframe)
}

JH_confirmed_death_summarize <- function(dataframe, date='01-01-2021',aggregated=FALSE){

  #' Create a report with confirmed cases and deaths
  #' averaged over counties for each State
  #'
  #' create the daily report
  #' 
  #' @param dataframe input (cleaned) dataframe
  #' @param aggregated boolean flag to indicate whether data was already aggregated
  #' @importFrom magrittr "%>%"
  #' @return summarized_dataframe
  #' @export
  #'
  #' @examples
  #' # create a report: results of 01-01-2021 without aggregation
  #'  confirmed_death_summarize_county(dataframe,'01-01-2021',FALSE)

  if (aggregated){
    return(util_confirmed_death_summarize_state(dataframe,date))
  } else{
    return(util_confirmed_death_summarize_county(dataframe,date))
  }
}
