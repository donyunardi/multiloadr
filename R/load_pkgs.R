#' Load packages and switch git branch if specified
#'
#' This code loads packages based on the multiloadr option provided. It has an
#' additional feature that allows loading packages from a particular branch if
#' specified. If not, the function will load packages from the currently active
#' branch. The function also provides an optional argument to execute a git pull
#' before loading the packages.
#'
#' @param branch_name Character string specifying the name of the git branch to
#' switch to. Defaults to \code{NULL}. In case the branch is NULL or
#' non-existent, it will be loaded from the presently active branch.
#'
#' @param git_pull A logical value indicating whether to perform a `git pull``
#' before loading the package.
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
#' # Load packages from "develop" branch
#' load_pkgs("develop")
load_pkgs <- function(branch_name = NULL, git_pull = FALSE) {

  pkgs <- get_multiloadr_pkgs()

  if (is.null(pkgs)) {
    cat("No packages to load")
    invisible()
  }

  for (i in seq_along(pkgs)) {

    pkg <- names(pkgs)[i]
    path <- pkgs[[i]]

    if (!is.null(branch_name)) {
      change_branch <- system2(
        "cd",
        args = c(path, paste("&& git checkout", branch_name)),
        stdout = FALSE,
        stderr = FALSE
      )
      if (change_branch == 1) {
        cat(paste(branch_name, "branch doesn't exist in", pkg))
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
        cat("\033[0;92mRemote URL exists...\033[0m")
        cat("\033[0;92mPerforming git pull...\033[0m")
        system2(
          "cd",
          args = c(path, "&& git pull"),
          stdout = FALSE,
          stderr = FALSE
        )
      } else {
        cat("Remote URL does not exist...")
        cat("Skipping git pull...")
      }
    }

    load_all(path)
    cat("\n")
  }
}
