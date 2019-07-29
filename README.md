
# rpaleoclim: an R interface for `PaleoClim` paleoclimate data

PaleoClim \<<http://paleoclim.org>\> is a database of free, high
resolution paleoclimate surfaces covering the whole globe. It includes
the standard bioclimatic variables commonly used in ecological
modelling, downscaled from the HadCM3 general circulation model for key
time periods, at up to 2.5 minute spatial resolution.

This package provides a simple interface for downloading PaleoClim data
in R, with support for caching.

## Installation

You can install the development version of rpaleoclim from GitHub using
the [`remotes`](https://github.com/r-lib/remotes) or
[`devtools`](https://github.com/r-lib/devtools) packages:

``` r
remotes::install_github("joeroe/rpaleoclim")
```

## Usage

``` r
library("rpaleoclim")
library("raster")

lh_10m <- paleoclim("lh", "10m")
plot(lh_10m)
```

![](README_files/figure-gfm/rpaleoclim-demo-1.png)<!-- -->
