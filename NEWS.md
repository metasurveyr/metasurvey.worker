# metasurvey.worker 0.1.0

* Initial release. Server-side infrastructure for the metasurvey ecosystem,
  extracted from the `metasurvey` monolith (now
  [`metasurvey-legacy`](https://github.com/metasurveyr/metasurvey-legacy)) as
  part of the modularization suggested by the rOpenSci review. See
  `MIGRATION.md`.
* Deployable Plumber REST API (`inst/api`, MongoDB-backed) and compute worker
  (`inst/worker`) with their Dockerfiles.
* R launchers: `run_api_server()`, `run_compute_worker()`, `service_file()`.
* Not a user-facing R package; the R client lives in
  `metasurvey.explorer.backend`.
