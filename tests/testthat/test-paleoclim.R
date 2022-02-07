test_that('paleoclim files can be read as rasters', {
  expect_error(pc <- load_paleoclim(testfile), NA)
  expect_s4_class(pc, "Raster")
})

test_that('paleoclim() returns a raster without error', {
  mockery::stub(paleoclim, "curl::curl_download", mock_download)
  expect_error(pc <- paleoclim("lh", "10m"), NA)
  expect_s4_class(pc, "Raster")
})

test_that('quiet means quiet', {
  mockery::stub(paleoclim, "curl::curl_download", mock_download)
  expect_silent(paleoclim("lh", "10m", quiet = TRUE))
})
