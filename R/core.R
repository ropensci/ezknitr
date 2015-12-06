#' Knit Rmd or spin R files without the typical working directory pain
#'
#' \code{ezknitr} is an extension of \code{knitr} that adds flexibility in several
#' ways. Most importantly, it allows you to have a complex directory structure
#' and lets you take complete control over where all your inputs are and where
#' the outputs should go.
#'
#' If you've ever written tried using \code{knitr::spin} and got frustrated
#' with working directories and where input/output files are, then you'll love
#' \code{ezspin}! \code{knitr::spin} is great and easy when all you need to do
#' is convert an R script to a markdown/HTML and everything lives in the same
#' directory.  But if you have a real directory structure, this is rarely the
#' case, and \code{ezspin} is the solution.  Even something as simple as
#' using \code{knitr::spin} on a script that reads a file in a different
#' directory cannot be easily done in a way that allows both running the script
#' directly and using \code{spin} on it.
#'
#' \code{ezspin} improves basic \code{spin} in a few ways. You get to decide:
#'
#' - What the working directory of the R script is
#'
#' - Where the output files will go
#'
#' - Where the figures used in the markdown will go
#'
#' - If there are any parameters to pass to the R script
#' @param file The path to the R script (if \code{wd} is provided, then this
#' path is relative to \code{wd}).
#' @param wd The working directory to be used in the R script. See 'Detailed:
#' Arguments'.
#' @param out_dir The output directory (if \code{wd} is provided, then this path
#' is relative to \code{wd}). Defaults to the directory containing the R script.
#' @param fig_dir The name (or path) of the directory containing the figures
#' generated for the markdown document. See 'Detailed Arguments'.
#' @param out_suffix A suffix to add to the output files, can be used to
#' differentiate outputs from runs with different parameters. The name of the
#' output files is the name of the input script appended by \code{out_suffix},
#' separated by a dash.
#' @param chunk_opts List of chunk options to use. See \code{?knitr::opts_chunk}
#' for a list of chunk options.
#' @param verbose If TRUE, then show the progress of knitting the document.
#' @param params A named list of parameters to be passed on to the R script.
#' For example, if the script to execute assumes that there is a variable named
#' \code{DATASET_NAME}, then you can use
#' \code{params = list('DATASET_NAME' = 'oct10dat')}
#' @param keep_rmd,keep_md Should intermediate \code{Rmd} or \code{md} files be
#'   kept (\code{TRUE}) or deleted (\code{FALSE})?
#' @return The path to the output (invisibly).
#' @section Possible future improvements:
#' - Add support to avoid producing the HTML file
#' @section Detailed Arguments:
#' All paths given in the arguments can be either absolute or relative.
#'
#' The \code{wd} argument is very important and is set to the current working
#' directory by default. The path of the input file and the path of the output
#' directory are both relative to \code{wd} (unless they are absolute paths).
#' Moreover, any code in the R script that reads or writes files will use
#' \code{wd} as the working directory.
#'
#' The \code{fig_dir} argument is relative to the output directory, since the
#' figures accompanying a markdown file should ideally be placed in the same
#' directory. It is recommended to either leave \code{fig_dir} as default or
#' set it to a different name but not to a different directory. Because of the
#' way \code{knitr} works, there are a few known minor issues if \code{fig_dir}
#' is set to a different directory.
#' @examples
#' \dontrun{
#'    ezspin("R/script.R")
#'    ezspin("script.R", wd = "R")
#'    ezspin("script.R", wd = "R", params = c(id = 10))
#'    ezspin("script.R", wd = "R", params = c(id = 10), out_suffix = "id-10")
#'    ezspin("script.R", wd = "R", out_dir = "reports")
#'    ezspin("script.R", wd = "R", out_dir = "reports",
#'           fig_dir = "figs")
#' }
#' @seealso \code{\link[ezknitr]{open_output_dir}}
#' \code{\link[ezknitr]{setup_ezknit_test}}
#' \code{\link[ezknitr]{setup_ezspin_test}}
#' \code{\link[ezknitr]{set_default_params}}
#' \code{\link[knitr]{knit}}
#' \code{\link[knitr]{spin}}
#' @name ezknitr_core
NULL

#' @rdname ezknitr_core
#' @export
ezspin <- function(file, wd, out_dir, fig_dir, out_suffix,
                   params = list(),
                   verbose = FALSE,
                   chunk_opts = list(tidy = FALSE),
                   keep_rmd = FALSE, keep_md = TRUE) {
  ezknitr_helper(type = "ezspin",
                 file = file, wd = wd, out_dir = out_dir,
                 fig_dir = fig_dir, out_suffix = out_suffix,
                 params = params, verbose = verbose, chunk_opts = chunk_opts,
                 keep_rmd = keep_rmd, keep_md = keep_md)
}

#' @rdname ezknitr_core
#' @export
ezknit <- function(file, wd, out_dir, fig_dir, out_suffix,
                   params = list(),
                   verbose = FALSE,
                   chunk_opts = list(tidy = FALSE)) {
  ezknitr_helper(type = "ezknit",
                 file = file, wd = wd, out_dir = out_dir,
                 fig_dir = fig_dir, out_suffix = out_suffix,
                 params = params, verbose = verbose, chunk_opts = chunk_opts)
}

#-----------------------------------------------
#------- Main powerhorse function that runs the logic for ezknit and ezspin

