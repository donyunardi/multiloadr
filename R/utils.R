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
    args = c(path, "&& git symbolic-ref --short HEAD"),
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
    args = c(path, "&& git log --oneline -n 1"),
    stdout = TRUE
  )
}

#' Message for no current branch
#'
#' This internal function provides message when there is no current HEAD.
#'
#' @return A character vector containing the message about no current branch
#' @keywords internal
#' @noRd
no_current_branch_msg <- function() {
  cat(paste0(
    "\033[0;91mThe current branch could not be located.\n",
    "It is possible that the repository is currently in a detached HEAD state.\033[0m\n"
  ))
}

#' Color for package name
#'
#' This internal function provides color formatting for package name.
#' @keywords internal
#' @noRd
package_name_color <- function(x) {
  sprintf("\033[0;34m%s\033[0m", x)
}

#' Color for branch name
#'
#' This internal function provides color formatting for branch name.
#' @keywords internal
#' @noRd
branch_name_color <- function(x) {
  sprintf("\033[0;92m%s\033[0m", x)
}

#' Color for head commit
#'
#' This internal function provides color formatting for head commit.
#' @keywords internal
#' @noRd
head_commit_color <- function(x) {
  sprintf("\033[0;33m%s\033[0m", x)
}

#' Color for git action
#'
#' This internal function provides color formatting for git action.
#' @keywords internal
#' @noRd
git_action_color <- function(x) {
  sprintf("\033[0;96m%s\033[0m", x)
}
