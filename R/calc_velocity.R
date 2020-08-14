#' Compute the velocity of K and I
#'
#' Compute the velocity of infection rate K change and completion rate I change.
#'
#' @param indicators dataframe that stores indicators calculate by get_indicators():
#' - date: the exact day in the formate "%y-%m-%d" as a character
#' - confirmed: the daily confirmed cases at the given date
#' - recovered: the daily recovered cases at the given date
#' - deaths: the daily deaths at the given daten
#' - cum_confirmed: the cumulative confirmed cases
#' - active_cases: The number of infectious cases in hospital
#' - infection_rate: The daily infection rate
#' - removed_rate: the daily removed rate
#' @param M the selection of time window.
#' @param Beginning_Time the selection of beginning time,
#' which must be in the formate "%y-%m-%d" as a character.
#'
#' @return A list contains 4 elements:
#' - infection_rate_velocity: the velocity of K.
#' - removed_rate_velocity: the velocity of I.
#' - corr.infection: vvector of corrected M_K and T_K.
#' - corr.removed: vector of corrected M_I and T_I.
#' These 2 corrected vector in the format of "c(T, M)" used to calculate
#' the above 2 indicators which may be needed in later calculation.
#' @export
#'
#' @examples Beginning_Time <- "2020-01-29"
#' M <- 5
#' indicators <- get_indicators(DemoPreTurningPointsCOVID19::COVID19_CN)
#' velocity <- calc_velocity(indicators, M, Beginning_Time)
calc_velocity <- function(indicators, M, Beginning_Time) {

  # to initialize the t and m for two corrections later
  # get the index of Beginning_Time in indicators$date storing in T_#_ind
  # store M in M_# for later corrections.
  T_K_ind <- which(indicators$date == Beginning_Time)
  T_I_ind <- T_K_ind
  M_K <- M
  M_I <- M

  # to calculate infection_rate_velocity
  # This while loop is a correction process for "m" and "t" in special situations,
  # in other words, this loop will be skipped in most cases.
  while (indicators$infection_rate[T_K_ind - M_K + 1] <= indicators$infection_rate[T_K_ind]
         | indicators$infection_rate[T_K_ind - M_K + 1] == 0) {
    # First, reduce time window M until M = 0
    # If M <= 1 and V_K < 1 is still not met,
    # recover M and move forward the Beginning_Time until it is less than 0.
    M_K <- M_K - 1
    if (M_K > 1) {
      next
    }
    else{
      T_K_ind <- T_K_ind - 1
      M_K <- M
      if(T_K_ind >= 0) {
        next
      }
      else {
        stop("The infection rate K heaven't decrease yet.")
      }
    }
  }
  # The formula for velocity calculation.
  infection_rate_velocity <- (indicators$infection_rate[T_K_ind] / indicators$infection_rate[T_K_ind - M_K + 1]) ^ (1 / (M_K - 1))


  # to calculate removed_rate_velocity
  # The meaning of this while loop is the same as above.
  while (indicators$removed_rate[T_I_ind - M_I + 1] >= indicators$removed_rate[T_I_ind]
         | indicators$removed_rate[T_I_ind - M_I + 1] == 0) {
    M_I <- M_I - 1
    if (M_I > 1) {
      next
    }
    else {
      T_I_ind <- T_I_ind - 1
      M_I <- M
      if (T_I_ind >= 0) {
        next
      }
      else {
        stop("The completion rate heaven't increase yet.")
      }
    }
  }
  # The formula for velocity calculation.
  removed_rate_velocity <- (indicators$removed_rate[T_I_ind] / indicators$removed_rate[T_I_ind - M_I + 1]) ^ (1 / (M_I - 1))

  # return velocity as a list and store the necesssary correction infomation
  velocity <- list("infection_rate_velocity" = infection_rate_velocity,
                   "removed_rate_velocity" = removed_rate_velocity,
                   "corr.infection" = c(M_K, T_K_ind),
                   "corr.removed" = c(M_I, T_I_ind))

  return(velocity)
}
