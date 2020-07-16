#' Prediction over a period of time
#'
#' Take each day of a period of time as the starting point of prediction
#' and get the result.
#'
#' @param datafile it can be the path of data file as Charactors or
#' be the raw data read from .csv as a dataframe.
#' @param M the selection of time window.
#' @param Begining_Time the selection of begining time,
#' which must be in the formate "%y-%m-%d" as a character.
#' @param period the number of days in the selected time period.
#'
#' @return List contains as many sublist as the value of param period.
#'  Each sublist is the result of a prediciton with the given time t as
#'  begining time. And each sublist is named with the begining time of predicion.
#' @export
#'
#' @examples Begining_Time <- "2020-01-29"
#' M <- 5
#' period <- 32
#' period_predict(DemoPreTurningPointsCOVID19::COVID19_CN, M,
#' Begining_Time, period)
period_predict <- function(datafile, M, Begining_Time, period) {
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

  begining_time_period <- rep("", period)
  period_result <- list()

  for (i in 1:period) {
    tmpST <- as.character(as.Date(Begining_Time) + i - 1)
    tmpResult = DemoPreTurningPointsCOVID19::prediction(RawData, M, tmpST)
    begining_time_period[i] <- tmpST
    period_result[[i]] <- tmpResult
  }

  names(period_result) <- begining_time_period

  return(period_result)
}
