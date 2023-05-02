# rpaleoclim (development version)

# rpaleoclim 1.0.0

* Added an introductory vignette
* Migrated from `terra` to `raster`:
  * `paleoclim()` and `load_paleoclim()` now return a `terra::SpatRaster`
    instead of a `raster::raster`.
  * `paleoclim(as = "raster")` and `load_paleoclim(as = "raster")` are provided
    for backwards compatibility. These require `raster` to be installed and will
    be removed in future versions.
  * The `region` argument of `paleoclim()` now expects a `terra::ext` instead of
    a `raster::extent`. `extent` is coercible to `ext`, so this shouldn't
    break any existing code.
* Fixed name of period `"mis19"` (was `"mis"`)

# rpaleoclim 0.9

* Added a `NEWS.md` file to track changes to the package.
