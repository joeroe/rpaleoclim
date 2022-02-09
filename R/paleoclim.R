#' Retrieve data from PaleoClim
#'
#' Downloads data from PaleoClim (<http://paleoclim.org>) and loads it into R
#' as a `SpatRaster` object.
#'
#' @param period      Character. Time period to retrieve.
#' @param resolution  Character. Resolution to retrieve.
#' @param region      `SpatExtent` object or object that can be coerced to
#'                    `SpatExtent` (see [terra::ext()]), describing the
#'                    region to be retrieved. If `NULL`, defaults to the whole
#'                    globe.
#' @param as          Character. `as = "raster"` returns a `RasterStack` object
#'                    (see [raster::stack()]) instead of the default raster from
#'                    the `terra` package. It is provided for backwards
#'                    compatibility and will be removed in future versions.
#'                    Requires the `raster` package.
#' @param skip_cache  Logical. If `TRUE`, cached data will be ignored.
#' @param cache_path  Logical. Path to directory where downloaded files should
#'   be saved. Defaults to R's temporary directory.
#' @param quiet       Logical. If `TRUE`, suppresses messages and download
#'   progress information.
#'
#' @details
#' See <http://paleoclim.org> for details of the datasets and codings.
#' Data at 30s resolution is only available for 'cur' and 'lgm'.
#'
#' By default, `paleoclim()` will read previously downloaded files in R's
#' temporary directory if available. Use `skip_cache = TRUE` to override this.
#' `cache_path` can also be set to another directory. This can be useful if you
#' want to reuse downloaded data between sessions.
#'
#' @return
#' `SpatRaster` object (see [terra::rast()]) with each bioclimatic variable
#' as a separate named layer.
#'
#' @export
paleoclim <- function(period = c("lh", "mh", "eh", "yds", "ba", "hs1",
                                 "lig", "mis", "mpwp", "m2", "cur", "lgm"),
                      resolution = c("10m", "5m", "2_5m", "30s"),
                      region = NULL,
                      as = c("terra", "raster"),
                      skip_cache = FALSE,
                      cache_path = fs::path_temp(),
                      quiet = FALSE) {
  period <- rlang::arg_match(period)
  resolution <- rlang::arg_match(resolution)
  as <- rlang::arg_match(as)

  if (resolution == "30s" & !period %in% c("cur", "lgm")) {
    rlang::abort("Data at 30s resolution is only available for 'cur' and 'lgm'")
  }

  url <- construct_paleoclim_url(period, resolution)
  tmpfile <- fs::path(cache_path, fs::path_file(url))

  if (!fs::file_exists(tmpfile) | isTRUE(skip_cache)) {
    curl::curl_download(url, tmpfile, quiet = quiet)
  }
  else {
    if (!isTRUE(quiet)) {
      rlang::inform(
        paste0("Reading cached PaleoClim data from ", tmpfile),
        body = c(
          i = "Use `skip_cache = TRUE` to force redownload."
        )
      )
    }
  }

  raster <- load_paleoclim(tmpfile, as)

  if (!is.null(region)) {
    raster <- terra::crop(raster, region)
  }

  return(raster)
}

#' Construct PaleoClim URL
#'
#' @param period      Character. PaleoClim period code.
#' @param resolution  Character. PaleoClim resolution.
construct_paleoclim_url <- function(period, resolution) {
  base_url <- ("http://sdmtoolbox.org/paleoclim.org/data/")

  if (period %in% c("mpwp", "m2")) {
    subdir <- paste0(period, "/")
  }
  else if (period == "cur") {
    subdir <- "chelsa_cur/"
  }
  else if (period == "lgm") {
    subdir <- "chelsa_LGM/"
  }
  else {
    subdir <- paste0(toupper(period), "/")
  }

  if (period %in% c("mis19", "m2")) {
    file <- paste0(toupper(period), "_v1_r", resolution, ".zip")
  }
  else if (period == "mpwp") {
    file <- paste0("mPWP_v1_r", resolution, ".zip")
  }
  else if (period == "cur") {
    file <- paste0("CHELSA_cur_V1_2B_r", resolution, ".zip")
  }
  else if (period == "lgm") {
    file <- paste0("chelsa_LGM_v1_2B_r", resolution, ".zip")
  }
  else {
    file <- paste0(toupper(period), "_v1_", resolution, ".zip")
  }

  url <- paste0(base_url, subdir, file)

  return(url)
}

#' Load data from PaleoClim
#'
#' Loads a PaleoClim data file (`.zip` format) into R as a `SpatRaster`.
#'
#' @param file Character. Path to a *.zip file downloaded from PaleoClim.
#' @param as          Character. `as = "raster"` returns a `RasterStack` object
#'                    (see [raster::stack()]) instead of the default raster from
#'                    the `terra` package. It is provided for backwards
#'                    compatibility and will be removed in future versions.
#'                    Requires the `raster` package.
#'
#' @return
#' `SpatRaster` object (see [terra::rast()]) with each bioclimatic variable
#' as a separate named layer.
#'
#' @export
load_paleoclim <- function(file, as = c("terra", "raster")) {
  as <- rlang::arg_match(as)

  tmpdir <- fs::file_temp("paleoclim_")
  utils::unzip(file, exdir = tmpdir)

  tifs <- fs::dir_ls(tmpdir, recurse = TRUE, glob = "*.tif")
  names(tifs) <- fs::path_ext_remove(fs::path_file(tifs))

  raster <- terra::rast(tifs)

  if (as == "raster") {
    if (!requireNamespace("raster", quietly = TRUE)) {
      rlang::error(
        '`as = "raster"` requires package `raster`'
      )
    }

    rlang::warn(
      '`as = "raster"` is deprecated and will be removed in future versions of rpaleoclim',
      "rpaleoclim_raster_deprecation",
      .frequency = "once",
      .frequency_id = "rpaleoclim_raster_deprecation"
    )

    raster |>
      as.list() |>
      lapply(raster::raster) |>
      raster::stack() ->
      raster
  }

  return(raster)
}
