#' Open the directory containing the output from the previous ezknitr command
#'
#' Call this function after running an \link[ezknitr]{ezspin} or
#' \link[ezknitr]{ezknit} command to open the resulting output directory in your
#' file browser.
#' @export
#' @examples
#' \dontrun{
#' library(ezknitr)
#' setup_ezspin_test()
#' ezspin("R/ezspin_test.R", wd = "ezknitr_test")
#' open_output_dir()
#' }
open_output_dir <- function() {
  dir <- .globals$last_out_dir
  if (is.null(dir)) {
    stop("You need to first run `ezpin` or `ezknit`",
         call. = FALSE)
  }
  switch(
    Sys.info()[['sysname']],
    
    # Windows
    Windows = {
      rcmd <- "shell"
      shellcmd <- "explorer"
    },
    
    # gnome-supported linux
    Linux  = {
      rcmd <- "system"
      shellcmd <- "nautilus --browser"
    },
    
    # OS-X
    Darwin = {
      rcmd <- "system"
      shellcmd <- "open -R"
    },
    
    # None of the above
    {
      stop("Could not recognize your operating system",
           call. = FALSE)
    }
  )
  
  shellcmd <- paste0(shellcmd, " ", dir)
  suppressWarnings(do.call(rcmd, list(shellcmd)))
}