ezknitr_helper <- function(type,
                           file, wd, out_dir, fig_dir, out_suffix,
                           params = list(),
                           verbose = FALSE,
                           chunk_opts = list(tidy = FALSE),
                           keep_rmd = FALSE, keep_md = TRUE) {
  type <- match.arg(type, c("ezspin", "ezknit"))
  
  if (missing(out_suffix)) {
    out_suffix <- ""
  } else {
    if (is.character(out_suffix) && length(out_suffix) == 1) {
      out_suffix <- paste0("-", out_suffix)
    } else {
      stop("`out_suffix` is not a valid string.",
           call. = FALSE)
    }
  }
  
  if (missing(file)) {
    stop("`file` argument was not supplied.",
         call. = FALSE)
  }
  
  # Default working directory is where the user is right now
  if (missing(wd)) {
    wd <- getwd()
  }
  suppressWarnings({
    wd <- normalizePath(wd)
  })
  if (!R.utils::isDirectory(wd)) {
    stop("Invalid `wd` argument. Could not find directory: ", wd,
         call. = FALSE)
  }
  
  # Determine the path fo the input file, either absolute path or relative to wd
  if (!R.utils::isAbsolutePath(file)) {
    file <- file.path(wd, file)
  }
  suppressWarnings({
    file <- normalizePath(file)
  })
  
  if (!R.utils::isFile(file)) {
    stop("Invalid `file` argument. Could not find input file: ", file,
         call. = FALSE)
  }
  
  # Make sure the correct input file is used
  if (type == "ezspin") {
    if (!grepl("(\\.[rR])$", basename(file))) {
      stop("Wrong input file (`ezspin` expects an R script)",
           call. = FALSE)
    }
  } else if (type == "ezknit") {
    if (!grepl("(\\.[rR]md)$", basename(file))) {
      stop("Wrong input file (`ezknit` expects an Rmarkdown file)",
           call. = FALSE)
    }
  }  
  
  inputDir <- dirname(file)
  
  # Default output directory is where input is located, otherwise build the path
  # relative to the working directory
  if (missing(out_dir)) {
    out_dir <- inputDir
  } else if(!R.utils::isAbsolutePath(out_dir)) {
    out_dir <- file.path(wd, out_dir)
  }
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  out_dir <- normalizePath(out_dir)
  
  # Get the filenames for all intermediate files
  if (type == "ezspin") {
    fileNameOrig <- sub("(\\.[rR])$", "", basename(file))
  } else if (type == "ezknit") {
    fileNameOrig <- sub("(\\.[rR]md)$", "", basename(file))
  }
  fileName <- paste0(fileNameOrig, out_suffix)
  fileRmdOrig <- file.path(inputDir, paste0(fileNameOrig, ".Rmd"))
  fileRmd <- file.path(out_dir, paste0(fileName, ".Rmd"))
  fileMd <- file.path(out_dir, paste0(fileName, ".md"))
  fileHtml <- file.path(out_dir, paste0(fileName, ".html"))
  
  if (missing(fig_dir)) {
    fig_dir <- fileName
  }
  
  # On Windows (as opposed to unix systems), file.path does not append a
  # separator at the end, so add one manually to ensure this works
  # cross-platform
  fig_dir <- file.path(fig_dir, .Platform$file.sep)
  
  # Save a copy of the original knitr and chunk options and revert back to them
  # when the function exits
  oldOptsKnit <- knitr::opts_knit$get()
  oldOptsChunk <- knitr::opts_chunk$get()
  on.exit({
    knitr::opts_knit$set(oldOptsKnit)
    knitr::opts_chunk$set(oldOptsChunk)
  }, add = TRUE)
  
  # Set up the directories correctly (this took many many hours to figure out..)
  knitr::opts_knit$set(root.dir = wd)
  knitr::opts_knit$set(base.dir = out_dir)
  knitr::opts_chunk$set(fig.path = fig_dir)
  
  # Use the user-defined chunk options
  knitr::opts_chunk$set(chunk_opts)
  
  # Create the figure directory if it doesn't exist (otherwise we get errors)
  fullFigPath <- file.path(knitr::opts_knit$get("base.dir"),
                           knitr::opts_chunk$get("fig.path"))
  dir.create(fullFigPath, recursive = TRUE, showWarnings = FALSE)
  
  # Create any parameters that should be visible to the script in a new
  # environment so that we can knit the script in that isolated environment
  params <- as.list(params)
  ezknitr_env <- list2env(params)
  
  # Some folder cleanup when the function exists
  on.exit({
    # If no figures are generated, remove the figures folder
    if (length(list.files(fullFigPath)) == 0) {
      suppressWarnings(unlink(fullFigPath, recursive = TRUE))
    }
  }, add = TRUE)
  
  # --------
  
  # This is the guts of this function - take the R script and produce HTML
  # in a few simple steps
  if (type == "ezspin") {
    knitr::spin(file, format = "Rmd", knit = FALSE)
    file.rename(fileRmdOrig,
                fileRmd)
  } else if (type == "ezknit") {
    fileRmd <- file
  }
  knitr::knit(fileRmd,
              fileMd,
              quiet = !verbose,
              envir = ezknitr_env)
  if (type == "ezspin" && !keep_rmd) {
    unlink(fileRmd)
  }
  markdown::markdownToHTML(fileMd,
                           fileHtml)
  if (type == "ezspin" && !keep_md) {
    unlink(fileMd)
  }
  
  message(paste0(type, " output in\n", out_dir))
  
  .globals$last_out_dir <- out_dir
  
  invisible(out_dir)
}