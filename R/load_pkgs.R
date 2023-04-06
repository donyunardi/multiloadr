#' Load packages listed in the multiloadr option
#'
#' This function loads packages listed in the multiloadr option using the
#' \code{devtools::load_all()} function.
#'
#' @examples
#' load_pkgs()
#'
#' @export
load_pkgs <- function() {
  pkgs <- getOption("multiloadr", NULL)
  if (is.null(pkgs)) {
    message("No packages to load")
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
        "Load \033[0;94m%s\033[0m from the \033[0;92m%s\033[0m branch.\n",
        pkg, branch
      )
    )
    load_all(path)
  }
}
