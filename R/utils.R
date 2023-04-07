#' Get multiloadr packages
#'
#' This internal function retrieves multiloadr packages from options settings.
#'
#' @return A character vector containing the names of the multiloadr packages.
#'
#' @keywords internal
#' @noRd
get_multiloadr_pkgs <- function() {
  getOption("multiloadr", NULL)
}
