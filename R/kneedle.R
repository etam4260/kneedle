library(quantmod)

# Applies the kneedle algorithm developed by:
# https://raghavan.usc.edu/papers/kneedle-simplex11.pdf
# Finding a "Kneedle" in a Haystack:
# Detecting Knee Points in System Behavior
# Currently this function only works for monotonically increasing x starting at
# 0
# x <- a list for the x input
# y <- a list for the y input
# decreasing <- determine if data is decreasing or increasing
# sensitivity <- sensitivity for when to stop considering other potential
# knee point candidates



#' Kneedle
#'
#' This function allows you to find the knee of a graph
#' @param x
#' @param y 
#' @param decreasing
#' @param sensitivity
#' @param concave
#' @keywords knee
#' @export 
#' @examples
#' kneedle()

kneedle <- function(x, y, decreasing, sensitivity, concave) {
  if(decreasing) {
    y <- as.list(sort(unlist(y), decreasing = TRUE))
  } else {
    y <- as.list(sort(unlist(y), decreasing = FALSE))
  }
  
  data <- matrix(unlist(list(x, y)), ncol = 2)
  data[ ,1] <- (data[, 1])/max(data[ ,1])
  data[ ,2] <- (data[, 2])/max(data[ ,2])
  
  plot(data)
  
  if(concave && !decreasing) {
    differ <- abs(c(data[ ,2] - data[ ,1]))
  } else if(concave && decreasing) {
    differ <- abs(c(data[ ,2] - data[ ,1]))
  } else if(!concave && !decreasing) {
    differ <- abs(c(data[ ,2] - (1 - data[ ,1])))
  } else if(!concave && decreasing) {
    differ <- abs(c(data[ ,2] - (1 - data[ ,1])))
  }
  plot(differ)
  peak.indices <- findPeaks(differ) - 1  
  
  data <- cbind(data, differ)
  diffofdiffer <- append(diff(data[, 3]), 0)
  data <-cbind(data, diffofdiffer)
  
  T.lm.x.s <- sensitivity * mean(data[,4])
  knee = NULL
  for(i in 1:length(peak.indices)) {
    for(j in peak.indices[i]:if(i+1 < length(peak.indices)) peak.indices[i+1] else i) {
      T <- differ[i] - sensitivity * (T.lm.x.s)
      
      if(diffofdiffer[j] < T) {
        knee = peak.indices[i];
        break;
      } 
    }
    if(!is.null(knee)) {
      break;
    }
  }
  
  return(data[knee, 1])
}