#' Retrieve data from PaleoClim
#'
#' Downloads data from PaleoClim (<http://paleoclim.org>) and loads it into R
#' as a `RasterStack` object.
#'
#' @param period      Character. Time period to retrieve.
#' @param resolution  Character. Resolution to retrieve.
#' @param region      `extent` object or object that can be coerced to `extent`
#'                    (see [raster::extent()]), describing the region to be
#'                    retrieved. If `NULL`, defaults to the whole globe.
#' @param skip_cache  Boolean. If `TRUE`, cached data will be ignored.
#'
#' @details
#'
#' See <http://paleoclim.org> for details of the datasets and codings.
#' Data at 30s resolution is only available for 'cur' and 'lgm'.
#'
#' By default, downloaded files are cached for the session to reduce server
#' load. This can be overriden with `skip_cache`.
#'
#' @return A `RasterStack` (see [raster::stack()]) object.
#'
#' @export
#'
#' @examples
#'
#' library("raster")
#'
#' lh_10m <- paleoclim("lh", "10m")
#' plot(lh_10m)
paleoclim <- function(period = c("lh", "mh", "eh", "yds", "ba", "hs1",
                                 "lig", "mis", "mpwp", "m2", "cur", "lgm"),
                      resolution = c("10m", "5m", "2_5m", "30s"),
                      region = NULL,
                      skip_cache = FALSE) {
  period <- match.arg(period)
  resolution <- match.arg(resolution)
  if (resolution == "30s" & !period %in% c("cur", "lgm")) {
    stop("Data at 30s resolution is only available for 'cur' and 'lgm'")
  }

  url <- construct_paleoclim_url(period, resolution)
  tmpfile <- fs::path_temp(fs::path_file(url))

  if (!fs::file_exists(tmpfile) | skip_cache) {
    utils::download.file(url, tmpfile, "auto")
  }

  rast <- load_paleoclim(tmpfile)

  if (!is.null(region)) {
    rast <- raster::crop(rast, region)
  }

  return(rast)
}

#' Construct PaleoClim URL
#'
#' @param period      Character. PaleoClim period code.
#' @param resolution  Character. PaleoClim resolution.
construct_paleoclim_url <- function(period, resolution) {
  base_url <- ("http://sdmtoolbox.org/paleoclim/data/")

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
#' Loads a PaleoClim data file (`.zip` format) into R as a `RasterStack` object.
#'
#' @param file Character. Path to a *.zip file downloaded from PaleoClim.
#'
#' @return `RasterStack` object (see [raster::stack()]).
#' @export
load_paleoclim <- function(file) {
  tmpdir <- fs::file_temp("paleoclim_")
  utils::unzip(file, exdir = tmpdir)

  tifs <- fs::dir_ls(tmpdir, recurse = TRUE, glob = "*.tif")
  names(tifs) <- fs::path_ext_remove(fs::path_file(tifs))
  tifs <- as.list(tifs)

  rast <- raster::stack(tifs)

  # TODO: Only if RasterStack is moved to memory?
  #fs::dir_delete(tmpdir)

  return(rast)
}
