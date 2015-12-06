#' @export
#' @rdname setup_test
setup_ezspin_test <- function() {
  setup_test_helper("ezspin")
}

#' @export
#' @rdname setup_test
setup_ezknit_test <- function() {
  setup_test_helper("ezknit")
}

#' Set up a test directory to experiment with \code{ezspin} or \code{ezknit}
#'
#' Create a few directories that try to mimic a real
#' data-analysis project structure, and add a data file and a simple R script
#' (for \code{ezspin}) or Rmarkdown file (for \code{ezknit}).\cr\cr
#' After setting up these files and directories, you can run \code{ezknitr}
#' commands and their equivalent \code{knitr} commands to compare and see the
#' benefits of using \code{ezknitr}.\cr\cr
#' More specific instructions on how to interact with this test directory will
#' be printed to the console.
#' @return The path to the test directory.
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
#' \code{\link[knitr]{spin}}
#' \code{\link[ezknitr]{ezknit}}
#' \code{\link[knitr]{knit}}
#' \code{\link[ezknitr]{open_output_dir}}
#' @name setup_test
NULL

setup_test_helper <- function(type) {
  type <- match.arg(type, c("ezspin", "ezknit"))
  
  if (type == "ezspin") {
    fileName <- paste0(type, "_test.R")
  } else if (type == "ezknit") {
    fileName <- paste0(type, "_test.Rmd")
  }
  
  file <- try(
    system.file("examples", fileName, package = "ezknitr", mustWork = TRUE),
    silent = TRUE)
  if (class(file) == "try-error") {
    stop("Could not find example file")
  }
  
  testdir <- file.path("ezknitr_test")
  unlink(list.files(testdir, full.names = TRUE), recursive = TRUE, force = TRUE)
  
  rdir <- file.path(testdir, "R")
  datadir <- file.path(testdir, "data")
  dir.create(rdir, showWarnings = FALSE, recursive = TRUE)
  dir.create(datadir, showWarnings = FALSE)
  
  file.copy(from = file, to = rdir)
  cat("10 20 30", file = file.path(datadir, "numbers.txt"))
  
  message(paste0("`", type, "` demo was set up at\n", normalizePath(testdir), "\n\n",
                 "To experiment with `", type, "`, run the following commands. ",
                 "After each command, look where all the ",
                 "output was created and look at the resulting output to see ",
                 "the differences.\n"))
  
  message(sprintf('\t1.  knitr::%s("ezknitr_test/R/%s")', substring(type, 3), fileName))
  message(sprintf('\t2.  ezknitr::%s("R/%s", wd = "ezknitr_test")', type, fileName))
  message(sprintf('\t3.  ezknitr::%s("R/%s", wd = "ezknitr_test",', type, fileName))
  message(sprintf('\t\t\tout_dir = "output", fig_dir = "coolplots")'))
  
  invisible(testdir)
}
