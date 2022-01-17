source("../R/kneedle.R", chdir = TRUE)
library(testthat)


# Testing y increasing as x increasing: data is concave
#|
#|          /
#|         /
#| -------/
#|______________
test_that("increasing.concave", {
  expect_equal(kneedle(c(1,2,3,4,5), c(0,1,2,40,60)), c(3,2))
})

# Testing y increasing as x increasing: data is convex
#|    
#|   /-------
#|  /
#| /
#|______________
test_that("increasing.convex", {
  expect_equal(kneedle(c(1,2,3,4,5), c(0,20,40,41,42), concave = FALSE, decreasing = FALSE), c(3,40))
})


# Testing y decreasing as x increasing: data is convex
#|
#| -------\
#|         \
#|          \
#|______________
test_that("decreasing.convex", {
  expect_equal(kneedle(c(1,2,3,4,5), c(100,99,98,50,0), concave = FALSE, decreasing = TRUE), c(3,98))
})

# Testing y decreasing as x increasing : data is concave 
#|
#| \
#|  \
#|   \
#|    -------
#|_____________
test_that("decreasing.concave", {
  expect_equal(kneedle(c(1,2,3,4,5), c(100,50,10,5,0), concave = TRUE, decreasing = TRUE), c(3,10))
})



