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
ezknit <- function(file, wd, outDir, figDir, outSuffix,
                   params = list(),
                   verbose = FALSE,
                   chunkOpts = list(tidy = FALSE)) {
  ezknitr_helper(caller = "ezknit",
                 file = file, wd = wd, outDir = outDir,
                 figDir = figDir, outSuffix = outSuffix,
                 params = params, verbose = verbose, chunkOpts = chunkOpts)
}
