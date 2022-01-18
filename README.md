
<!-- README.md is generated from README.Rmd. Please edit that file -->

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

#|
#|          /
#|         /
#| -------/
#|______________
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

#|    
#|   /-------
#|  /
#| /
#|______________
knee <- kneedle(c(1,2,3,4,5), c(0,20,40,41,42), concave = FALSE, decreasing = FALSE)

#|
#| -------\
#|         \
#|          \
#|______________
knee <- kneedle(c(1,2,3,4,5), c(100,99,98,50,0), concave = FALSE, decreasing = TRUE)
```

## Sensitivity

This describes how the sensitivity parameter affects the output.

``` r
library(kneedle)
# Sensitivity defaults to 1 as per the referenced paper. However, you can adjust 
# it. A higher sensitivity make the rules more 'stringent' in classifying a 
# 'candidate knee' point as a knee. 
#|
#|          /
#|         /
#| -------/
#|______________
knee <- kneedle(c(1,2,3,4,5), c(0,1,2,40,60), sensitivity = 1)
print(knee)
#> [1] 3 2

# In this case, we see that that (3,2) is no longer considered a knee point. No
# other knees were detected.
#|
#|          /
#|         /
#| -------/
#|______________
knee <- kneedle(c(1,2,3,4,5), c(0,1,2,40,60), sensitivity = 2)
print(knee)
#> numeric(0)
```
