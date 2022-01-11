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
#' @param x list list of x coordinates
#' @param y list list of y coordinates
#' @param decreasing is the function increasing?
#' @param sensitivity how sensitive should knee detection be?
#' @param concave is this concave or convex?
#' @keywords knee
#' @export
#' kneedle()

kneedle <- function(x, y, decreasing, sensitivity, concave) {

  data <- matrix(unlist(list(x, y)), ncol = 2)
  data <- data[order(data[,1], decreasing = decreasing), ]
  maxy <- max(y)
  miny <- min(y)
  data[ ,1] <- (data[, 1]- min(data[, 1]))/(max(data[ ,1])-min(data[, 1]))
  data[ ,2] <- (data[, 2]- min(data[, 2]))/(max(data[ ,2])- min(data[, 2]))

  if(concave && !decreasing) {
    differ <- abs(c(data[ ,2] - data[ ,1]))
  } else if(concave && decreasing) {
    differ <- abs(c(data[ ,2] - data[ ,1]))
  } else if(!concave && !decreasing) {
    differ <- abs(c(data[ ,2] - (1 - data[ ,1])))
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

    for(j in peak.indices[i]:if(i+1 < length(peak.indices)) peak.indices[i+1] else i) {

      if(differ[j] < T) {
        knee = peak.indices[i];
        break;
      }
    }
    if(!is.null(knee)) {
      break;
    }
  }

  return((maxy + miny) * (data[knee, 2] + miny))
}
