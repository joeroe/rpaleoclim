# Retrieve data from PaleoClim

Downloads data from PaleoClim (<http://www.paleoclim.org>) and loads it
into R as a `SpatRaster` object.

## Usage

``` r
paleoclim(
  period = c("lh", "mh", "eh", "yds", "ba", "hs1", "lig", "mis19", "mpwp", "m2", "cur",
    "lgm"),
  resolution = c("10m", "5m", "2_5m", "30s"),
  region = NULL,
  as = c("terra", "raster"),
  skip_cache = FALSE,
  cache_path = fs::path_temp(),
  quiet = FALSE
)
```

## Arguments

- period:

  Character. Time period to retrieve.

- resolution:

  Character. Resolution to retrieve.

- region:

  `SpatExtent` object or object that can be coerced to `SpatExtent` (see
  [`terra::ext()`](https://rspatial.github.io/terra/reference/ext.html)),
  describing the region to be retrieved. If `NULL`, defaults to the
  whole globe.

- as:

  Character. `as = "raster"` returns a `RasterStack` object (see
  [`raster::stack()`](https://rdrr.io/pkg/raster/man/stack.html))
  instead of the default raster from the `terra` package. It is provided
  for backwards compatibility and will be removed in future versions.
  Requires the `raster` package.

- skip_cache:

  Logical. If `TRUE`, cached data will be ignored.

- cache_path:

  Logical. Path to directory where downloaded files should be saved.
  Defaults to R's temporary directory.

- quiet:

  Logical. If `TRUE`, suppresses messages and download progress
  information.

## Value

`SpatRaster` object (see
[`terra::rast()`](https://rspatial.github.io/terra/reference/rast.html))
with each bioclimatic variable as a separate named layer.

## Details

See <http://www.paleoclim.org> for details of the datasets and codings.
Data at 30s resolution is only available for 'cur' and 'lgm'.

By default, `paleoclim()` will read previously downloaded files in R's
temporary directory if available. Use `skip_cache = TRUE` to override
this. `cache_path` can also be set to another directory. This can be
useful if you want to reuse downloaded data between sessions.

## Examples

``` r
if (FALSE) { # interactive() && curl::has_internet()
paleoclim("lh", "10m")
}
```
