library(tinsel)
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

#. print_start_end
todays_date <- function()
{
  res =  c("the current date is:", Sys.Date())
    print(paste(res))
  
}

#. print_start_end
yesterday <- function()
{
    res =  c("yesterday date was:", Sys.Date() -1)
    print(paste(res))
  
}
#. print_start_end
tomorrow <- function()
{
    res =  c("tomorrow date will be:", Sys.Date() +1)
    print(paste(res))
  
}
