#' Set default parameters
#' 
#' Create variables with the given values only if these variables do not currently
#' exist.
#' 
#' Sometimes it may be useful to define a variable only it hasn't been defined yet.
#' One example where this can be useful is when you have an Rmd script that 
#' uses some variables and you want to be able to use custom values for these
#' variables, but also give them a default value in the script in case they are
#' not set beforehand.
#'
#' @param params List of parameters.
#' @examples 
#' exists("foo")
#' exists("bar")
#' foo <- 5
#' set_default_params(list(foo = 10, bar = 20))
#' print(foo)
#' print(bar)
#' @export
set_default_params <- function(params) {
  params <- as.list(params)
  env <- parent.frame(1)

  invisible(
    lapply(names(params), function(key) {
      if (!exists(key, envir = env, inherits = FALSE)) {
        assign(key, params[[key]], envir = env, inherits = FALSE)
      }
    })
  )
}
