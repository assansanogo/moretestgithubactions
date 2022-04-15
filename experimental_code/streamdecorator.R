library(tinsel)

  #' simple decorator concept with starting call and ending callnotification
  #' 
  #'
  #' wrap the function with "Starting call" & "Ending call"
  #' 
  #' @param f wrapped function
  #' @export
  #'
  #' @examples
  #' #. print_start_end
  #' whatever_is_my_function()

print_start_end <- function(f)
{
  wrapper <- function(...)
  {
      print("Starting function call...") 
  
      f() 
  
      print("Finished function call...") 
  
  }
    
  return(wrapper) 
  
}


  #' decorated function returning today's date
  #' 
  #' wrapped the function with "Starting call" & "Ending call"
  #' 
  #' @export
  #'
  #' @examples
  #' #. print_start_end
  #' whatever_is_my_function()

#. print_start_end
todays_date <- function()
{
  res =  c("the current date is:", Sys.Date())
    print(paste(res))
}


  #' decorated function returning yesterday's date
  #' 
  #' wrapped the function with "Starting call" & "Ending call"
  #' 
  #' @export
  #'
  #' @examples
  #' #. print_start_end
  #' whatever_is_my_function()

#. print_start_end
yesterday <- function()
{
    res =  c("yesterday date was:", Sys.Date() -1)
    print(paste(res))
}


  #' decorated function returning tomorrow's date
  #' 
  #' wrapped the function with "Starting call" & "Ending call"
  #' 
  #' @export
  #'
  #' @examples
  #' #. print_start_end
  #' whatever_is_my_function()

#. print_start_end
tomorrow <- function()
{
    res =  c("tomorrow date will be:", Sys.Date() +1)
    print(paste(res))
  
}
