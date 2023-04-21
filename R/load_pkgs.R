#' Load packages from specified branch and perform git pull if specified
#'
#' This code loads packages based on the multiloadr option provided. It has an
#' additional feature that allows loading packages from a particular branch if
#' specified. If not, the function will load packages from the currently active
#' branch. The function also provides an optional argument to execute a git pull
#' before loading the packages.
#'
#' The function accepts multiple branch_name arguments, but only the first
#' branch that is found will be loaded for each package.
#'
#' @param branch_name Character vector specifying the name of the git branch(es)
#' to load. Defaults to \code{NULL}. The first branch that is found will be
#' loaded for each package. If it is NULL or non-existent, it will be loaded
#' from the presently active branch.
#'
#' @param git_pull A logical value (TRUE/FALSE) indicating whether to perform a
#' `git pull` before loading the package. Defaults to \code{FALSE}.
#'
#' @return This function returns nothing, but prints a message indicating which
#' packages were loaded and from which branch.
#'
#' @export
#'
#' @examples
#' # Load packages without switching branch
#' load_pkgs()
#'
#' # Switch to "develop" branch and load packages
#' load_pkgs(branch_name = "develop")
#'
#' # Switch to the "develop" branch, pull the latest changes, and load packages
#' load_pkgs(branch_name = "develop", git_pull = TRUE)
#'
#' # Load packages from "develop" branch if available, or "main" branch otherwise
#' # Pull the latest changes before loading the packages
#' load_pkgs(branch_name = c("develop", "main"), git_pull = TRUE)
#'
load_pkgs <- function(branch_name = NULL, git_pull = FALSE) {

  pkgs <- get_multiloadr_pkgs()

  if (is.null(pkgs)) {
    cat("No packages to load")
    invisible()
  }

  for (i in seq_along(pkgs)) {

    pkg <- names(pkgs)[i]
    path <- pkgs[[i]]

    get_pkg_branches <- system2(
      "cd",
      args = c(path, paste("&& git branch")),
      stdout = TRUE
    )

    get_pkg_branches <- trimws(gsub("^\\*", "", get_pkg_branches))

    if (!is.null(branch_name)) {
      for (branch in branch_name) {
        if (branch %in% get_pkg_branches) {
          cat(paste0("\033[0;92m", branch, " branch exist in ", pkg, "\033[0m\n"))

          system2(
            "cd",
            args = c(path, paste("&& git checkout", branch)),
            stdout = FALSE,
            stderr = FALSE
          )

          break
        } else {
          cat(paste0("\033[0;91m", branch, " branch doesn't exist in ", pkg, "\033[0m\n"))
        }
      }
    }

    branch <- system2(
      "cd",
      args = c(path, "&& git branch --show-current"),
      stdout = TRUE
    )

    cat(
      sprintf(
        "Load \033[0;94m%s\033[0m from the \033[0;92m%s\033[0m branch.\n",
        pkg, branch
      )
    )

    if (git_pull) {
      #  Check if there's remote
      check_remote <- system2(
        "cd",
        args = c(path, "&& git ls-remote origin"),
        stdout = FALSE,
        stderr = FALSE
      )

      if (!check_remote) {
        cat("\033[0;96mRemote URL exists...\033[0m\n")
        cat("\033[0;96mPerforming git pull...\033[0m\n")
        system2(
          "cd",
          args = c(path, "&& git pull"),
          stdout = FALSE,
          stderr = FALSE
        )
      } else {
        cat("Remote URL does not exist...\n")
        cat("Skipping git pull...\n")
      }
    }

    load_all(path)
    cat("\n")
  }
}
