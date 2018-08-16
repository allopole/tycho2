# data object "weekdays" (stored with package):
weekdaynumbers <- c(
  "Sunday"=1,"Monday"=2,"Tuesday"=3,"Wednesday"=4,"Thursday"=5,"Friday"=6,"Saturday"=7,
  "isoweek.start"=2,"isoweek.end"=1,
  "cdcweek.start"=1,"cdcweek.end"=7
)
devtools::use_data(weekdaynumbers, internal = TRUE, overwrite=TRUE)
