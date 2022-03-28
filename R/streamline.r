
create_out_name_based_on_url<- function(url, aggregated=TRUE){

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

create_out_name_based_on_date<- function(date='01-01-2021', aggregated=TRUE){

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

create_full_link <- function(date='01-01-2021', aggregated= TRUE) {
  
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

download_link <-function(url, aggregated= TRUE){
    
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
    dest_file_name <- create_out_name_url(url)
    download.file(url, destfile = dest_file_name, mode = "wb", quiet = FALSE)
  },
  error=function(cond) {
    message ("There was an error while downloading,please check the path or the file availability")
    message(cond)  
    return(NA)
  })
  return(out)
}

clean_us_data2 <- function(date='01-01-2021', country="US", aggregated= TRUE){
    
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

  if (aggregated){
    if ("Testing_Rate" %in% colnames(df_r)){
      df_r <- dplyr::filter(df_r, !is.na('Testing_Rate'))
      df_r <- dplyr::filter(df_r, Province_State != "Diamond Princess") 
      df_r <- dplyr::filter(df_r, Province_State != "Grand Princess") 
      df_r <- dplyr::filter(df_r, Country_Region == country)
    return(df_r)
    }
    else {
      df_r <- dplyr::filter(df_r, Province_State != "Recovered")
      df_r <- dplyr::filter(df_r, Province_State != "Diamond Princess")  
      df_r <- dplyr::filter(df_r, Province_State != "Grand Princess")
      df_r <- dplyr::filter(df_r, Country_Region == country )
    return(df_r)
    }
  }

  else {
      return("NON IMPLEMENTED")

  }
}

confirmed_death_summarize_state <- function(dataframe) {

  #' Create a report with confirmed cases and deaths
  #' for each State
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

confirmed_death_summarize_county <- function(dataframe) {

  #' Create a report with confirmed cases and deaths
  #' averaged over counties for each State
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
