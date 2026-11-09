# Tenant chart

Version 0.4.29 includes independent `sonarr-4k`, `radarr-4k` and `rehydrator-4k`
dependency aliases. They default to disabled at chart level. kdlhost-cluster's
first-run provisioning supplies their Secret references, isolated config paths,
root folders, authentication routes and enable flags.

Keep the existing gateway and CSI WebDAV mount shared across both editions. The
4K controller needs Rehydrator 0.9.0, `library_edition: 4k`, the real tenant name,
and separate library roots. Never reuse the standard Arr config.xml files or
PostgreSQL main/log databases for the second pair.

Validate locally with `helm dependency update charts/tenet` and `helm template`.
Dependency archives and the generated lockfile are build artifacts, following
this repository's existing chart packaging workflow. Publish this chart before
reconciling the matching kdlhost-cluster base HelmRelease version.
