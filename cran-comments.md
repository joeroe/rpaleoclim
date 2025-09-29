## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release addressing the build error 
*
* There was one note:

  Found the following (possibly) invalid URLs:
    URL: https://chelsa-climate.org/
      From: inst/doc/rpaleoclim.html
      Status: Error
      Message: libcurl error code 60:
        	SSL certificate problem: unable to get local issuer certificate
        	(Status without verification: Forbidden)
    URL: https://gdal.org/
      From: inst/doc/rpaleoclim.html
      Status: Error
      Message: libcurl error code 6:
        	Could not resolve host: gdal.org
    URL: https://proj.org/
      From: inst/doc/rpaleoclim.html
      Status: Error
      Message: libcurl error code 6:
        	Could not resolve host: proj.org
  
  I have double-checked that all three URLs are correct so I assume that this is
  either an issue with my local DNS or a temporary SSL problem on their end.
