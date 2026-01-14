# Changelog

## rpaleoclim (development version)

- Added `CITATION.cff` file with software citation metadata
  ([\#24](https://github.com/joeroe/rpaleoclim/issues/24))

## rpaleoclim 1.1.0

CRAN release: 2025-09-30

- Failed downloads (e.g. due to server errors) now return `NA` and a
  warning, instead of causing an error
- ‘Getting started’ vignette is now precompiled so that building the
  package does generate a request to the Paleoclim data server
  ([\#20](https://github.com/joeroe/rpaleoclim/issues/20))

## rpaleoclim 1.0.1

CRAN release: 2023-08-09

- Removed suggested dependency on rgdal
  ([\#18](https://github.com/joeroe/rpaleoclim/issues/18))
  - raster (\>= 3.5.1) now uses terra (\>= 1.5-12) for linking to GDAL
  - rgdal is retired and will be removed from CRAN in October 2023:
    <https://r-spatial.org/r/2022/04/12/evolution.html>

## rpaleoclim 1.0.0

CRAN release: 2023-04-28

- Added an introductory vignette
- Migrated from `raster` to `terra`:
  - [`paleoclim()`](http://joeroe.io/rpaleoclim/reference/paleoclim.md)
    and
    [`load_paleoclim()`](http://joeroe.io/rpaleoclim/reference/load_paleoclim.md)
    now return a
    [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
    instead of a
    [`raster::raster`](https://rdrr.io/pkg/raster/man/raster.html).
  - `paleoclim(as = "raster")` and `load_paleoclim(as = "raster")` are
    provided for backwards compatibility. These require `raster` to be
    installed and will be removed in future versions.
  - The `region` argument of
    [`paleoclim()`](http://joeroe.io/rpaleoclim/reference/paleoclim.md)
    now expects a
    [`terra::ext`](https://rspatial.github.io/terra/reference/ext.html)
    instead of a
    [`raster::extent`](https://rdrr.io/pkg/raster/man/extent.html).
    `extent` is coercible to `ext`, so this shouldn’t break any existing
    code.
- Fixed name of period `"mis19"` (was `"mis"`)

## rpaleoclim 0.9

- Added a `NEWS.md` file to track changes to the package.
