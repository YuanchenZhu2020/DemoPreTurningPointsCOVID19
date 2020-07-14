
# DemoPreTurningPointsCOVID19

<!-- badges: start -->
<!-- badges: end -->

This R package aims to implementing the computational framework in the paper *[Tracking and forecasting milepost moments of the epidemic in the early outbreak framework and applications to the COVID-19](https://www.medrxiv.org/content/10.1101/2020.03.21.20040139v1.full.pdf+html)* based entirly on the [Vicky-Zh's work](https://github.com/Vicky-Zh/Tracking_and_forecasting_milepost_moments_of_COVID-19.git).

## Installation

You can install it as a source code package or binary package.


``` r
# install as a source code package (requires RTools)
# install.packages("devtools")
devtools::install_github("YuanchenZhu2020/DemoPreTurningPointsCOVID19")

# install as a binary package.
# 1. download binary package to your PC
# 2. get the path of package file
install.packages(pkgfilepath, repos = NULL, type = "win.binary")
```

## Example

Put example file *Data of China Mainland Beyond Hubei.csv* to the working dictionary and run the code.

``` r
library(DemoPreTurningPointsCOVID19)
result <- PeriodForcast("./Data of China Mainland Beyond Hubei.csv", M = 5, ST = "2020-01-29", period = 32)
```
