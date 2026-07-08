# Migración: metasurvey.worker

**SERVIDOR** desplegable del ecosistema metasurvey, extraído del monolito `metasurvey`
(renombrado a [`metasurvey-legacy`](https://github.com/metasurveyr/metasurvey-legacy))
como parte de la modularización sugerida por la revisión de rOpenSci. Ver
`RFC-MODULARIZACION.md` en el repo legacy.

Responsabilidad: infraestructura server-side. Un servidor REST Plumber (respaldado por
MongoDB) para almacenar recipes/workflows, y un compute worker que hornea recipes y corre
workflows sobre microdatos privados. Son **servicios desplegables** (Docker, Railway,
Cloud Run), NO un paquete R de usuario. El cliente R vive en
`metasurvey.explorer.backend`.

## Origen → destino

| Archivo aquí | Origen |
|---|---|
| `inst/api/plumber.R` + `Dockerfile`, `railway.toml`, `render.yaml`, `.env.railway` | `metasurvey-legacy/inst/api/` (server REST, mongolite/jose/digest) |
| `inst/worker/plumber.R` + `Dockerfile` | `metasurvey-legacy/inst/worker/` (compute; `library(metasurvey)` → `library(metasurvey.core)`) |
| `inst/scripts/setup_mongodb.js`, `seed_ech_recipes.R` | idem (bootstrap del registro; `system.file(..., "metasurvey")` → `"metasurvey.worker"`) |
| `inst/seed-data/{recipes,workflows,users,indicators}.json` | idem (semillas del registro) |
| `R/run_services.R` | **nuevo** — `run_api_server()`, `run_compute_worker()`, `service_file()` para lanzar los servicios desde R |

## Cambios aplicados

- `inst/worker/plumber.R`: `library(metasurvey)` → `library(metasurvey.core)` (el motor
  local ahora es core). El worker usa `add_weight`, `bake_steps`, `workflow()`.
- `inst/worker/Dockerfile`: instala `metasurveyr/metasurvey.core` (antes `metasurveyr/metasurvey`),
  con `dependencies = TRUE`.
- `inst/scripts/seed_ech_recipes.R`: fallback `system.file` apunta a `metasurvey.worker`.
- `.Rbuildignore`: excluye `inst/seed-data` (5.3 MB, `recipes.json`; se usa desde el
  checkout del repo al desplegar, no desde el paquete instalado) y los archivos ocultos
  `.dockerignore`/`.env.railway` (assets de deploy, no del paquete R).

## Nota: `inst/api/plumber.R` no usa el core

El servidor REST es CRUD puro sobre MongoDB (mongolite/jose/digest); NO llama a
`metasurvey.core`. Solo el compute worker (`inst/worker`) depende de core.

## Dependencias

Todo en **Suggests** (son deps de los servicios, no de un paquete R de usuario):
`metasurvey.core`, `plumber`, `mongolite`, `jose`, `digest`, `jsonlite`, `survey`,
`data.table`.

R CMD check: 0 errors, 0 warnings, 0 notes. Tests: 7 pass (launchers).
