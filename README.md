
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pkgdown <img src="man/figures/logo.png" align="right" alt="" width="120" />

<!-- badges: start -->

<a href="https://cran.r-project.org/package=pkgdown" class="pkgdown-release"><img src="https://www.r-pkg.org/badges/version/pkgdown" alt="CRAN Status" /></a>
<a href="https://github.com/r-lib/pkgdown/actions" class="pkgdown-devel"><img src="https://github.com/r-lib/pkgdown/workflows/R-CMD-check/badge.svg" alt="R-CMD-check" /></a>
[![Codecov test
coverage](https://codecov.io/gh/r-lib/pkgdown/branch/main/graph/badge.svg)](https://app.codecov.io/gh/r-lib/pkgdown?branch=main)
<!-- badges: end -->

# kneedle

<!-- badges: start -->
<!-- badges: end -->

The goal of kneedle is to provide an easy to use implementation of the
kneedle algorithm developed at
<https://raghavan.usc.edu/papers/kneedle-simplex11.pdf>. The main
functionality is to detect an inflection point, more commonly associated
in continuous function, in discrete datasets.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
install.packages("devtools")
devtools::install_github("etam4260/kneedle")
```

## Example

This is a basic example:

``` r
library(kneedle)
#> Registered S3 method overwritten by 'quantmod':
#>   method            from
#>   as.zoo.data.frame zoo

# The base function assumes the graph is both concave and increasing.
# First and second inputs must be vectors of integers or doubles.

plot(c(1,2,3,4,5,6), c(0,1,2,3,40,100), xlab = "x", ylab = "y", pch=21, col="blue", bg="lightblue", type = "b")
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r
knee <- kneedle(c(1,2,3,4,5,6), c(0,1,2,3,40,100))
print(knee)
#> [1] 4 3
```

## Parameters

This describes a few of the parameters that can be changed.

``` r
library(kneedle)
#Concavity parameter must be changed if the graph is convex. Furthermore, you 
#must specify if the y is increasing or decreasing as x increases. 

plot(c(1,2,3,4,5), c(0,20,40,41,42), xlab = "x", ylab = "y", pch=21, col="blue", bg="lightblue", type = "b")
```

<img src="man/figures/README-parameters-1.png" width="100%" />

``` r
knee <- kneedle(c(1,2,3,4,5), c(0,20,40,41,42), concave = FALSE, decreasing = FALSE)
print(knee)
#> [1]  3 40


plot(c(1,2,3,4,5), c(100,99,98,50,0), xlab = "x", ylab = "y", pch=21, col="blue", bg="lightblue", type = "b")
```

<img src="man/figures/README-parameters-2.png" width="100%" />

``` r
knee <- kneedle(c(1,2,3,4,5), c(100,99,98,50,0), concave = FALSE, decreasing = TRUE)
print(knee)
#> [1]  3 98
```

## Sensitivity

This describes how the sensitivity parameter affects the output.

``` r
library(kneedle)
# Sensitivity defaults to 1 as per the referenced paper. However, you can adjust 
# it. A higher sensitivity make the rules more 'stringent' in classifying a 
# 'candidate knee' point as a knee. 

plot(c(1,2,3,4,5), c(0,1,2,40,60), xlab = "x", ylab = "y", pch=21, col="blue", bg="lightblue", type = "b")
knee <- kneedle(c(1,2,3,4,5), c(0,1,2,40,60), sensitivity = 1)
print(knee)
#> [1] 3 2

# In this case with sensitivity = 2, we see that that (3,2) is no longer considered a knee point. No
# other knees were detected.

plot(c(1,2,3,4,5), c(0,1,2,40,60), xlab = "x", ylab = "y", pch=21, col="blue", bg="lightblue", type = "b")
```

<img src="man/figures/README-sensitivity-1.png" width="100%" />

``` r
knee <- kneedle(c(1,2,3,4,5), c(0,1,2,40,60), sensitivity = 2)
print(knee)
#> numeric(0)
```
