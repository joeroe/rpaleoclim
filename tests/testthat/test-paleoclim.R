test_that('paleoclim files can be read as rasters', {
  expect_error(pc <- load_paleoclim(testfile), NA)
  expect_s4_class(pc, "SpatRaster")
})

test_that('minimal paleoclim() returns a raster without error', {
  mockery::stub(paleoclim, "curl::curl_download", mock_download)
  expect_error(pc <- paleoclim("lh", "10m", quiet = TRUE), NA)
  expect_s4_class(pc, "SpatRaster")
})

test_that('paleoclim() shows error on invalid parameters', {
  mockery::stub(paleoclim, "curl::curl_download", mock_download)
  expect_error(paleoclim("third_age"), "period")
  expect_error(paleoclim("lh", "1cm"), "resolution")

  # 30s only supported for periods "cur" and "lgm"
  expect_error(paleoclim("cur", "30s", quiet = TRUE), NA)
  expect_error(paleoclim("lgm", "30s", quiet = TRUE), NA)
  expect_error(paleoclim("lh", "30s"), "resolution")
})

test_that('cached files are used where appropriate', {
  mockery::stub(paleoclim, "curl::curl_download", mock_download)
  # Ensure we use a clean temp directory
  tmp <- fs::path_temp(paste0("test-paleoclim-", as.numeric(Sys.time())))
  fs::dir_create(tmp)
  paleoclim("lh", "10m", cache_path = tmp, quiet = TRUE)
  expect_message(paleoclim("lh", "10m", skip_cache = FALSE, cache_path = tmp), "cache")
  expect_message(paleoclim("lh", "10m", skip_cache = TRUE, cache_path = tmp), "download")
})

test_that('paleoclim() respects cache_path', {
  mockery::stub(paleoclim, "curl::curl_download", mock_download)
  tmp <- fs::path_temp(paste0("test-paleoclim-", as.numeric(Sys.time())))
  fs::dir_create(tmp)
  filename <- fs::path_file(construct_paleoclim_url("lh", "10m"))
  paleoclim("lh", "10m", cache_path = tmp, quiet = TRUE)
  expect_true(fs::file_exists(fs::path(tmp, filename)))
})

test_that('cache status messages are controlled by `quiet`', {
  mockery::stub(paleoclim, "curl::curl_download", mock_download)
  paleoclim("lh", "10m", skip_cache = TRUE, quiet = TRUE) # Ensure cached
  expect_message(paleoclim("lh", "10m", quiet = FALSE), "cached")
  expect_silent(paleoclim("lh", "10m", quiet = TRUE))
})

test_that('download progress messages are controlled by `quiet`', {
  mockery::stub(paleoclim, "curl::curl_download", mock_download)
  expect_message(paleoclim("lh", "10m", skip_cache = TRUE, quiet = FALSE), "download")
  expect_silent(paleoclim("lh", "10m", skip_cache = TRUE, quiet = TRUE))
})

