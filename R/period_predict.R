#' Prediction over a period of time
#'
#' Take each day of a period of time as the starting point of prediction
#' and get the result.
#'
#' @param datafile it can be the path of data file as Charactors or
#' be the raw data read from .csv as a dataframe.
#' @param M the selection of time window.
#' @param Beginning_Time the selection of beginning time,
#' which must be in the formate "%y-%m-%d" as a character.
#' @param period the number of days in the selected time period.
#'
#' @return List contains as many sublist as the value of param period.
#'  Each sublist is the result of a prediciton with the given time t as
#'  beginning time. And each sublist is named with the beginning time of predicion.
#' @export
#'
#' @examples Beginning_Time <- "2020-01-29"
#' M <- 5
#' period <- 32
#' period_predict(DemoPreTurningPointsCOVID19::COVID19_CN, M,
#' Beginning_Time, period)
period_predict <- function(datafile, M, Beginning_Time, period) {
  # if param [datafile] is dataframe, then [datafile] is RawData read from *.csv.
  # if param [datafile] is Charactors, then [datafile] is the path of data file.
  if (is.data.frame(datafile)) {
    RawData = datafile
  }
  else if (is.character(datafile)) {
    RawData <- utils::read.csv(datafile)
  }
  else {
    stop("Wrong input of @param datafile!")
  }

  beginning_time_period <- rep("", period)
  period_result <- list()

  for (i in 1:period) {
    tmpST <- as.character(as.Date(Beginning_Time) + i - 1)
    tmpResult = DemoPreTurningPointsCOVID19::prediction(RawData, M, tmpST)
    beginning_time_period[i] <- tmpST
    period_result[[i]] <- tmpResult
  }

  names(period_result) <- beginning_time_period

  return(period_result)
}
