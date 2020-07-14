
<!-- README.md is generated from README.Rmd. Please edit that file -->

# DemoPreTurningPointsCOVID19

<!-- badges: start -->

<!-- badges: end -->

This R package aims to implementing the computational framework in the
paper *[Tracking and forecasting milepost moments of the epidemic in the
early outbreak framework and applications to the
COVID-19](https://www.medrxiv.org/content/10.1101/2020.03.21.20040139v1.full.pdf+html)*
based entirly on the [Vicky-Zh’s
work](https://github.com/Vicky-Zh/Tracking_and_forecasting_milepost_moments_of_COVID-19.git).

## Installation

You can install it as a source code package or binary package.

Install from source code:

  - download and install RTools:
    <https://mirrors.tuna.tsinghua.edu.cn/CRAN/bin/windows/Rtools/>
  - install devtools in R `install.packages("devtools")`
  - install packages in R
    `devtools::install_github("YuanchenZhu2020/DemoPreTurningPointsCOVID19")`

Install from binary file:

  - Download Binary File :
    <https://bhpan.buaa.edu.cn:443/link/DB80C0730C36DA9384524893CD143796>
  - Get the path of this binary file `pkgfilepath`
  - Install packages in R `install.packages(pkgfilepath, repos = NULL,
    type = "win.binary")`

<!-- end list -->

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

Put example file *Data of China Mainland Beyond Hubei.csv* to the
working dictionary and run the code:

``` r
library(DemoPreTurningPointsCOVID19)
datafilepath <-"../Data of China Mainland Beyond Hubei.csv"
result <- PeriodForcast(datafilepath, M = 5, ST = "2020-01-29", period = 32)
#> [1] 1
#> [1] "2020-01-29"
#> [1] 2
#> [1] "2020-01-30"
#> [1] 3
#> [1] "2020-01-31"
#> [1] 4
#> [1] "2020-02-01"
#> [1] 5
#> [1] "2020-02-02"
#> [1] 6
#> [1] "2020-02-03"
#> [1] 7
#> [1] "2020-02-04"
#> [1] 8
#> [1] "2020-02-05"
#> [1] 9
#> [1] "2020-02-06"
#> [1] 10
#> [1] "2020-02-07"
#> [1] 11
#> [1] "2020-02-08"
#> [1] 12
#> [1] "2020-02-09"
#> [1] 13
#> [1] "2020-02-10"
#> [1] 14
#> [1] "2020-02-11"
#> [1] 15
#> [1] "2020-02-12"
#> [1] 16
#> [1] "2020-02-13"
#> [1] 17
#> [1] "2020-02-14"
#> [1] 18
#> [1] "2020-02-15"
#> [1] 19
#> [1] "2020-02-16"
#> [1] 20
#> [1] "2020-02-17"
#> [1] 21
#> [1] "2020-02-18"
#> [1] 22
#> [1] "2020-02-19"
#> [1] 23
#> [1] "2020-02-20"
#> [1] 24
#> [1] "2020-02-21"
#> [1] 25
#> [1] "2020-02-22"
#> [1] 26
#> [1] "2020-02-23"
#> [1] 27
#> [1] "2020-02-24"
#> [1] 28
#> [1] "2020-02-25"
#> [1] 29
#> [1] "2020-02-26"
#> [1] 30
#> [1] "2020-02-27"
#> [1] 31
#> [1] "2020-02-28"
#> [1] 32
#> [1] "2020-02-29"
result
#>    BeginingTime        T.2        Z.1        Z.2
#> 1    2020-01-29 2020-02-14 2020-03-07 2020-05-11
#> 2    2020-01-30 2020-02-17 2020-03-19 2020-04-19
#> 3    2020-01-31 2020-02-14 2020-03-10 2020-03-23
#> 4    2020-02-01 2020-02-11 2020-03-03 2020-04-08
#> 5    2020-02-02 2020-02-11 2020-03-06 2020-04-01
#> 6    2020-02-03 2020-02-17 2020-03-17 2020-03-30
#> 7    2020-02-04 2020-02-11 2020-03-07 2020-03-21
#> 8    2020-02-05 2020-02-13 2020-03-12 2020-03-22
#> 9    2020-02-06 2020-02-12 2020-03-10 2020-03-20
#> 10   2020-02-07 2020-02-10 2020-03-02 2020-03-20
#> 11   2020-02-08 2020-02-10 2020-03-01 2020-03-06
#> 12   2020-02-09 2020-02-10 2020-03-02 2020-03-10
#> 13   2020-02-10       <NA> 2020-03-05 2020-04-01
#> 14   2020-02-11       <NA> 2020-03-08 2020-03-17
#> 15   2020-02-12       <NA> 2020-03-09 2020-03-25
#> 16   2020-02-13       <NA> 2020-03-07 2020-03-18
#> 17   2020-02-14       <NA> 2020-03-03 2020-03-09
#> 18   2020-02-15       <NA> 2020-03-02 2020-03-13
#> 19   2020-02-16       <NA> 2020-03-03 2020-03-31
#> 20   2020-02-17       <NA> 2020-02-29 2020-03-17
#> 21   2020-02-18       <NA> 2020-02-28 2020-03-15
#> 22   2020-02-19       <NA> 2020-02-28 2020-03-12
#> 23   2020-02-20       <NA> 2020-03-03 2020-03-11
#> 24   2020-02-21       <NA> 2020-03-02 2020-03-09
#> 25   2020-02-22       <NA> 2020-03-03 2020-03-30
#> 26   2020-02-23       <NA> 2020-03-02 2020-04-07
#> 27   2020-02-24       <NA> 2020-02-27 2020-03-25
#> 28   2020-02-25       <NA> 2020-02-29 2020-03-10
#> 29   2020-02-26       <NA> 2020-03-04 2020-03-18
#> 30   2020-02-27       <NA> 2020-03-01 2020-03-10
#> 31   2020-02-28       <NA> 2020-03-05 2020-04-06
#> 32   2020-02-29       <NA> 2020-03-07 2020-03-18
```

## Usage

FUnction List:

  - Iconicfun
  - CalculateVelocity
  - Prediction
  - totalPrediction
  - PeriodForcast

If you want to see the detailed doc, use `help(funcname)` for help.
