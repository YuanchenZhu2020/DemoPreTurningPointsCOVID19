
<!-- README.md is generated from README.Rmd. Please edit that file -->

DemoPreTurningPointsCOVID19
===========================

<!-- badges: start -->
<!-- badges: end -->

This R package aims to implementing the computational framework in the
paper *[Tracking and forecasting milepost moments of the epidemic in the
early outbreak framework and applications to the
COVID-19](https://www.medrxiv.org/content/10.1101/2020.03.21.20040139v1.full.pdf+html)*
based entirly on the [Vicky-Zh’s
work](https://github.com/Vicky-Zh/Tracking_and_forecasting_milepost_moments_of_COVID-19.git).

Installation
------------

You can install it as a binary package or source package.

Install from binary:

-   Download Binary File **DemoPreTurningPointsCOVID19\_1.0.0.zip **
    from
    <a href="https://github.com/YuanchenZhu2020/DemoPreTurningPointsCOVID19/releases/tag/Version_1.0.0" class="uri">https://github.com/YuanchenZhu2020/DemoPreTurningPointsCOVID19/releases/tag/Version_1.0.0</a>
-   Get the path of this binary file: `pkgfilepath`
-   Install packages in R: `install.packages(pkgfilepath, repos = NULL)`

Install from source code:

-   download and install **RTools**. (Mirrors:
    <a href="https://mirrors.tuna.tsinghua.edu.cn/CRAN/bin/windows/Rtools/" class="uri">https://mirrors.tuna.tsinghua.edu.cn/CRAN/bin/windows/Rtools/</a>)
-   install **devtools** in R `install.packages("devtools")`
-   install packages in R
    `devtools::install_github("YuanchenZhu2020/DemoPreTurningPointsCOVID19")`

<!-- -->

    # install as a binary package.
    # 1. download binary package to your PC
    # 2. get the path of package file
    install.packages(pkgfilepath, repos = NULL)

    # install as a source code package (requires RTools)
    # install.packages("devtools")
    devtools::install_github("YuanchenZhu2020/DemoPreTurningPointsCOVID19")

Usage
-----

Function List:

-   get\_indicators
-   calc\_velocity
-   get\_future\_indicators
-   corr\_removed\_rate
-   get\_milepost
-   prediction
-   period\_predict
-   prediction

Dataset List:

-   COVID19\_CN

If you want to see details of each function or dataset, use
`help(name)`. Or you can download the [referance
manual](https://github.com/YuanchenZhu2020/DemoPreTurningPointsCOVID19/releases/tag/Version_1.0.0).

Example
-------

    library(DemoPreTurningPointsCOVID19)
    # single begining time
    single_result <- prediction(COVID19_CN, M = 5, Beginning_Time = "2020-01-29")

    # multiple begining time
    period_result <- period_predict(COVID19_CN, M = 5, Beginning_Time = "2020-01-29", period = 32)
