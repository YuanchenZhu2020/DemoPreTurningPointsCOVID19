#' Compute the iconic indicators
#'
#' Compute the iconic indicators
#'
#' @param wd dataframe with data and four variables, i.e.
#' the cumulative confirmed cases up to the given day t,
#' the daily confirmed cases at day t,
#' the daily recovered ones and the daily deaths at day t，
#'
#' @return dataframe with variables
#' date: the exact day in the formate "%y-%m-%d" as a character
#' confirmed: the daily confirmed cases at the given date
#' recovered: the daily recovered cases at the given date
#' deaths: the daily deaths at the given date
#' cumconfirmed: the cumulative confirmed cases
#' inhospitals: The number of infectious cases in hospital
#' infectionrate: The daily infection rate
#' removedrate: the daily removed rate
#' @export
#'
#' @examples
Iconicfun <- function(wd) {
  n <- dim(wd)[1]
  date <- as.Date(wd[,1])
  cumconfirmed <- wd[,2] # cumulative confirmed cases
  confirmed <- wd[,3]
  recovered <- wd[,4]
  deaths <- wd[,5]

  inhospitals <- cumconfirmed - cumsum(recovered + deaths) # in-hospitals
  infectionrate <- confirmed[-1] / inhospitals[-n] # the daily infection rate
  removedrate <- (recovered + deaths)[-1] / inhospitals[-n] # the daily removed rate

  # return results
  result <- data.frame(date = date[-1],
                       cumconfirmed = cumconfirmed[-1],
                       confirmed = confirmed[-1],
                       recovered = recovered[-1],
                       deaths = deaths[-1],
                       inhospitals = inhospitals[-1],
                       infectionrate = infectionrate,
                       removedrate = removedrate)
  return(result)
}
