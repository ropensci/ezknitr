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
#' @param loc The path where you want to set up the test directories.
#' @return The path to the root of the test directory.
#' @export
#' @examples
#' \dontrun{
#' library(ezknitr)
#' tmp <- setup_ezspin_test("~")
#' origwd <- setwd(tmp)
#' knitr::spin("container/R/ezspin_test.R")
#' setup_ezspin_test("..")
#' ezspin("R/ezspin_test.R", wd = "container")
#' setup_ezspin_test("..")
#' ezspin("R/ezspin_test.R", wd = "container",
#'         out_dir = "output", fig_dir = "coolplots")
#' setwd(origwd)
#' unlink(tmp, recursive = TRUE, force = TRUE)
#' }
#' @seealso \code{\link[ezknitr]{ezspin}}
#' @seealso \code{\link[knitr]{spin}}
setup_ezspin_test <- function(loc = getwd()) {
  s <- try(
    system.file("examples", "ezspin_test.R", package = "ezknitr", mustWork = TRUE),
    silent = TRUE)
  if (class(s) == "try-error") {
    stop("Could not find example file")
  }

  testdir <- file.path(loc, "ezspin_test")
  unlink(list.files(testdir), recursive = TRUE, force = TRUE)

  container <- file.path(testdir, "container")
  rdir <- file.path(container, "R")
  datadir <- file.path(container, "data")
  dir.create(rdir, showWarnings = FALSE, recursive = TRUE)
  dir.create(datadir, showWarnings = FALSE)

  file.copy(from = s, to = rdir)
  cat("10 20 30", file = file.path(datadir, "numbers.txt"))

  message(paste0("ezspin demo was set up at\n", normalizePath(testdir), "\n\n",
                 "To experiment with ezspin, set that as your working directory and ",
                 "run following commands. After each command, look where all the ",
                 "output was created and look at the resulting output to see ",
                 "the differences.\n"))

  message('   1.   knitr::spin("container/R/ezspin_test.R")')
  message('   2.   ezknitr::ezspin("R/ezspin_test.R", wd = "container")')
  message('   3.   ezknitr::ezspin("R/ezspin_test.R", wd = "container",')
  message('                        out_dir = "output", fig_dir = "coolplots")')

  message(paste0('\nNote: to start with a clean state after each of the above ',
                 'commands, run `ezknitr::setup_ezspin_test("..")` to set up the demo ',
                 'directories again.'))

  invisible(testdir)
}
