#' Predict future indicators and get 3 turning points
#'
#' Predict future infectionrate, removedrate, E_t, inhospitals
#' and get T.2, Z.1 and Z.2 at the same time.
#'
#' @param date the exact day in the formate "%y-%m-%d" as a character.
#' @param confirmed the daily confirmed cases at the given date.
#' @param inhospitals The number of infectious cases in hospital.
#' @param infectionrate The daily infection rate.
#' @param removedrate the daily removed rate.
#' @param InfectionRateVelocity the velocity of infection rate change.
#' @param RemovedRateVelocity the velocity of complerion rate change.
#' @param ST the selection of begining time,
#' which must be in the formate "%y-%m-%d" as a character.
#'
#' @return A dataframe contains prediction result of removedrate, inhospitals,
#' and T.2, Z.1, Z.2.
#' @export
#'
#' @examples
Prediction <- function(date, confirmed, inhospitals, infectionrate, removedrate, InfectionRateVelocity, RemovedRateVelocity, ST) {
  f <- data.frame(date = date,
                  confirmed = confirmed,
                  inhospitals = inhospitals,
                  infectionrate = infectionrate,
                  removedrate = removedrate)
  f$date <- as.Date(f$date)

  ST.infection <- which(f$date == ST)

  infectionrate.0 <- f$infectionrate[ST.infection]
  removedrate.0 <- f$removedrate[ST.infection]
  confirmed.0 <- f$confirmed[ST.infection]
  inhospitals.0 <- f$inhospitals[ST.infection]

  infectionrate.pre <- c(infectionrate.0)
  removedrate.pre <- c(removedrate.0)
  confirmed.pre <- c(confirmed.0)
  inhospitals.pre <- c(inhospitals.0)

  t <- 1

  # to predict the first zero point Z.1.
  while (confirmed.pre[t] > 1) {
    t <- t + 1

    infectionrate <- infectionrate.pre[t - 1] * InfectionRateVelocity
    removedrate <- removedrate.pre[t - 1] * RemovedRateVelocity
    R_t <- 1 + infectionrate - removedrate
    inhospitals <- inhospitals.pre[t - 1] * R_t
    E_t <- inhospitals.pre[t - 1] * infectionrate

    infectionrate.pre <- c(infectionrate.pre, infectionrate)
    removedrate.pre <- c(removedrate.pre, removedrate)
    confirmed.pre <- c(confirmed.pre, E_t)
    inhospitals.pre <- c(inhospitals.pre, inhospitals)
  }

  Z.1 <- as.Date(ST) + t - 1

  # to predict the second zero point Z.2.
  while (inhospitals.pre[t] > 1 ) {
    t <- t + 1

    infectionrate <- infectionrate.pre[t - 1] * InfectionRateVelocity
    removedrate <- removedrate.pre[t - 1] * RemovedRateVelocity
    R_t <- 1 + infectionrate - removedrate
    inhospitals <- inhospitals.pre[t - 1] * R_t

    infectionrate.pre <- c(infectionrate.pre, infectionrate)
    removedrate.pre <- c(removedrate.pre, removedrate)
    inhospitals.pre <- c(inhospitals.pre, inhospitals)
  }

  Z.2 <- as.Date(ST) + t - 1

  # After prediction process, we can get the second turing point.
  # If T.2 have already gone, we stop predicting it.
  if (which.max(inhospitals.pre) > 1) {
    T.2 <- as.Date(ST) + which.max(inhospitals.pre) - 1
  }else {
    T.2 <- NA
  }

  prediction <- data.frame("removedrate.pre" = removedrate.pre,
                           "inhospitals.pre" = inhospitals.pre,
                           "T.2" = T.2,
                           "Z.1" = Z.1,
                           "Z.2" = Z.2)
  return(prediction)
}
