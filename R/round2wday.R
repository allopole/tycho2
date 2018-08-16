#' Round a date to the nearest specified weekday
#'
#' \code{round2wday} rounds a date to the nearest target weekday.
#'
#' Target weekday can be specified as a named weekday or its numerical equivalent,
#' from the following table:
#'
#' \tabular{rl}{
#'   \strong{Name} \tab \strong{Number}\cr
#'   Sunday \tab 1\cr
#'   Monday \tab 2\cr
#'   Tuesday \tab 3\cr
#'   Wednesday \tab 4\cr
#'   Thursday \tab 5\cr
#'   Friday \tab 6\cr
#'   Saturday \tab 7\cr
#'   cdcweek.start \tab 1\cr
#'   cdcweek.end \tab 7\cr
#'   isoweek.start \tab 2\cr
#'   isoweek.end \tab 1\cr
#'   }
#'
#' @param date Date, POSIXct, POSIXlt, or character string the the format "YYYY-MM-DD"
#' @param targetwday Target weekday
#' @return Date ("YYYY-MM-DD")
#' @export
round2wday <- function(date,targetwday) {
  if(is.numeric(targetwday)) {
    t.day <- as.integer(targetwday)
  }else{
    t.day <- as.integer(weekdaynumbers[targetwday])
  }
  if(is.na(t.day)) {
    stop(paste("targetweekday must be an integer 1 to 7, or one of:\n",
               paste(names(weekdaynumbers),collapse = ", ")))
  }
  i.date <- as.Date(date)
  i.day <- as.POSIXlt(i.date)$wday + 1L
  shift <- -(i.day - t.day + 4L) %% 7L - 3L
  return(i.date+shift)
}

