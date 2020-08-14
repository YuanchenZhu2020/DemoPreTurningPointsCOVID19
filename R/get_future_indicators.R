#' Get future indicators
#'
#' Get future infection_rate, removed_rate, active_cases and confirmed cases.
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
#' @param velocity A list contains infection_rate_velocity, removed_rate_velocity,
#' and 2 corrected vector c(T, M) used to calculate the above 2 indicators
#' which may be needed in later calculation.
#' @param Beginning_Time the selection of beginning time,
#' which must be in the formate "%y-%m-%d" as a character.
#'
#' @return dataframe with 4 predicted indicators:
#' - date: the exact day in the formate "%y-%m-%d" as a character
#' - infection_rate.pre: prediction result of infection rate
#' - removed_rate.pre: prediction result of removed_rate
#' - active_cases.pre: prediction result of active_cases
#' - confirmed.pre: prediction result of confirmed cases
#' All of these data is calculated from the Beginning_Time.
#' @export
#'
#' @examples Beginning_Time <- "2020-01-29"
#' M <- 5
#' indicators <- get_indicators(DemoPreTurningPointsCOVID19::COVID19_CN)
#' velocity <- calc_velocity(indicators, M, Beginning_Time)
#' pre_data <- get_future_indicators(indicators, velocity, Beginning_Time)
get_future_indicators <- function(indicators, velocity, Beginning_Time) {
  # get the index of Beginning_Time in indicators$date storing in T_ind
  T_ind <- which(indicators$date == Beginning_Time)

  # get the predicited values of 4 indicators of Beginning_Time
  date.0 <- indicators$date[T_ind]
  infection_rate.0 <- indicators$infection_rate[T_ind]
  removed_rate.0 <- indicators$removed_rate[T_ind]
  active_cases.0 <- indicators$active_cases[T_ind]
  confirmed.0 <- indicators$confirmed[T_ind]

  date.pre <- c(date.0)
  infection_rate.pre <- c(infection_rate.0)
  removed_rate.pre <- c(removed_rate.0)
  active_cases.pre <- c(active_cases.0)
  confirmed.pre <- c(confirmed.0)

  t <- 1

  # get the pridicted values of 5 indicators
  while (active_cases.pre[t] > 1) {
    t <- t + 1

    date <- as.Date(date.pre[t - 1]) + 1
    K_t_pre <- infection_rate.pre[t - 1] * velocity$infection_rate_velocity
    I_t_pre <- removed_rate.pre[t - 1] * velocity$removed_rate_velocity
    R_t_pre <- 1 + K_t_pre - I_t_pre
    N_t_pre <- active_cases.pre[t - 1] * R_t_pre
    E_t_pre <- active_cases.pre[t - 1] * K_t_pre

    date.pre <- c(date.pre, date)
    infection_rate.pre <- c(infection_rate.pre, K_t_pre)
    removed_rate.pre <- c(removed_rate.pre, I_t_pre)
    active_cases.pre <- c(active_cases.pre, N_t_pre)
    confirmed.pre <- c(confirmed.pre, E_t_pre)
  }

  pre_data <- data.frame("date" = date.pre,
                         "infection_rate.pre" = infection_rate.pre,
                         "removed_rate.pre" = removed_rate.pre,
                         "active_cases.pre" = active_cases.pre,
                         "confirmed.pre" = confirmed.pre)

  return(pre_data)
}
