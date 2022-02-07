#' Pretend to download a file from Paleoclim
#'
#' Used for testing. Copies a small test file to `tmpfile`.
#'
#' @noRd
#' @keywords internal
mock_download <- function(url, tmpfile, quiet) {
  if (!isTRUE(quiet)) {
    rlang::inform(
      paste0("Pretending to download <", url, "> to ", tmpfile, " ...")
    )
  }
  dummy_file <- system.file("testdata", "LH_v1_10m_cropped.zip",
                            package = "rpaleoclim",
                            mustWork = TRUE)
  fs::file_copy(dummy_file, tmpfile, overwrite = TRUE)
}
