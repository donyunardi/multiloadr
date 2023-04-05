#' Reset the multiloadr option to NULL
#'
#' This function resets the multiloadr option to NULL, effectively removing all previously loaded
#' packages.
#'
#' @examples
#' reset_multiloadr()
#'
#' @export
reset_multiloadr <- function() {
  options(multiloadr = NULL)
}
