library(quantmod)
#' @import quantmod


# Applies the kneedle algorithm developed by:
# https://raghavan.usc.edu/papers/kneedle-simplex11.pdf
# Finding a "Kneedle" in a Haystack:
# Detecting Knee Points in System Behavior

# x <- a list for the x input
# y <- a list for the y input
# decreasing <- determine if data is decreasing or increasing
# sensitivity <- sensitivity for when to stop considering other potential
# knee point candidates



#' Kneedle
#' @name kneedle
#' @title kneedle
#' This function allows you to find the knee of a graph
#' @param x list list of x coordinates.
#' @param y list list of y coordinates.
#' @param decreasing boolean is the function increasing? Defaults to FALSE.
#' @param sensitivity integer how sensitive should knee detection be? Defaults to 1. Can be a float/double.
#' @param concave boolean is this concave or convex? Defaults to TRUE.
#' @keywords knee
#' @export
#' @returns a x,y coordinate pair
#' kneedle()

kneedle <- function(x, y, decreasing = FALSE, sensitivity = 1, concave = TRUE) {
  # Make sure inputs are correct
  if(length(x) == 0 || length(y) == 0) {
    stop("Make sure size of both inputs x and y are greater than 0")
  }
  if(typeof(x) == "list"|| typeof(y) == "list" || is.data.frame(x) || 
     is.data.frame(y) || is.array(x) || is.array(y) || is.matrix(x) || is.matrix(y)) {
    stop("Make sure both inputs x and y are vectors")
  }
  if(length(x) != length(y)) {
    stop("Make sure size of both inputs x and y are equal")
  }
  
  data <- matrix(unlist(list(x, y)), ncol = 2)
  data <- data[order(data[,1], decreasing = FALSE), ]
  maxy <- max(y)
  miny <- min(y)
  maxx <- max(x)
  minx <- min(x)
  data[ ,1] <- (data[, 1]- min(data[, 1]))/(max(data[ ,1])-min(data[, 1]))
  data[ ,2] <- (data[, 2]- min(data[, 2]))/(max(data[ ,2])- min(data[, 2]))

  if(concave && !decreasing) {
    differ <- abs(c(data[ ,2] - data[ ,1]))
  } else if(concave && decreasing) {
    differ <- abs(c(data[ ,2] - (1 - data[ ,1])))
  } else if(!concave && !decreasing) {
    differ <- abs(c(data[ ,2] - data[ ,1]))
  } else if(!concave && decreasing) {
    differ <- abs(c(data[ ,2] - (1 - data[ ,1])))
  }
  

  peak.indices <- findPeaks(differ) - 1

  data <- cbind(data, differ)

  diffx = diff(data[, 1])

  T.lm.x.s <- sensitivity * mean(diffx)
  knee = NULL
  
  for(i in 1:length(peak.indices)) {
    T <- data[peak.indices[i] ,3] - (T.lm.x.s)

    y.value <- data[peak.indices[i] ,3]
  
    for(j in (peak.indices[i]):if(i+1 < length(peak.indices)) peak.indices[i+1] else length(differ)) {
      if(differ[j] < T) {
        knee = peak.indices[i];
        break;
      }
    }
    if(!is.null(knee)) {
      break;
    }
  }

  # Returns the x,y coordinate values
  x <- ((maxx - minx) * (data[knee, 1])) + minx
  y <- ((maxy - miny) * (data[knee, 2])) + miny
  
  return(c(x,y))
}