test_that('all URLs are constructed correctly', {
  # URLs checked against http://www.paleoclim.org/, 2022-02-07
  expect_equal(construct_paleoclim_url("lh", "10m"),
               "http://sdmtoolbox.org/paleoclim.org/data/LH/LH_v1_10m.zip")
  expect_equal(construct_paleoclim_url("lh", "5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/LH/LH_v1_5m.zip")
  expect_equal(construct_paleoclim_url("lh", "2_5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/LH/LH_v1_2_5m.zip")
  expect_equal(construct_paleoclim_url("mh", "10m"),
               "http://sdmtoolbox.org/paleoclim.org/data/MH/MH_v1_10m.zip")
  expect_equal(construct_paleoclim_url("mh", "5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/MH/MH_v1_5m.zip")
  expect_equal(construct_paleoclim_url("mh", "2_5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/MH/MH_v1_2_5m.zip")
  expect_equal(construct_paleoclim_url("eh", "10m"),
               "http://sdmtoolbox.org/paleoclim.org/data/EH/EH_v1_10m.zip")
  expect_equal(construct_paleoclim_url("eh", "5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/EH/EH_v1_5m.zip")
  expect_equal(construct_paleoclim_url("eh", "2_5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/EH/EH_v1_2_5m.zip")
  expect_equal(construct_paleoclim_url("yds", "10m"),
               "http://sdmtoolbox.org/paleoclim.org/data/YDS/YDS_v1_10m.zip")
  expect_equal(construct_paleoclim_url("yds", "5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/YDS/YDS_v1_5m.zip")
  expect_equal(construct_paleoclim_url("yds", "2_5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/YDS/YDS_v1_2_5m.zip")
  expect_equal(construct_paleoclim_url("ba", "10m"),
               "http://sdmtoolbox.org/paleoclim.org/data/BA/BA_v1_10m.zip")
  expect_equal(construct_paleoclim_url("ba", "5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/BA/BA_v1_5m.zip")
  expect_equal(construct_paleoclim_url("ba", "2_5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/BA/BA_v1_2_5m.zip")
  expect_equal(construct_paleoclim_url("hs1", "10m"),
               "http://sdmtoolbox.org/paleoclim.org/data/HS1/HS1_v1_10m.zip")
  expect_equal(construct_paleoclim_url("hs1", "5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/HS1/HS1_v1_5m.zip")
  expect_equal(construct_paleoclim_url("hs1", "2_5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/HS1/HS1_v1_2_5m.zip")
  expect_equal(construct_paleoclim_url("lig", "10m"),
               "http://sdmtoolbox.org/paleoclim.org/data/LIG/LIG_v1_10m.zip")
  expect_equal(construct_paleoclim_url("lig", "5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/LIG/LIG_v1_5m.zip")
  expect_equal(construct_paleoclim_url("lig", "2_5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/LIG/LIG_v1_2_5m.zip")
  expect_equal(construct_paleoclim_url("mis19", "10m"),
               "http://sdmtoolbox.org/paleoclim.org/data/MIS19/MIS19_v1_r10m.zip")
  expect_equal(construct_paleoclim_url("mis19", "5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/MIS19/MIS19_v1_r5m.zip")
  expect_equal(construct_paleoclim_url("mis19", "2_5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/MIS19/MIS19_v1_r2_5m.zip")
  expect_equal(construct_paleoclim_url("mpwp", "10m"),
               "http://sdmtoolbox.org/paleoclim.org/data/mpwp/mPWP_v1_r10m.zip")
  expect_equal(construct_paleoclim_url("mpwp", "5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/mpwp/mPWP_v1_r5m.zip")
  expect_equal(construct_paleoclim_url("mpwp", "2_5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/mpwp/mPWP_v1_r2_5m.zip")
  expect_equal(construct_paleoclim_url("m2", "10m"),
               "http://sdmtoolbox.org/paleoclim.org/data/m2/M2_v1_r10m.zip")
  expect_equal(construct_paleoclim_url("m2", "5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/m2/M2_v1_r5m.zip")
  expect_equal(construct_paleoclim_url("m2", "2_5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/m2/M2_v1_r2_5m.zip")
  expect_equal(construct_paleoclim_url("cur", "10m"),
               "http://sdmtoolbox.org/paleoclim.org/data/chelsa_cur/CHELSA_cur_V1_2B_r10m.zip")
  expect_equal(construct_paleoclim_url("cur", "5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/chelsa_cur/CHELSA_cur_V1_2B_r5m.zip")
  expect_equal(construct_paleoclim_url("cur", "2_5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/chelsa_cur/CHELSA_cur_V1_2B_r2_5m.zip")
  expect_equal(construct_paleoclim_url("cur", "30s"),
               "http://sdmtoolbox.org/paleoclim.org/data/chelsa_cur/CHELSA_cur_V1_2B_r30s.zip")
  expect_equal(construct_paleoclim_url("lgm", "10m"),
               "http://sdmtoolbox.org/paleoclim.org/data/chelsa_LGM/chelsa_LGM_v1_2B_r10m.zip")
  expect_equal(construct_paleoclim_url("lgm", "5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/chelsa_LGM/chelsa_LGM_v1_2B_r5m.zip")
  expect_equal(construct_paleoclim_url("lgm", "2_5m"),
               "http://sdmtoolbox.org/paleoclim.org/data/chelsa_LGM/chelsa_LGM_v1_2B_r2_5m.zip")
  expect_equal(construct_paleoclim_url("lgm", "30s"),
               "http://sdmtoolbox.org/paleoclim.org/data/chelsa_LGM/chelsa_LGM_v1_2B_r30s.zip")
})

test_that('raster is cropped to desired extent', {
  region <- terra::ext(0, 1, 0, 1)
  raster <- paleoclim("lh", "10m", region = region, quiet = TRUE)

  # terra crops to the nearest gridline, so allow a tolerance of one unit of
  # resolution
  expect_equal(as.vector(terra::ext(raster)),
               as.vector(region),
               tolerance = 1 / 6)
})

test_that('we are backwards compatible with raster', {
  # Can return as RasterStack
  # TODO: Remove in future version
  expect_warning(x <- paleoclim(as = "raster", quiet = TRUE),
                 class = "rpaleoclim_raster_deprecation")
  expect_s4_class(x, "RasterStack")

  # Can specify region as extent
  expect_error(paleoclim(region = raster::extent(0, 1, 0, 1), quiet = TRUE), NA)
})
