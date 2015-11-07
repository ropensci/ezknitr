# Check if an input is a boolean (either TRUE or FALSE)
is.bool <- function(x) {
  is.logical(x) && length(x) == 1 && !is.na(x)
}

# Check if an input is a string
is.string <- function(x) {
  is.character(x) && length(x) == 1
}

# Convert a ... argument into a character vector
dotsToChar <- function(...) {
  as.character(substitute(list(...)))[-1L]
}
