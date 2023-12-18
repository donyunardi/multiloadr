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
    args = c(
      temp_dir,
      "&& git clone https://github.com/donyunardi/formultiloadrunittest.git"
    )
  )
  expect_output(
    add_pkgs(
      "formultiloadrunittest",
      file.path(temp_dir, "formultiloadrunittest")
    ),
    "added to multiloadr"
  )
  expect_output(
    add_pkgs(
      "formultiloadrunittest",
      file.path(temp_dir, "formultiloadrunittest")
    ),
    "already exist in multiloadr"
  )

  x <- getOption("multiloadr")

  expect_equal(length(x), 1)
  expect_equal(names(x), "formultiloadrunittest")
  expect_output(
    list_pkgs(),
    "Package Name:.*mformultiloadrunittest"
  )
  expect_output(
    load_pkgs(),
    regexp = "formultiloadrunittest.*will be loaded from the"
  )
  expect_output(
    load_pkgs(branch_name = "main"),
    "main branch exist"
  )
  expect_output(
    load_pkgs(git_pull = TRUE),
    "Attemping to perform git pull..."
  )
  expect_output(
    load_pkgs(branch_name = "notexist"),
    "notexist branch doesn't exist"
  )

  expect_output(
    {
      from_commit <- list(formultiloadrunittest = "ac6ae79c25c44d204756096cbbeb1cd105c1261d") # nolint
      load_pkgs(from_commit = from_commit)
    },
    "Loading from commit ac6ae79c25c44d204756096cbbeb1cd105c1261d"
  )

  system2(
    "cd",
    args = c(temp_dir, "&& cd formultiloadrunittest && git checkout v0.0.1"),
    stdout = FALSE,
    stderr = FALSE
  )

  expect_output(
    load_pkgs(git_pull = TRUE),
    "The current branch could not be located"
  )

  expect_warning(
    load_pkgs(git_pull = TRUE),
    "Please check your local changes"
  )
  expect_output(
    load_pkgs(git_pull = TRUE, load_verbose = "silent"),
    "The current branch could not be located"
  )

  expect_output(
    rm_pkgs("formultiloadrunittest2"),
    "Can't find formultiloadrunittest2 in multiloadr"
  )

  system2(
    "cd",
    args = c(
      temp_dir,
      "&& cd formultiloadrunittest",
      "&& git checkout main",
      "&& echo 'testing2' >> .gitignore"
    )
  )

  expect_warning(
    load_pkgs(branch_name = "update_description"),
    "Can't switch to update_description"
  )

  expect_output(
    load_pkgs(branch_name = "update_description", load_verbose = ""),
    "Can't switch to update_description"
  )

  expect_error(
    load_pkgs(branch_name = "update_description", load_verbose = "error")
  )

  rm_pkgs("formultiloadrunittest")
  x <- getOption("multiloadr")
  expect_equal(length(x), 0)
})
