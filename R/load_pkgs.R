#' Load packages from specified branch and perform git pull if specified
#'
#' This code loads packages based on the multiloadr option provided. It has an
#' additional feature that allows loading packages from a particular branch
#' (locally or remotely) or commit if specified. If not, the function will load
#' packages from the currently active branch. The function also provides an
#' optional argument to execute a git pull before loading the packages.
#'
#' The function accepts multiple branch_name arguments, but only the first
#' branch that is found will be loaded for each package.
#'
#' @param branch_name Character vector specifying the name of the git branch(es)
#' to load. Defaults to \code{NULL}. The first branch that is found will be
#' loaded for each package. If it is NULL or non-existent, it will be loaded
#' from the presently active branch.
#' If local changes make checkout unsuccessful, the function will produce error.
#'
#' @param git_pull A logical value (TRUE/FALSE) indicating whether to perform a
#' `git pull` before loading the package. Defaults to \code{FALSE}.
#' If local changes make pull unsuccessful, the function will produce error.
#'
#' @param from_commit A named list indicating the commit hash to load for each
#' package.
#'
#' @param load_verbose Default: `warning` A string that sets
#' how should a pull/checkout failure be reported.
#' `error` for stopping with an error,
#' `warning` to show warning and continue,
#' `message`/unset for just logging the git failure.
#' Default value can be set with `options('multiloadr.load.verbose' = 'error')`.
#'
#' @return This function returns nothing, but prints a message indicating which
#' packages were loaded and from which branch.
#'
#' @export
#'
#' @examples
#' if (interactive()) {
#'   add_pkgs("packageA", "/path/to/packageA")
#'   add_pkgs("packageB", "/path/to/packageB")
#'
#'   # Load packages without switching branch
#'   load_pkgs()
#'
#'   # Switch to "develop" branch and load packages
#'   load_pkgs(branch_name = "develop")
#'
#'   # Switch to the "develop" branch, pull the latest changes, and load packages
#'   load_pkgs(branch_name = "develop", git_pull = TRUE)
#'
#'   # Load packages from "develop" branch if available, or "main" branch otherwise
#'   # Pull the latest changes before loading the packages
#'   load_pkgs(branch_name = c("develop", "main"), git_pull = TRUE)
#'
#'   # Load packages from specific commit
#'   from_commit <- list(packageA = "hash_commit")
#'   load_pkgs(branch_name = "main", git_pull = TRUE, from_commit = from_commit)
#' }
#'
load_pkgs <- function(
    branch_name = NULL, git_pull = FALSE, from_commit = list(),
    load_verbose = getOption("multiloadr.load.verbose", "warning")) {
  pkgs <- get_multiloadr_pkgs()

  if (is.null(pkgs)) {
    cat("No packages to load")
    invisible()
  }

  for (i in seq_along(pkgs)) {
    pkg <- names(pkgs)[i]

    path <- pkgs[[i]]

    cat(paste0("Package: ", pkg, "\n"))

    local_pkg_branches <- system2(
      "cd",
      args = c(path, "&& git branch"),
      stdout = TRUE
    )

    remote_pkg_branches <- system2(
      "cd",
      args = c(path, "&& git branch -r"),
      stdout = TRUE
    )

    all_branches <- trimws(
      sub(
        "origin\\/", "",
        sub("\\*", "", c(local_pkg_branches, remote_pkg_branches))
      )
    )

    if (!is.null(branch_name)) {
      for (branch in branch_name) {
        if (branch %in% all_branches) {
          cat(
            paste0(
              "\033[0;92m", branch, " branch exist for \033[0m",
              "\033[0;94m", pkg, "\033[0m\n"
            )
          )

          checkout_error <- system2(
            "cd",
            args = c(path, paste("&& git checkout", branch)),
            stdout = FALSE,
            stderr = FALSE
          )
          if (checkout_error) {
            message <- paste(
              "\033[0;91mCan't switch to", branch, "branch for\033[0;94m",
              pkg, "\033[0m\n",
              " \033[0;91mPlease check your local changes. \033[0m"
            )
            switch(load_verbose,
              error = stop(message),
              warning = warning(message, immediate. = TRUE),
              silent = invisible(),
              cat(message)
            )
          }
          break
        } else {
          cat(
            paste0(
              "\033[0;91m", branch, " branch doesn't exist for \033[0m",
              "\033[0;94m", pkg, "\033[0m\n"
            )
          )
        }
      }
    }

    current_branch <- get_current_branch(path)

    if (!identical(current_branch, character(0))) {
      cat(paste0(
        "Loading \033[0;94m", pkg, "\033[0m from the \033[0;92m",
        current_branch, "\033[0m branch.\n"
      ))
    } else {
      no_current_branch_msg()
      cat(paste0("Loading ", pkg, " from ", path, "\n"))
    }

    if (git_pull) {
      cat("\033[0;96mStart git pull...\033[0m\n")
      if (!identical(current_branch, character(0))) {
        check_remote <- system2(
          "cd",
          args = c(path, "&& git ls-remote origin"),
          stdout = FALSE,
          stderr = FALSE
        )

        if (!check_remote) {
          cat("\033[0;96mRemote URL exists...\033[0m\n")
          cat("\033[0;96mPerforming git pull...\033[0m\n")
          pull_error <- system2(
            "cd",
            args = c(path, "&& git pull"),
            stdout = FALSE,
            stderr = FALSE
          )
          if (pull_error) {
            message <- paste(
              "\033[0;91mCan't pull the", branch, "branch for\033[0;94m",
              pkg, "\033[0m\n",
              "Please check your local changes for\033[0;94m",
              pkg, "\033[0m\n"
            )
            switch(load_verbose,
              error = stop(message),
              warning = warning(message, immediate. = TRUE),
              silent = invisible(),
              cat(message)
            )
          }
        } else {
          cat("Remote URL does not exist...\n")
          cat("Skipping git pull...\n")
        }
      } else {
        no_current_branch_msg()
        cat("Skipping git pull...\n")
      }
    }

    position <- which(names(from_commit) == pkg)

    if (length(position) > 0) {
      cat(paste0("Loading from commit ", from_commit[position][[1]], "\n"))
      system2(
        "cd",
        args = c(path, paste("&& git checkout", from_commit[position][[1]])),
        stdout = FALSE,
        stderr = FALSE
      )
    }

    head <- get_current_head(path)
    cat(paste0("HEAD is at \033[0;92m", head, "\033[0m.\n"))

    load_all(path)

    cat("\n")
  }
}
