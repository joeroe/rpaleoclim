## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

There was 1 NOTE:

** checking dependencies in R code ... NOTE
   Namespace in Imports field not imported from: 'rgdal'

rgdal is a suggested dependency of raster which is required for 
to read geoTIFFs with raster::raster(), and this functionality is used in
rpaleoclim::load_paleoclim().
