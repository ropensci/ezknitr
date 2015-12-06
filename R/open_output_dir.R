#' Open the directory containing the output from the last ezknitr command
#'
#' Call this function after running \link[ezknitr]{ezspin} or
#' \link[ezknitr]{ezknit} to open the resulting output directory in your
#' file browser. This is simply a convenience function so that if you want to
#' see the results you don't need to navigate to the appropriate folder manually.
#' @examples
#' \dontrun{
#' library(ezknitr)
#' setup_ezspin_test()
#' ezspin("R/ezspin_test.R", wd = "ezknitr_test")
#' open_output_dir()
#' }
#' @export
open_output_dir <- function() {
  dir <- .globals$last_out_dir
  
  if (is.null(dir)) {
    stop("You need to first run `ezspin` or `ezknit`",
         call. = FALSE)
  }
  
  dir <- normalizePath(dir, mustWork = FALSE)
  
  if (!dir.exists(dir)) {
    stop(paste0("The following directory does not exist anymore: ",
                dir),
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
  message(paste0("Opening ", dir))
  suppressWarnings(do.call(rcmd, list(shellcmd)))
}