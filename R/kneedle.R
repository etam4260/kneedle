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



#' kneedle
#' @name kneedle
#' @title kneedle
#' This function allows you to find the knee of a graph
#' @param x A vector of x coordinates.
#' @param y A vector of y coordinates.
#' @param decreasing Is the function increasing? Algorithm will take a guess at direction of data if not specified.
#' @param concave Is this concave or convex? Algorithm will take a guess at concavity if not specified.
#' @param sensitivity How sensitive should knee detection be? Defaults to 1. Can be a float/double.
#' @keywords knee
#' @export
#' @returns This function returns a x,y coordinate pair that corresponds to the knee point
#' @examples
#' x <- kneedle(c(1,2,3,4,5), c(0,1,2,40,60))

kneedle <- function(x, y, decreasing, concave, sensitivity = 1) {
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
  # This decreasing value has nothing to do with the user inputted value.
  data <- data[order(data[,1], decreasing = FALSE), ]


  # If both decreasing and concave are not specified, then this algorithm will
  # take a guess at those parameters instead of defaulting to certain values.
  # One method is to take the derivative of the starting point to the ending point
  # from min x value to max x value. This should be similar to taking the average of all
  # derivatives from xi to xi+1 where i = 1 to i = length(xvalues)
  if(missing(decreasing)) {
    # Increasing discrete data
    if( (data[(nrow(data)), 2] - data[1, 2]) >= 0 ) {
      decreasing = FALSE
    # Decreasing discrete data
    } else {
      decreasing = TRUE
    }
  }

  # To determine concavity we need to look at the second derivative of the
  # entire set of discrete data from xi to xi+1 where i = 1 to i = length(xvalues)
  # Taking the average of all the second derivatives, if greater or equal to 0
  # then concave up. If less than 0 then concave down.
  if(missing(concave)) {
    secondderiv <- diff(diff(data[, 2]) / diff(data[, 1]))
    if(mean(secondderiv) > 0) {
      concave = TRUE
    } else {
      concave = FALSE
    }
  }

  maxy <- max(y)
  miny <- min(y)
  maxx <- max(x)
  minx <- min(x)
  data[ ,1] <- (data[, 1]- min(data[, 1]))/(max(data[ ,1])- min(data[, 1]))
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

  return(c(as.numeric(x),as.numeric(y)))
}
