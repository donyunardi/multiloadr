#'  Add a Package to `multiloadr`
#'
#' This function adds a package path to the `multiloadr`. In addition, this
#' function verifies the existence of the directory and ensures that it is a
#' valid R package directory before adding it to the multiloadr option. Once
#' confirmed, the package can then be loaded using the `load_pkgs()` function.
#'
#' @param pkg_name The name of the package to add.
#' @param path The path to the R package directory.
#'
#' @return This function is called for its side effects.
#'
#' @export
#'
#' @examples
#' # Add package path to multiloadr option
#' add_pkgs("dplyr", "/path/to/dplyr")
#'
add_pkgs <- function(pkg_name, path) {

  multiloadr <- getOption("multiloadr", NULL)
  new_entry <- setNames(list(path), noquote(pkg_name))

  if (
    file.exists(file.path(path, "DESCRIPTION")) &&
    file.exists(file.path(path, "man")) &&
    file.exists(file.path(path, "R")) &&
    file.exists(file.path(path, "NAMESPACE"))
  ) {
    if (!is.null(multiloadr)) {
      options(multiloadr = c(as.list(multiloadr), new_entry))
    } else {
      options(multiloadr = c(new_entry))
    }
    message("Package added to multiloadr. list_pkgs() to see all packages.")
  } else {
    message("Package not added to multiloadr. Directory is not an R package.")
  }

  invisible()
}
