#' Reset the `multiloadr` option to NULL
#'
#' This function resets the `multiloadr` option to NULL, effectively removing all
#' previously loaded packages.
#'
#' @examples
#' reset_multiloadr()
#'
#' @export
reset_multiloadr <- function() {
  options(multiloadr = NULL)
  cat("\033[0;92mReminder: Please restart your R session to apply the changes.\033[0m\n")
  invisible()
}
