# kneedle
Implementation of the kneedle algorithm in R.
https://raghavan.usc.edu/papers/kneedle-simplex11.pdf

https://github.com/etam4260/kneedle

This package can be downloaded using:

library("devtools")
install_github("etam4260/kneedle")

library("kneedle")

knee <- kneedle(c(1,2,3,4,5,6), c(0,1,2,3,40,100))

Returns a (x,y) pair in vector form. For this example it should output (4,3).



THIS IS CURRENTLY A WORK IN PROGRESS. It might be buggy or not provide
the right outputs. 


A webapp developed by those who create the kneedle
algorithm in python can be found here:
https://ikneed.herokuapp.com/