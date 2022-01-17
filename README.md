
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kneedle

<!-- badges: start -->
<!-- badges: end -->

The goal of kneedle is to provide an easy to use implementation of the
kneedle algorithm developed at
<https://raghavan.usc.edu/papers/kneedle-simplex11.pdf>. The main
functionality is to detect inflection points, more commonly associated
in continuous function, in discrete datasets.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("etam4260/kneedle")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(kneedle)
#> Registered S3 method overwritten by 'quantmod':
#>   method            from
#>   as.zoo.data.frame zoo
knee <- kneedle(c(1,2,3,4,5,6), c(0,1,2,3,40,100))
print(knee)
#> [1] 4 3
```
