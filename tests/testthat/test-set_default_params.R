context("set_default_params")

test_that("set_default_params basic functionality works", {
  suppressWarnings(rm(foo))
  suppressWarnings(rm(bar))
  set_default_params(list(foo = 10, bar = 20))
  expect_equal(foo, 10)
  expect_equal(bar, 20)
  
  suppressWarnings(rm(foo))
  suppressWarnings(rm(bar))
  foo <- 5
  set_default_params(list(foo = 10, bar = 20))
  expect_equal(foo, 5)
  expect_equal(bar, 20)
})