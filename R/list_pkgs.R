#' List packages and their paths
#'
#' This function lists the packages and their paths that have been loaded
#' using the `multiloadr` option. For each package, it also displays the
#' name of the current branch in the Git repository located at the package path.
#'
#' @return NULL if no packages are loaded.
#'
#' @export
#' @examples
#' \dontrun{
#' list_pkgs()
#' }
#'
list_pkgs <- function(){

  pkgs <- get_multiloadr_pkgs()

  if (is.null(pkgs)) {
    cat("No packages to list.")
    invisible()
  }

  for (i in seq_along(pkgs)) {

    pkg <- names(pkgs)[i]
    path <- pkgs[[i]]

    branch <- get_current_branch(path)

    head <- get_current_head(path)

    cat(paste0(
      "Package Name: \033[0;94m", pkg, "\033[0m\n",
      "Path: ", path, "\n",
      "HEAD is at \033[0;92m", head, "\033[0m.\n"
    ))

    if (!identical(branch, character(0))) {
      cat(paste0("Currently in ", branch, "branch.\n\n"))
    } else {
      cat(paste0(
        "The current branch could not be located.\n",
        "It is possible that the repository is currently in a detached HEAD state.\n\n"
      ))
    }

  }
  invisible()
}
