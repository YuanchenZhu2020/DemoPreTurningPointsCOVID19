#' Integrate functions and handle a special situation (removedrate > 1)
#'
#' Integrate functions above, and handle a special situation (removedrate > 1).
#'
#' @param wd dataframe with data and four variables, i.e.
#' the cumulative confirmed cases up to the given day t,
#' the daily confirmed cases at day t,
#' the daily recovered ones and the daily deaths at day t
#' @param M the selection of time window.
#' @param ST the selection of begining time,
#' which must be in the formate "%y-%m-%d" as a character.
#'
#' @return A dataframe contains prediction result of removedrate, inhospitals,
#' and T.2, Z.1, Z.2.
#' @export
#'
#' @examples
totalPrediction <- function(wd, M, ST) {
  iconic <- DemoPreTurningPointsCOVID19::Iconicfun(wd)
  date <- iconic$date
  confirmed <- iconic$confirmed
  recovered <- iconic$recovered
  deaths <- iconic$deaths
  inhospitals <- iconic$inhospitals
  infectionrate <- iconic$infectionrate
  removedrate <- iconic$removedrate

  f <- data.frame(date = date,
                  confirmed = confirmed,
                  inhospitals = inhospitals,
                  infectionrate = infectionrate,
                  removedrate = removedrate)
  f$date <- as.Date(f$date)

  velocity <- DemoPreTurningPointsCOVID19::CalculateVelocity(date, confirmed, inhospitals, infectionrate, removedrate, M, ST)
  InfectionRateVelocity <- as.numeric(velocity["InfectionRateVelocity"])
  RemovedRateVelocity <- as.numeric(velocity["RemovedRateVelocity"])
  ST.removed <- as.numeric(velocity["ST.removed"])
  M.removed <- as.numeric(velocity["M.removed"])

  prediction <- DemoPreTurningPointsCOVID19::Prediction(date, confirmed, inhospitals, infectionrate, removedrate, InfectionRateVelocity, RemovedRateVelocity, ST)
  removedrate.pre <- prediction$removedrate.pre

  # This while loop is used to avoid RemovedRateVelocity > 1, which is counterintuitive.
  while (removedrate.pre[length(removedrate.pre)] > 1 & ST.removed >= 1) {
    ST.removed <- ST.removed - 1
    while (f$removedrate[ST.removed - M.removed + 1] >= f$removedrate[ST.removed]
           | f$removedrate[ST.removed - M.removed + 1] == 0) {
      M.removed <- M.removed - 1
      if (M.removed > 1) next
      else {
        ST.removed <- ST.removed - 1
        M.removed <- M
        if(ST.removed >= 0) next
        else {
          stop("The completion rate heaven't increase yet.")
        }
      }
    }

    RemovedRateVelocity <- (f$removedrate[ST.removed] / f$removedrate[ST.removed - M.removed + 1]) ^ (1 / (M.removed - 1))
    prediction <- DemoPreTurningPointsCOVID19::Prediction(date, confirmed, inhospitals, infectionrate, removedrate, InfectionRateVelocity, RemovedRateVelocity, ST)
    removedrate.pre <- prediction$removedrate.pre
  }

  return(prediction)
}
