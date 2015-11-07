#' Create markdown/HTML reports from Rmd files with no hassle
#'
#' Similar to \code{\link[ezknitr]{ezspin}}, but works as a replacement
#' to \code{knitr::knit} instead of \code{knitr::spin}. Read the full
#' documentation at \code{\link[ezknitr]{ezspin}}.
#'
#' @inheritParams ezspin
#' @return The path to the output (invisibly).
#' @export
#' @seealso \code{\link[ezknitr]{ezspin}}
ezknit <- function(file, wd, out_dir, fig_dir, out_suffix,
                   params = list(),
                   verbose = FALSE,
                   chunk_opts = list(tidy = FALSE)) {
  ezknitr_helper(caller = "ezknit",
                 file = file, wd = wd, out_dir = out_dir,
                 fig_dir = fig_dir, out_suffix = out_suffix,
                 params = params, verbose = verbose, chunk_opts = chunk_opts)
}
