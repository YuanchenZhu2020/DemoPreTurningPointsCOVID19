#' Prediciton
#'
#' Integrate functions above, and handle a special situation (removedrate > 1).
#'
#' @param RawData dataframe with data and four ordered variables, i.e.
#' - the day t,
#' - the cumulative confirmed cases up to the given day t,
#' - the daily confirmed cases at day t,
#' - the daily recovered ones at day t,
#' - the daily deaths at day t.
#' @param M the selection of time window.
#' @param Begining_Time the selection of begining time,
#' which must be in the formate "%y-%m-%d" as a character.
#'
#' @return List contains important info. in the calculation:
#' - indicators: the iconic indicators generated from real data.
#' - Begining_Time: Hyper Param. the selection of begining time,
#' which must be in the formate "%y-%m-%d" as a character.
#' - M: Hyper Param. the selection of time window.
#' - velocity: A list contains 4 elements:
#'   * infection_rate_velocity: the velocity of K.
#'   * removed_rate_velocity: the velocity of I.
#'   * corr.infection: vvector of corrected M_K and T_K.
#'   * corr.removed: vector of corrected M_I and T_I.
#' - pre_indicators: dataframe with 4 future indicators:
#'   * date: the exact day in the formate "%y-%m-%d" as a character
#'   * infection_rate.pre: prediction result of infection rate
#'   * removed_rate.pre: prediction result of removed_rate
#'   * inhospitals.pre: prediction result of inhospitals
#'   * confirmed.pre: prediction result of confirmed cases
#' - mileposts: dataframe contains 4 milepost T.1, T.2, Z.1, Z.2,
#' which must be in the formate "%y-%m-%d" as a character.
#' @export
#'
#' @examples Begining_Time = "2020-01-29"
#' M <- 5
#' result <- prediction(COVID19_CN, M, Begining_Time)
prediction <- function(RawData, M, Begining_Time) {
  # Get indicators from raw data,
  # and then use indicators to calculate velocity.
  # After that, use indicators and velocity to generate future indicators.
  indicators <- DemoPreTurningPointsCOVID19::get_indicators(RawData)
  velocity <- DemoPreTurningPointsCOVID19::calc_velocity(indicators, M, Begining_Time)
  pre_data <- DemoPreTurningPointsCOVID19::get_future_indicators(indicators, velocity, Begining_Time)

  # correct M_I and T_I to avoid removed_rate > 1, which is counterintuitive.
  new_velocity <- DemoPreTurningPointsCOVID19::corr_removed_rate(velocity, indicators, pre_data, M, Begining_Time)

  # if it has gone through correction process, then reproduce the future indicators.
  if (new_velocity$corr.removed[1] != velocity$corr.removed[1]
      | new_velocity$corr.removed[2] != velocity$corr.removed[2]) {
    pre_data <- DemoPreTurningPointsCOVID19::get_future_indicators(indicators, new_velocity, Begining_Time)
  }

  # use future indicators to calculate 4 milepost moments.
  mileposts <- get_milepost(pre_data, Begining_Time = Begining_Time)

  # return result which contains all import information in the calculation.
  result <- list("indicators" = indicators,
                 "Begining_Time" = Begining_Time,
                 "M" = M,
                 "velocity" = new_velocity,
                 "pre_indicators" = pre_data,
                 "mileposts" = mileposts)

  return(result)
}
