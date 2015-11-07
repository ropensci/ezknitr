# Check if an input is a boolean (either TRUE or FALSE)
is.bool <- function(x) {
  is.logical(x) && length(x) == 1 && !is.na(x)
}

# Check if an input is a string
is.string <- function(x) {
  is.character(x) && length(x) == 1
}

# Convert a ... argument into a character vector
dotsToChar <- function(...) {
  as.character(substitute(list(...)))[-1L]
}

# Main powerhorse function that runs the logic for ezknit and ezspin
ezknitr_helper <- function(caller,
                           file, wd, out_dir, fig_dir, out_suffix,
                           params = list(),
                           verbose = FALSE,
                           chunk_opts = list(tidy = FALSE),
                           keep_rmd = FALSE, keep_md = TRUE) {
  caller <- match.arg(caller, c("ezspin", "ezknit"))
  
  if (missing(out_suffix)) {
    out_suffix <- ""
  } else {
    if (is.string(out_suffix)) {
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
  if (caller == "ezspin") {
    fileNameOrig <- sub("(\\.[rR])$", "", basename(file))
  } else if (caller == "ezknit") {
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
    # Because of a bug in knitr, the figures directory is created in the
    # working directory with nothing in it, as well as being created where it
    # should be and with the right files inside. Delete that folder.
    fig_dirName <- file.path(dirname(fig_dir), basename(fig_dir))
    suppressWarnings(unlink(fig_dirName, recursive = TRUE))
    
    # If no figures are generated, remove the figures folder
    if (length(list.files(fullFigPath)) == 0) {
      suppressWarnings(unlink(fullFigPath, recursive = TRUE))
    }
  }, add = TRUE)
  
  # --------
  
  # This is the guts of this function - take the R script and produce HTML
  # in a few simple steps
  if (caller == "ezspin") {
    knitr::spin(file, format = "Rmd", knit = FALSE)
    file.rename(fileRmdOrig,
                fileRmd)
  } else if (caller == "ezknit") {
    fileRmd <- file
  }
  knitr::knit(fileRmd,
              fileMd,
              quiet = !verbose,
              envir = ezknitr_env)
  if (caller == "ezspin" && !keep_rmd) {
    unlink(fileRmd)
  }
  markdown::markdownToHTML(fileMd,
                           fileHtml)
  if (caller == "ezspin" && !keep_md) {
    unlink(fileMd)
  }
  
  message(paste0(caller, " output in\n", out_dir))
  
  invisible(out_dir)
}