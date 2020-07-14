#' Compute the velocity of K and I
#'
#' Compute the velocity of infection rate K change and completion rate I change.
#'
#' @param date the exact day in the formate "%y-%m-%d" as a character
#' @param confirmed the daily confirmed cases at the given date
#' @param inhospitals The number of infectious cases in hospital
#' @param infectionrate The daily infection rate
#' @param removedrate the daily removed rate
#' @param M the selection of time window.
#' @param ST the selection of begining time,
#' which must be in the formate "%y-%m-%d" as a character.
#'
#' @return A list contains InfectionRateVelocity, RemovedRateVelocity,
#' and the final ST.removed and M.removed used to calculate RemovedRateVelocity,
#' which may be needed in later calculation.
#' @export
#'
#' @examples
CalculateVelocity <- function (date, confirmed, inhospitals, infectionrate, removedrate, M, ST) {
  f <- data.frame(date = date,
                  confirmed = confirmed,
                  inhospitals = inhospitals,
                  infectionrate = infectionrate,
                  removedrate = removedrate)
  f$date <- as.Date(f$date)

  # to initialize the st and m for real calculation
  ST.infection <- which(f$date == ST)
  ST.removed <- which(f$date == ST)
  M.infection <- M
  M.removed <- M

  infectionrate.0 <- f$infectionrate[ST.infection]
  removedrate.0 <- f$removedrate[ST.infection]
  confirmed.0 <- f$confirmed[ST.infection]
  inhospitals.0 <- f$inhospitals[ST.infection]

  # to calculate InfectionRateVelocity
  # This while loop is a correction process for "m" and "st" in special situations,
  # in other words, this loop will be skipped in most cases.
  while (f$infectionrate[ST.infection - M.infection + 1] <= f$infectionrate[ST.infection]
         | f$infectionrate[ST.infection - M.infection + 1] == 0) {
    M.infection <- M.infection - 1
    if (M.infection > 1) next
    else {
      ST.infection <- ST.infection - 1
      M.infection <- M
      if(ST.infection >= 0) next
      else {
        stop("The infection rate K heaven't decrease yet.")
      }
    }
  }

  # The formula for velocity calculation.
  InfectionRateVelocity <- (f$infectionrate[ST.infection] / f$infectionrate[ST.infection - M.infection + 1]) ^ (1 / (M.infection - 1))

  # to calculate RemovedRateVelocity
  # The meaning of this while loop is the same as above.
  while (f$removedrate[ST.removed - M.removed + 1] >= f$removedrate[ST.removed]
         | f$removedrate[ST.removed - M.removed + 1] == 0) {
    M.removed <- M.removed - 1
    if (M.removed > 1) next
    else {
      ST.removed <- ST.removed - 1
      M.removed <- M
      if (ST.removed >= 0) next
      else {
        stop("The completion rate heaven't increase yet.")
      }
    }
  }

  # The formula for velocity calculation.
  RemovedRateVelocity <- (f$removedrate[ST.removed] / f$removedrate[ST.removed - M.removed + 1]) ^ (1 / (M.removed - 1))

  velocity <- list("InfectionRateVelocity" = InfectionRateVelocity,
                   "RemovedRateVelocity" = RemovedRateVelocity,
                   "ST.removed" = ST.removed,
                   "M.removed" = M.removed,
                   "ST" = ST)
  return(velocity)
}
