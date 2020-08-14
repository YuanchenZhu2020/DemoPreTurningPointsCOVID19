#' Correct removed rate
#'
#' if future removed_rate is larger than 1, than correct T and M
#' to make removed_rate less than 1 and update the velocity.
#'
#' @param velocity A list contains 4 elements:
#' - infection_rate_velocity: the velocity of K.
#' - removed_rate_velocity: the velocity of I.
#' - corr.infection: vvector of corrected M_K and T_K.
#' - corr.removed: vector of corrected M_I and T_I.
#' @param indicators dataframe with variables:
#' - date: the exact day in the formate "%y-%m-%d" as a character
#' - confirmed: the daily confirmed cases at the given date
#' - recovered: the daily recovered cases at the given date
#' - deaths: the daily deaths at the given daten
#' - cum_confirmed: the cumulative confirmed cases
#' - active_cases: The number of infectious cases in hospital
#' - infection_rate: The daily infection rate
#' - removed_rate: the daily removed rate
#' @param pre_data dataframe with 4 predicted indicators:
#' - date: the exact day in the formate "%y-%m-%d" as a character
#' - infection_rate.pre: prediction result of infection rate
#' - removed_rate.pre: prediction result of removed_rate
#' - active_cases.pre: prediction result of active_cases
#' - confirmed.pre: prediction result of confirmed cases
#' All of these data is calculated from the Beginning_Time.
#' @param M the selection of time window.
#' @param Beginning_Time the selection of beginning time,
#' which must be in the formate "%y-%m-%d" as a character.
#'
#' @return A list contains 4 elements which go through the correction:
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
#' pre_data <- get_future_indicators(indicators, velocity, Beginning_Time)
#' new_velocity <- corr_removed_rate(velocity, indicators, pre_data, M, Beginning_Time)
corr_removed_rate <- function(velocity, indicators, pre_data, M, Beginning_Time) {
  removed_rate.pre <- pre_data$removed_rate.pre
  removed_rate <- indicators$removed_rate

  M_I <- as.numeric(velocity$corr.removed[1])
  T_I_ind <- as.numeric(velocity$corr.removed[2])
  removed_rate_velocity <- as.numeric(velocity$removed_rate_velocity)

  # This while loop is used to avoid predicted removed_rate > 1, which is counterintuitive.
  while (removed_rate.pre[length(removed_rate.pre)] > 1 & T_I_ind >= 1) {
    T_I_ind <- T_I_ind - 1
    while (removed_rate[T_I_ind - M_I + 1] >= removed_rate[T_I_ind]
           | removed_rate[T_I_ind - M_I + 1] == 0) {
      M_I <- M_I - 1
      if (M_I > 1) {
        next
      }
      else {
        T_I_ind <- T_I_ind - 1
        M_I <- M
        if(T_I_ind >= 0) {
          next
        }
        else {
          stop("The completion rate heaven't increase yet.")
        }
      }
    }
    # calculate new removed_rate_velocity
    removed_rate_velocity <- (removed_rate[T_I_ind] / removed_rate[T_I_ind - M_I + 1]) ^ (1 / (M_I - 1))
    # update velocity to calculate new future indicators
    velocity$removed_rate_velocity <- removed_rate_velocity
    velocity$corr.removed <- c(M_I, T_I_ind)
    pre_data_tmp <- DemoPreTurningPointsCOVID19::get_future_indicators(indicators, velocity, Beginning_Time)

    removed_rate.pre <- pre_data_tmp$removed_rate.pre
  }

  new_velocity <- list("infection_rate_velocity" = velocity$infection_rate_velocity,
                       "removed_rate_velocity" = removed_rate_velocity,
                       "corr.infection" = velocity$corr.infection,
                       "corr.removed" = c(M_I, T_I_ind))

  return(new_velocity)
}
