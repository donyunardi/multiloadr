#' Add a package path to the multiloadr options
#'
#' This function adds a package path to the `multiloadr` option, which allows R
#' to load multiple packages in a single session. The `multiloadr` option is a
#' named list of package paths, where the name of each entry corresponds to the
#' package name.
#'
#' @param pkg_name The name of the package to add.
#' @param path The path to the package.
#'
#' @return This function is called for its side effects.
#'
#' @export
#'
#' @examples
#' # Add package path to multiloadr option
#' add_pkgs("dplyr", "/path/to/dplyr")
#'
#' # Retrieve package path from multiloadr option
#' getOption("multiloadr")$dplyr
add_pkgs <- function(pkg_name, path) {

  multiloadr <- getOption("multiloadr", NULL)
  new_entry <- setNames(list(path), noquote(pkg_name))

  if (!is.null(multiloadr)) {
    options(multiloadr = c(as.list(multiloadr), new_entry))
  } else {
    options(multiloadr = c(new_entry))
  }

}
