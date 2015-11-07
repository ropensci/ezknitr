#' Create markdown/HTML reports from Rmd files with no hassle
#'
#' Similar to \code{\link[ezrender]{ezspin}}, but works as a replacement
#' to \code{knitr::knit} instead of \code{knitr::spin}. Read the full
#' documentation at \code{\link[ezrender]{ezspin}}.
#'
#' @inheritParams ezspin
#' @return The path to the output (invisibly).
#' @export
#' @seealso \code{\link[ezrender]{ezspin}}
ezknit <- function(file, wd, outDir, figDir, outSuffix,
                   params = list(),
                   verbose = FALSE,
                   chunkOpts = list(tidy = FALSE)) {

  if (missing(outSuffix)) {
    outSuffix <- ""
  } else {
    if (is.string(outSuffix)) {
      outSuffix <- paste0("-", outSuffix)
    } else {
      stop("`outSuffix` is not a valid string.",
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

  inputDir <- dirname(file)

  # Default output directory is where input is located, otherwise build the path
  # relative to the working directory
  if (missing(outDir)) {
    outDir <- inputDir
  } else if(!R.utils::isAbsolutePath(outDir)) {
    outDir <- file.path(wd, outDir)
  }
  dir.create(outDir, recursive = TRUE, showWarnings = FALSE)
  outDir <- normalizePath(outDir)

  # Get the filenames for all intermediate files
  fileNameOrig <- sub("(\\.[rR]md)$", "", basename(file))
  fileName <- paste0(fileNameOrig, outSuffix)
  fileMd <- file.path(outDir, paste0(fileName, ".md"))
  fileHtml <- file.path(outDir, paste0(fileName, ".html"))

  if (missing(figDir)) {
    figDir <- fileName
  }

  # On Windows (as opposed to unix systems), file.path does not append a
  # separator at the end, so add one manually to ensure this works
  # cross-platform
  figDir <- file.path(figDir, .Platform$file.sep)

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
  knitr::opts_knit$set(base.dir = outDir)
  knitr::opts_chunk$set(fig.path = figDir)

  # Use the user-defined chunk options
  knitr::opts_chunk$set(chunkOpts)

  # Create the figure directory if it doesn't exist (otherwise we get errors)
  fullFigPath <- file.path(knitr::opts_knit$get("base.dir"),
                           knitr::opts_chunk$get("fig.path"))
  dir.create(fullFigPath, recursive = TRUE, showWarnings = FALSE)

  # Create any parameters that should be visible to the script in a new
  # environment so that we can knit the script in that isolated environment
  params <- as.list(params)
  ezknit_env <- list2env(params)

  # Some folder cleanup when the function exists
  on.exit({
    # Because of a bug in knitr, the figures directory is created in the
    # working directory with nothing in it, as well as being created where it
    # should be and with the right files inside. Delete that folder.
    figDirName <- file.path(dirname(figDir), basename(figDir))
    suppressWarnings(unlink(figDirName, recursive = TRUE))

    # If no figures are generated, remove the figures folder
    if (length(list.files(fullFigPath)) == 0) {
      suppressWarnings(unlink(fullFigPath, recursive = TRUE))
    }
  }, add = TRUE)

  # --------

  # This is the guts of this function - take the R script and produce HTML
  # in a few simple steps
  knitr::knit(file,
              fileMd,
              quiet = !verbose,
              envir = ezknit_env)
  markdown::markdownToHTML(fileMd,
                           fileHtml)

  message(paste0("ezknit output in\n", outDir))

  invisible(outDir)
}
