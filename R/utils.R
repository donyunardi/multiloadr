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

#' Get current branch
#'
#' This internal function get current branch from a repo
#'
#' @return A character vector containing the names of the branch.
#'
#' @keywords internal
#' @noRd
get_current_branch <- function(path) {
  system2(
    "cd",
    args = c(path, "&& git branch --show-current"),
    stdout = TRUE
  )
}

#' Get current HEAD
#'
#' This internal function get current HEAD from a repo
#'
#' @return A character vector containing the commit hash and message
#'
#' @keywords internal
#' @noRd
get_current_head <- function(path) {
  system2(
    "cd",
    args = c(path, "&& git show --summary --oneline HEAD"),
    stdout = TRUE
  )
}
