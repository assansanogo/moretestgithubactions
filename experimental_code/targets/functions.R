# simple histogram plot 
#. done with ggpplot + setting background

create_plot <- function(data) {
  ggplot(data) +
    geom_histogram(aes(x = Ozone)) +
    theme_gray(24)
}
