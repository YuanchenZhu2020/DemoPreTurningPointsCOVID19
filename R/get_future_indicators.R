#' Predict future indicators
#'
#' Predict future infection_rate, removed_rate, inhospitals and confirmed cases.
#'
#' @param indicators dataframe that stores indicators calculate by get_indicators():
#' - date: the exact day in the formate "%y-%m-%d" as a character
#' - confirmed: the daily confirmed cases at the given date
#' - recovered: the daily recovered cases at the given date
#' - deaths: the daily deaths at the given daten
#' - cum_confirmed: the cumulative confirmed cases
#' - inhospitals: The number of infectious cases in hospital
#' - infection_rate: The daily infection rate
#' - removed_rate: the daily removed rate
#' @param velocity A list contains infection_rate_velocity, removed_rate_velocity,
#' and 2 corrected vector c(T, M) used to calculate the above 2 indicators
#' which may be needed in later calculation.
#' @param Begining_Time the selection of begining time,
#' which must be in the formate "%y-%m-%d" as a character.
#'
#' @return dataframe with 4 predicted indicators:
#' - date: the exact day in the formate "%y-%m-%d" as a character
#' - infection_rate.pre: prediction result of infection rate
#' - removed_rate.pre: prediction result of removed_rate
#' - inhospitals.pre: prediction result of inhospitals
#' - confirmed.pre: prediction result of confirmed cases
#' All of these data is calculated from the Begining_Time.
#' @export
#'
#' @examples Begining_Time <- "2020-01-29"
#' M <- 5
#' indicators <- get_indicators(DemoPreTurningPointsCOVID19::COVID19_CN)
#' velocity <- calc_velocity(indicators, M, Begining_Time)
#' pre_data <- get_future_indicators(indicators, velocity, Begining_Time)
get_future_indicators <- function(indicators, velocity, Begining_Time) {
  # get the index of Begining_Time in indicators$date storing in T_ind
  T_ind <- which(indicators$date == Begining_Time)

  # get the predicited values of 4 indicators of Begining_Time
  date.0 <- indicators$date[T_ind]
  infection_rate.0 <- indicators$infection_rate[T_ind]
  removed_rate.0 <- indicators$removed_rate[T_ind]
  inhospitals.0 <- indicators$inhospitals[T_ind]
  confirmed.0 <- indicators$confirmed[T_ind]

  date.pre <- c(date.0)
  infection_rate.pre <- c(infection_rate.0)
  removed_rate.pre <- c(removed_rate.0)
  inhospitals.pre <- c(inhospitals.0)
  confirmed.pre <- c(confirmed.0)

  t <- 1

  # get the pridicted values of 5 indicators
  while (inhospitals.pre[t] > 1) {
    t <- t + 1

    date <- as.Date(date.pre[t - 1]) + 1
    K_t_pre <- infection_rate.pre[t - 1] * velocity$infection_rate_velocity
    I_t_pre <- removed_rate.pre[t - 1] * velocity$removed_rate_velocity
    R_t_pre <- 1 + K_t_pre - I_t_pre
    N_t_pre <- inhospitals.pre[t - 1] * R_t_pre
    E_t_pre <- inhospitals.pre[t - 1] * K_t_pre

    date.pre <- c(date.pre, date)
    infection_rate.pre <- c(infection_rate.pre, K_t_pre)
    removed_rate.pre <- c(removed_rate.pre, I_t_pre)
    inhospitals.pre <- c(inhospitals.pre, N_t_pre)
    confirmed.pre <- c(confirmed.pre, E_t_pre)
  }

  pre_data <- data.frame("date" = date.pre,
                         "infection_rate.pre" = infection_rate.pre,
                         "removed_rate.pre" = removed_rate.pre,
                         "inhospitals.pre" = inhospitals.pre,
                         "confirmed.pre" = confirmed.pre)

  return(pre_data)
}
