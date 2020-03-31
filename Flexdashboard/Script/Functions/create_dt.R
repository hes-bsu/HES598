## Create DT function
## This creates an interactive data table that allows copying and saving data from Rmd
create_dt <- function(x, caption = NULL){
  DT::datatable(x,extensions = 'Buttons',
                caption = caption,
                filter = 'top',
                options = list(# bLengthChange = FALSE,
                               dom = 'lrtipB',
                               buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                               lengthMenu = list(c(-1, 10,25,50),
                                                 c("All", 10,25,50))))
}