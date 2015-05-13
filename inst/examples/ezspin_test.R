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
#' (If you see errors when using `spin`, that's expected - it's because the
#' working directory was not what the script assumed.)

#+ noecho, echo = FALSE
#' A plot:
plot(1:10)
