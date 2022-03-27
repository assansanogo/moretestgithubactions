
create_link <- function(date='01-01-2021', aggregated= TRUE) {
  
  #' Create Link function
  #'
  #' Concatenate date and repository link
  #' 
  #' @param date. (date before which the data is retrieved)
  #' @param aggregated. (data is available as already aggregated - US ONLY or raw - all countries )
  #'
  #' @return An url string - complete link
  #' @export
  #'
  #' @examples
  #' # Create the url based on date : 03-04-2021
  #' create_link('03-04-2021')

  
  if (aggregated){
      root <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/"
  }
  else {
      root <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"
  }

  out <- tryCatch({
    temp_C <- paste(root, date, sep = "" )
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

download_link <-function(url){
    
  #' Download Link function
  #'
  #' Download link available on J.H website 
  #' 
  #' @param url
  #'
  #' @return None
  #' @export
  #'
  #' @examples
  #' # Download the url : "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports_us/03-04-2021.csv"
  #' download_link('03-04-2021')

    out <- tryCatch({
    download.file(url, destfile = basename(url),mode = "wb",quiet = FALSE)
  },
  error=function(cond) {
      
    message ("There was an error whilme downloading,please check the path or the file availability")
    message(cond)
    
    return(NA)
  })
  return(out)
}

clean_us_data <- function(csv_file, aggregated= TRUE){
    
  #' Clean_us_data
  #'
  #' clean J.H website to limit correct data in the US 
  #' 
  #' @param csv_file
  #'
  #' @return None
  #' @export
  #'
  #' @examples
  #' # Filter the dataset to US entries: "03-04-2021.csv"
  #' clean_us_data('03-04-2021.csv')


  df_r <- read_csv(csv_file)

  if (aggregated){
    if ("Testing_Rate" %in% colnames(df_r)){
      df_r <- df_r %>% tidyverse::filter(!is.na('Testing_Rate')) %>% filter(Province_State !="Diamond Princess") %>% filter(Province_State !="Grand Princess") %>% filter(Country_Region == "US" )
    return(df_r)
    }
    else {
    df_r <- df_r %>% 
                tidyverse::filter(Province_State != "Recovered")  %>% 
                tidyverse::filter(Province_State != "Diamond Princess")  %>%
                tidyverse::filter(Province_State != "Grand Princess")  %>%
                tidyverse::filter(Country_Region == "US" )
    return(df_r)
    }
  }

  else {
      return("NON IMPLEMENTED")

  }
}

