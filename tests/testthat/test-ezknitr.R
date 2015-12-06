context("ezknitr_core")

test_that("ezknit creates the correct files", {
  tmp <- setup_ezknit_test()
  ezknit("R/ezknit_test.Rmd", wd = "ezknitr_test")
  files <- c(
    file.path(tmp, "R", "ezknit_test.Rmd"),
    file.path(tmp, "R", "ezknit_test.md"),
    file.path(tmp, "R", "ezknit_test.html"),
    file.path(tmp, "R", "ezknit_test", "noecho-1.png"),
    file.path(tmp, "data", "numbers.txt")
  )
  expect_true(all(file.exists(files)))
  unlink(tmp, recursive = TRUE, force = TRUE)
  
  tmp <- setup_ezknit_test()
  ezknit("R/ezknit_test.Rmd", wd = "ezknitr_test",
         out_dir = "output", fig_dir = "coolplots")
  files <- c(
    file.path(tmp, "R", "ezknit_test.Rmd"),
    file.path(tmp, "output", "ezknit_test.md"),
    file.path(tmp, "output", "ezknit_test.html"),
    file.path(tmp, "output", "coolplots", "noecho-1.png"),
    file.path(tmp, "data", "numbers.txt")
  )
  expect_true(all(file.exists(files)))
  unlink(tmp, recursive = TRUE, force = TRUE)
})

test_that("ezspin creates the correct files", {
  tmp <- setup_ezspin_test()
  ezspin("R/ezspin_test.R", wd = "ezknitr_test")
  files <- c(
    file.path(tmp, "R", "ezspin_test.R"),
    file.path(tmp, "R", "ezspin_test.md"),
    file.path(tmp, "R", "ezspin_test.html"),
    file.path(tmp, "R", "ezspin_test", "noecho-1.png"),
    file.path(tmp, "data", "numbers.txt")
  )
  expect_true(all(file.exists(files)))
  unlink(tmp, recursive = TRUE, force = TRUE)
  
  tmp <- setup_ezspin_test()
  ezspin("R/ezspin_test.R", wd = "ezknitr_test",
         out_dir = "output", fig_dir = "coolplots", keep_rmd = TRUE)
  files <- c(
    file.path(tmp, "R", "ezspin_test.R"),
    file.path(tmp, "output", "ezspin_test.Rmd"),
    file.path(tmp, "output", "ezspin_test.md"),
    file.path(tmp, "output", "ezspin_test.html"),
    file.path(tmp, "output", "coolplots", "noecho-1.png"),
    file.path(tmp, "data", "numbers.txt")
  )
  expect_true(all(file.exists(files)))
  unlink(tmp, recursive = TRUE, force = TRUE)  
})