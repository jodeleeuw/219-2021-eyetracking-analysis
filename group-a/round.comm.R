#Round like a normal person (i.e. "commercial rounding" i.e. rounding half away from zero) rather than the IEEE standard that is the base R default (see https://en.wikipedia.org/wiki/Rounding for info). 

#Via https://statisticsglobe.com/r-round-ceiling-floor-trunc-signif-function-example, which was based on a comment here: http://andrewlandgraf.com/2012/06/15/rounding-in-r/  

round.comm <- function(x, digits = 0) {  # Function to always round 0.5 away from 0
  posneg <- sign(x)
  z <- abs(x) * 10^digits
  z <- z + 0.5
  z <- trunc(z)
  z <- z / 10^digits
  z * posneg
}