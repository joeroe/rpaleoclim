# Load data from PaleoClim

Loads a PaleoClim data file (`.zip` format) into R as a `SpatRaster`.

## Usage

``` r
load_paleoclim(file, as = c("terra", "raster"))
```

## Arguments

- file:

  Character. Path to a \*.zip file downloaded from PaleoClim.

- as:

  Character. `as = "raster"` returns a `RasterStack` object (see
  [`raster::stack()`](https://rdrr.io/pkg/raster/man/stack.html))
  instead of the default raster from the `terra` package. It is provided
  for backwards compatibility and will be removed in future versions.
  Requires the `raster` package.

## Value

`SpatRaster` object (see
[`terra::rast()`](https://rspatial.github.io/terra/reference/rast.html))
with each bioclimatic variable as a separate named layer.

## Examples

``` r
file <- system.file("testdata", "LH_v1_10m_cropped.zip",
                    package = "rpaleoclim")
load_paleoclim(file)
#> class       : SpatRaster 
#> size        : 6, 6, 19  (nrow, ncol, nlyr)
#> resolution  : 0.1666667, 0.1666667  (x, y)
#> extent      : 0, 1, 0, 1  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 (EPSG:4326) 
#> sources     : bio_1.tif  
#>               bio_10.tif  
#>               bio_11.tif  
#>               ... and 16 more sources
#> names       : bio_1, bio_10, bio_11, bio_12, bio_13, bio_14, ... 
#> min values  :  -526,   -334,   -656,      0,      0,      0, ... 
#> max values  :   314,    385,    288,   9696,   2399,    651, ... 
```
