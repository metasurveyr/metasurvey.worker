# Migrado de metasurvey-legacy · paquete metasurvey.worker
# Ver RFC-MODULARIZACION.md
# Lanzadores de los servicios Plumber desplegables (API REST y compute worker).

#' Path to a bundled deployable service
#'
#' Returns the installed path to one of the deployable services shipped in
#' `inst/`: the REST API (`"api"`) or the compute worker (`"worker"`).
#'
#' @param which Character, one of `"api"` or `"worker"`.
#' @return Character path to the service's `plumber.R` file.
#' @export
#' @examples
#' \dontrun{
#' service_file("api")
#' }
service_file <- function(which = c("api", "worker")) {
  which <- match.arg(which)
  path <- system.file(which, "plumber.R", package = "metasurvey.worker")
  if (path == "") {
    stop(
      "Service '", which, "' not found. Reinstall metasurvey.worker.",
      call. = FALSE
    )
  }
  path
}

#' Run the metasurvey REST API server (Plumber + MongoDB)
#'
#' Launches the recipe/workflow API from `inst/api/plumber.R`. Requires
#' `plumber` and `mongolite`, and a `METASURVEY_MONGO_URI` environment variable.
#'
#' @param port Integer port to listen on (default 8787).
#' @param host Character host (default "0.0.0.0" for container deployments).
#' @return Invisibly `NULL`; runs until stopped.
#' @export
#' @examples
#' \dontrun{
#' run_api_server(port = 8787)
#' }
run_api_server <- function(port = 8787, host = "0.0.0.0") {
  if (!requireNamespace("plumber", quietly = TRUE)) {
    stop("Package 'plumber' is required.", call. = FALSE)
  }
  plumber::plumb(service_file("api"))$run(port = port, host = host)
  invisible(NULL)
}

#' Run the metasurvey compute worker (Plumber + metasurvey.core)
#'
#' Launches the background compute worker from `inst/worker/plumber.R`, which
#' bakes recipes and runs workflows over private microdata. Requires `plumber`,
#' `mongolite`, and `metasurvey.core`.
#'
#' @param port Integer port to listen on (default 8788).
#' @param host Character host (default "0.0.0.0").
#' @return Invisibly `NULL`; runs until stopped.
#' @export
#' @examples
#' \dontrun{
#' run_compute_worker(port = 8788)
#' }
run_compute_worker <- function(port = 8788, host = "0.0.0.0") {
  if (!requireNamespace("plumber", quietly = TRUE)) {
    stop("Package 'plumber' is required.", call. = FALSE)
  }
  plumber::plumb(service_file("worker"))$run(port = port, host = host)
  invisible(NULL)
}
