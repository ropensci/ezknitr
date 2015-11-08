#' Set up a test directory to experiment with \code{ezspin}
#'
#' This function creates a few directories that try to mimic a real
#' data-analysis project structure, and adds a simple R script and a data file.
#' After setting up these files and directories, you can run both
#' \code{knitr::spin} and \code{ezknitr::ezspin} on the R script to see the
#' benefits of \code{ezspin}.
#'
#' The console output from this function will give more specific insturctions on
#' how to interact with this test directory.
#' @return The path to the root of the test directory.
#' @export
#' @examples
#' \dontrun{
#' library(ezknitr)
#' 
#' # setup the test directory structures and run naive spin
#' setup_ezspin_test()
#' knitr::spin("ezknitr_test/R/ezspin_test.R")
#' file.remove(c("ezspin_test.md", "ezspin_test.html"))
#' 
#' # setup the test directory structures and run simple ezspin
#' setup_ezspin_test()
#' ezspin("R/ezspin_test.R", wd = "ezknitr_test")
#' 
#' # setup the test directory structures and run ezspin with more parameters
#' tmp <- setup_ezspin_test()
#' ezspin("R/ezspin_test.R", wd = "ezknitr_test",
#'         out_dir = "output", fig_dir = "coolplots")
#' unlink(tmp, recursive = TRUE, force = TRUE)
#' }
#' @seealso \code{\link[ezknitr]{ezspin}}
#' @seealso \code{\link[knitr]{spin}}
setup_ezspin_test <- function() {
  s <- try(
    system.file("examples", "ezspin_test.R", package = "ezknitr", mustWork = TRUE),
    silent = TRUE)
  if (class(s) == "try-error") {
    stop("Could not find example file")
  }
  
  testdir <- file.path("ezknitr_test")
  unlink(list.files(testdir, full.names = TRUE), recursive = TRUE, force = TRUE)
  
  rdir <- file.path(testdir, "R")
  datadir <- file.path(testdir, "data")
  dir.create(rdir, showWarnings = FALSE, recursive = TRUE)
  dir.create(datadir, showWarnings = FALSE)
  
  file.copy(from = s, to = rdir)
  cat("10 20 30", file = file.path(datadir, "numbers.txt"))
  
  message(paste0("`ezspin` demo was set up at\n", normalizePath(testdir), "\n\n",
                 "To experiment with `ezspin`, run the following command. ",
                 "After each command, look where all the ",
                 "output was created and look at the resulting output to see ",
                 "the differences.\n"))
  
  message('   1.   knitr::spin("ezknitr_test/R/ezspin_test.R")')
  message('   2.   ezknitr::ezspin("R/ezspin_test.R", wd = "ezknitr_test")')
  message('   3.   ezknitr::ezspin("R/ezspin_test.R", wd = "ezknitr_test",')
  message('                        out_dir = "output", fig_dir = "coolplots")')
  
  invisible(testdir)
}
