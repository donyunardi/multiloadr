#' Remove packages from multiloadr configuration
#'
#' This function removes specified package(s) from the `multiloadr`
#' configuration.
#'
#' @param pkg_names Character vector specifying the names of the packages to
#' remove.
#'
#' @examples rm_pkgs(c("package1", "package2"))
#'
#' @param pkg_names A character vector specifying the names of the packages
#' to remove.
#'
#' @export
rm_pkgs <- function(pkg_names) {

  pkgs <- get_multiloadr_pkgs()
  pkgs_exist <- pkg_names[pkg_names %in% names(pkgs)]
  pkgs_not_exist <- pkg_names[!pkg_names %in% pkgs_exist]

  cat(
    paste0(
      "\033[0;91mCan't find ",
      paste(pkgs_not_exist, collapse = ", "),
      " in multiloadr.\033[0m\n"
    )
  )

  if (length(pkgs_exist) >= 1) {
    cat(
      paste0(
        "Removing ",
        paste(pkgs_exist, collapse = ", "),
        " from multiloadr.\n"
      )
    )
    pkgs <- pkgs[!names(pkgs) %in% pkgs_exist]
    options(multiloadr = pkgs)
  } else {
    cat(
      paste0(
        "No package was removed from multiloadr.\n"
      )
    )
  }

}
