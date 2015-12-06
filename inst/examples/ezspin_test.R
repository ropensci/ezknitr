#' Time: `r date()`
#'
#' Where am I? My working directory is:
#'
#' `r getwd()`
#'
#'
#' I like to assume the directory containing the 'R' and 'data' folders is the
#' working directory.  Let's try to read a file from the 'data' folder.
dat <- scan("data/numbers.txt", quiet = TRUE)
#' How many numbers were read from the input?
length(dat)
#' (If you see errors when using `knitr`, that's expected - it's because the
#' working directory was not what the script assumed.)
#+ setparam, echo = FALSE
ezknitr::set_default_params(list(numPoints = 15))
#' Here's a plot of `r numPoints` random points:
#+ plot, echo = FALSE
set.seed(100)
plot(rnorm(numPoints))
