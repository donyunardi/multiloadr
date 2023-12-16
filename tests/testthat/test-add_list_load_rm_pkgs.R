test_that("add_pkgs, list_pkgs, load_pkgs, rm_pkgs works", {
  reset_multiloadr()
  expect_output(list_pkgs(), "No packages to list.")
  expect_output(
    add_pkgs("testing", "/path/to/folder"),
    "Directory is not an R package"
  )
  expect_output(load_pkgs(), "No packages to load")

  temp_dir <- tempdir()
  system2(
    "cd",
    args = c(temp_dir, "&& git clone https://github.com/r-lib/whoami.git")
  )
  expect_output(
    add_pkgs("whoami", file.path(temp_dir, "whoami")),
    "added to multiloadr"
  )
  expect_output(
    add_pkgs("whoami", file.path(temp_dir, "whoami")),
    "already exist in multiloadr"
  )

  x <- getOption("multiloadr")

  expect_equal(length(x), 1)
  expect_equal(names(x), "whoami")
  expect_output(list_pkgs(), "Package Name: \033\\[0;94mwhoami\033\\[0m\n")
  expect_output(
    load_pkgs(),
    "\033\\[0;94mwhoami\033\\[0m will be loaded from the \033\\[0;92m"
  )
  expect_output(
    load_pkgs(branch_name = "main"),
    "\033\\[0;92mmain branch exist"
  )
  expect_output(
    load_pkgs(git_pull = TRUE),
    "Attemping to perform git pull...\n"
  )
  expect_output(
    load_pkgs(branch_name = "notexist"),
    "\033\\[0;91mnotexist branch doesn't exist"
  )

  system2(
    "cd",
    args = c(temp_dir, "&& cd whoami && git checkout v1.2.0")
  )

  expect_output(
    load_pkgs(git_pull = TRUE),
    "The current branch could not be located"
  )

  expect_output(rm_pkgs("whoami2"), "Can't find whoami2 in multiloadr")
  rm_pkgs("whoami")
  x <- getOption("multiloadr")
  expect_equal(length(x), 0)
})
