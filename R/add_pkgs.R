#' Add a Package to `multiloadr`
#'
#' This function adds a package path to the `multiloadr`. In addition, this
#' function verifies the existence of the directory and ensures that it is a
#' valid R package directory before adding it to the `multiloadr` option. Once
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
#' # Add package path to `multiloadr` option
#' add_pkgs("dplyr", "/path/to/dplyr")
#'
add_pkgs <- function(pkg_name, path) {
  multiloadr <- getOption("multiloadr", NULL)
  new_entry <- setNames(list(path), noquote(pkg_name))
  pkg_exist <- pkg_name %in% names(multiloadr)

  is_valid_package <- file.exists(file.path(path, "DESCRIPTION")) &&
    file.exists(file.path(path, "man")) &&
    file.exists(file.path(path, "R")) &&
    file.exists(file.path(path, "NAMESPACE"))

  if (is_valid_package) {
    if (!is.null(multiloadr)) {
      if (pkg_exist) {
        multiloadr[[pkg_name]] <- path
      } else {
        options(multiloadr = c(as.list(multiloadr), new_entry))
      }
    } else {
      options(multiloadr = c(new_entry))
    }

    if (pkg_exist) {
      cat(
        paste0(
          "\n\033[0;91m", pkg_name,
          " already exist in multiloadr.\033[0m\n",
          "Replacing package's path.\n"
        )
      )
    } else {
      cat(paste0(
        "\n\033[0;94m", pkg_name, "\033[0m is added to multiloadr. "
      ))
    }
    cat(paste0(
      "Run `list_pkgs()` to see all packages.\n"
    ))
  } else {
    cat("Package not added to multiloadr. Directory is not an R package.\n")
  }

  invisible()
}
