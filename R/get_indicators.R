#' Compute the iconic indicators
#'
#' Compute the iconic indicators and return as dataframe
#'
#' @param RawData dataframe with data and 5 ordered variables, i.e.
#' - the day t,
#' - the cumulative confirmed cases up to the given day t,
#' - the daily confirmed cases at day t,
#' - the daily recovered ones at day t,
#' - the daily deaths at day t.
#'
#' @return dataframe with variables:
#' - date: the exact day in the formate "%y-%m-%d" as a character
#' - confirmed: the daily confirmed cases at the given date
#' - recovered: the daily recovered cases at the given date
#' - deaths: the daily deaths at the given daten
#' - cum_confirmed: the cumulative confirmed cases
#' - active_cases: The number of infectious cases in hospital
#' - infection_rate: The daily infection rate
#' - removed_rate: the daily removed rate
#' @export
#'
#' @examples indicators <- get_indicators(DemoPreTurningPointsCOVID19::COVID19_CN)
get_indicators <- function(RawData) {
  # Get the number of records
  nlines <- dim(RawData)[1]

  date <- as.Date(RawData[,1])
  # cumulative confirmed cases
  cum_confirmed <- RawData[,2]
  confirmed <- RawData[,3]
  recovered <- RawData[,4]
  deaths <- RawData[,5]

  # active_cases, the daily infection rate, the daily removed rate
  active_cases <- cum_confirmed - cumsum(recovered + deaths)
  infection_rate <- confirmed[-1] / active_cases[-nlines]
  removed_rate <- (recovered + deaths)[-1] / active_cases[-nlines]

  # return results
  # Incremental data, the length of line is (nlines - 1)
  result <- data.frame(date = date[-1],
                       cum_confirmed = cum_confirmed[-1],
                       confirmed = confirmed[-1],
                       recovered = recovered[-1],
                       deaths = deaths[-1],
                       active_cases = active_cases[-1],
                       infection_rate = infection_rate,
                       removed_rate = removed_rate)

  return(result)
}
