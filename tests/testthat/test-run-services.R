# Ver RFC-MODULARIZACION.md · paquete metasurvey.worker

test_that("service_file returns the api plumber path", {
  p <- service_file("api")
  expect_true(nzchar(p))
  expect_true(grepl("plumber\\.R$", p))
})

test_that("service_file returns the worker plumber path", {
  p <- service_file("worker")
  expect_true(nzchar(p))
  expect_true(grepl("plumber\\.R$", p))
})

test_that("service_file rejects unknown services", {
  expect_error(service_file("nope"))
})

test_that("run_api_server errors when plumber is unavailable", {
  local_mocked_bindings(
    requireNamespace = function(pkg, ...) pkg != "plumber",
    .package = "base"
  )
  expect_error(run_api_server(), "plumber")
})

test_that("run_compute_worker errors when plumber is unavailable", {
  local_mocked_bindings(
    requireNamespace = function(pkg, ...) pkg != "plumber",
    .package = "base"
  )
  expect_error(run_compute_worker(), "plumber")
})
