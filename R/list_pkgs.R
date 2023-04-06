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
  pkgs <- getOption("multiloadr", NULL)
  if (is.null(pkgs)) {
    message("No packages to list.")
    invisible()
  }
  for (i in seq_along(pkgs)) {
    pkg <- names(pkgs)[i]
    path <- pkgs[[i]]
    branch <- system(
      paste("cd", path, "&& git branch --show-current"), intern = TRUE
    )
    cat(
      sprintf(
        "Package Name: \033[0;94m%s\033[0m\nPath: %s\nCurrently in \033[0;92m%s\033[0m branch.\n\n",
        pkg, path, branch
      )
    )
  }
  invisible()
}
