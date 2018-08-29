#' Extract ZOO Time Series of Cases from a Tycho 2.0 dataframe
#'
#' \code{extractzoo} and \code{tycho2zoo} extracts regular time series of class \code{zooreg} from a
#' dataframe or tibble.
#'
#' \code{extractzoo} aggregates the \code{data} by summing for each unique value of \code{index},
#' calculates the underlying time interval of the data, pads missing data with \code{NA}'s, and
#' returns a regular time series (numeric vector) of class \code{zooreg}. See
#' \code{\link[zoo]{zooreg}} for details.
#'
#' \code{tycho2zoo} is a convenience wrapper for \code{extractzoo} with default values
#' \code{index = "PeriodEndDate"} and \code{data = "CountValue"}.
#'
#' @param dataset Data Frame or Tibble with at least one variabel of class \code{Date},
#' \code{POSIXct} or \code{POSIXlt}.
#' @param index Character. Name of variable to use as index. Variable must be of class \code{Date},
#' \code{POSIXct} or \code{POSIXlt}
#' @param data Character. Name of variable to use as data.
#' @param FUN Name of function to use for aggregation. May be quoted or not. Default = \code{sum}
#'
#' @return A regular time series of class \code{zooreg}.
#'
#' @import dplyr
#' @import zoo
#' @importFrom padr pad
#' @importFrom rlang sym
#' @importFrom tibble as_tibble
#' @importFrom stats frequency
#'
#' @examples
#'
#' mydata <- data.frame(date = as.Date(c("2000/1/1",
#'                                           "2000/1/1",
#'                                           "2000/1/8",
#'                                           "2000/1/22",
#'                                           "2000/1/29",
#'                                           "2000/1/29")),
#'                          city = c("NY","BOS","NY","NY","BOS","NY"),
#'                          temp = c(2.0, 0.5, 5.5, 3.8, 7.1, 9.0))
#' mydata
#' meantemp <- dataframe2zoo(mydata, index="date", data="temp", FUN=mean)
#' meantemp
#'
#' @export

dataframe2zoo <- function(dataset, index, data, FUN="sum") {
  FUN <- match.fun(FUN)
  index <- rlang::sym(index)
  data <- rlang::sym(data)
  tbl <- tibble::as_tibble(dataset)
  tbl <- dplyr::group_by(tbl, !!index)
  tbl <- dplyr::summarise(tbl, newdata = FUN(!!data))
  tbl <- dplyr::arrange(tbl, !!index)
  tbl <- padr::pad(tbl)
  ts.zoo <- zoo::zoo(tbl$newdata, dplyr::pull(tbl, 1))
  attr(ts.zoo,"frequency") <- stats::frequency(ts.zoo)
  return(ts.zoo)
}

#' @rdname dataframe2zoo
#' @export

tycho2zoo <- function(dataset, index = "PeriodEndDate", data = "CountValue", FUN="sum") {
  dataframe2zoo(dataset = dataset, index = index, data = data)
}

## group_by_at(vars(-c(PlaceOfAcquisition,CountValue))) %>%  # more explicit
## group_by(ConditionName, PathogenName, Admin1Name, PeriodStartDate,PeriodEndDate) %>% # semi verbose
