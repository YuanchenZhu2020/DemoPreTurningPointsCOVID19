#' Forcast over a period of time
#'
#' Forcast over a period of time. Each day in the period is taken as
#' the starting time of prediction.
#'
#' @param filepath path of the target data file.
#' @param M the selection of time window.
#' @param ST the selection of begining time,
#' which must be in the formate "%y-%m-%d" as a character.
#' @param period the number of days in the selected time period.
#'
#' @return A dataframe contains begining time of prediction,
#' and T.2, Z.1, Z.2 in the formate "%y-%m-%d" as a character.
#' BeginingTime: the begining time of prediction.
#' T.2: the second turning point
#' Z.1: the first 'zero' point
#' Z.2: the second 'zero' point
#' @export
#'
#' @examples
PeriodForcast <- function(filepath, M, ST, period) {
  wd <- utils::read.csv(filepath)
  BeginingTime <- rep("", period)
  T.2 <- rep("", period)
  Z.1 <- rep("", period)
  Z.2 <- rep("", period)

  for (i in 1:period) {
    print(i)#
    tmpST <- as.character(as.Date(ST) + i - 1)
    print(tmpST)#
    x = DemoPreTurningPointsCOVID19::totalPrediction(wd, M, tmpST)
    BeginingTime[i] <- tmpST
    T.2[i] <- as.character(x[1, 3])
    Z.1[i] <- as.character(x[1, 4])
    Z.2[i] <- as.character(x[1, 5])
  }

  result <- data.frame("BeginingTime" = BeginingTime,
                       "T.2" = T.2,
                       "Z.1" = Z.1,
                       "Z.2" = Z.2)
  return(result)
}
