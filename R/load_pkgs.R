#' Load packages and switch git branch if specified
#'
#' This function loads packages specified in the \code{multiloadr} option and
#' switches to a specified git branch if provided.
#'
#' @param branch_name Character string specifying the name of the git branch to
#' switch to. Defaults to \code{NULL}. In case the branch is NULL or
#' non-existent, it will be loaded from the presently active branch.
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
load_pkgs <- function(branch_name = NULL) {

  pkgs <- getOption("multiloadr", NULL)

  if (is.null(pkgs)) {
    message("No packages to load")
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
        message(paste(branch_name, "branch doesn't exist in", pkg))
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

    system2(
      "cd",
      args = c(path, "&& git pull"),
      stdout = FALSE,
      stderr = FALSE
    )

    load_all(path)
    cat("\n")
  }
}
