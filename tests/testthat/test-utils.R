test_that("utils works", {
  expect_output(no_current_branch_msg(), "The current branch could not be located")
})
