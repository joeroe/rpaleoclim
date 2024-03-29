% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/paleoclim.R
\name{load_paleoclim}
\alias{load_paleoclim}
\title{Load data from PaleoClim}
\usage{
load_paleoclim(file, as = c("terra", "raster"))
}
\arguments{
\item{file}{Character. Path to a *.zip file downloaded from PaleoClim.}

\item{as}{Character. \code{as = "raster"} returns a \code{RasterStack} object
(see \code{\link[raster:stack]{raster::stack()}}) instead of the default raster from
the \code{terra} package. It is provided for backwards
compatibility and will be removed in future versions.
Requires the \code{raster} package.}
}
\value{
\code{SpatRaster} object (see \code{\link[terra:rast]{terra::rast()}}) with each bioclimatic variable
as a separate named layer.
}
\description{
Loads a PaleoClim data file (\code{.zip} format) into R as a \code{SpatRaster}.
}
\examples{
file <- system.file("testdata", "LH_v1_10m_cropped.zip",
                    package = "rpaleoclim")
load_paleoclim(file)
}
