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

# Check if a path is a real directory
isDirectoryMock <- function(pathname) {
  pathname <- as.character(pathname)
  fileinfo <- file.info(pathname)
  if (is.na(fileinfo$isdir)) {
    return(FALSE)
  }
  fileinfo$isdir
}
isDirectory <- function(pathname) {
  if (requireNamespace("R.utils", quietly = TRUE)) {
    return(R.utils::isDirectory(pathname))
  }
  isDirectoryMock(pathname)
}

# Check if a path is a real file
isFileMock <- function(pathname) {
  pathname <- as.character(pathname)
  fileinfo <- file.info(pathname)
  if (is.na(fileinfo$isdir)) {
    return(FALSE)
  }
  !(fileinfo$isdir)
}
isFile <- function(pathname) {
  if (requireNamespace("R.utils", quietly = TRUE)) {
    return(R.utils::isFile(pathname))
  }
  isFileMock(pathname)
}

# Check if a path is an absolute path
isAbsolutePathMock <- function(pathname) {
  pathname <- as.character(pathname)
  if (is.na(pathname) | !nzchar(pathname)) {
    return(FALSE)
  }
  if (regexpr("^(~|/|([a-zA-Z]:))", pathname) != -1L) {
    return(TRUE)
  }
  FALSE
}
isAbsolutePath <- function(pathname) {
  if (requireNamespace("R.utils", quietly = TRUE)) {
    return(R.utils::isAbsolutePath(pathname))
  }
  isAbsolutePathMock(pathname)
}
