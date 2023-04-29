test_that("reset_multiloadr works", {
  add_pkgs("test", "/random/path")
  reset_multiloadr()
  expect_equal(getOption("multiloadr"), NULL)
})
