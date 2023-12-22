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
list_pkgs <- function() {
  pkgs <- get_multiloadr_pkgs()

  if (is.null(pkgs)) {
    cat("No packages to list.")
    invisible()
  }

  cat(
    paste0(
      "You have ", length(pkgs), " package(s) in multiloadr.\n"
    )
  )

  for (i in seq_along(pkgs)) {
    pkg <- names(pkgs)[i]

    path <- pkgs[[i]]

    current_branch <- get_current_branch(path)

    head <- get_current_head(path)

    cat(paste0(
      "\nPackage Name: ", package_name_color(pkg), "\n",
      "Path: ", path, "\n",
      # "HEAD is at \033[0;92m", head, "\033[0m.\n"
      "HEAD is at ", head_commit_color(head), "\n"
    ))

    if (!identical(current_branch, character(0))) {
      cat(paste0(
        "Currently in ", branch_name_color(current_branch), " branch.\n\n"
      ))
    } else {
      no_current_branch_msg()
    }
  }

  invisible()
}
