# common

![Version: 0.1.13](https://img.shields.io/badge/Version-0.1.13-informational?style=flat-square) ![Type: library](https://img.shields.io/badge/Type-library-informational?style=flat-square)

## TL;DR
```console
$ helm repo add kdlhost-charts https://raefon.github.io/kdlhost-charts
$ helm repo update
$ helm install common kdlhost-charts/common
```

## Creating a new chart

First be sure to checkout the many charts that already use this like [qBittorrent](../qbittorrent/), [node-red](../node-red/) or the many others in this repository.

Include this chart as a dependency in your `Chart.yaml` e.g.

```yaml
# Chart.yaml
dependencies:
  - name: common
    version: 0.1.13
    repository: https://raefon.github.io/kdlhost-charts
```
Write a `values.yaml` with some basic defaults you want to present to the user e.g.

```yaml
# Default values for node-red.

image:
  repository: nodered/node-red
  pullPolicy: IfNotPresent
  tag: 1.2.5

strategy:
  type: Recreate

# See more environment varaibles in the node-red documentation
# https://nodered.org/docs/getting-started/docker
env: {}
  # TZ:
  # NODE_OPTIONS:
  # NODE_RED_ENABLE_PROJECTS:
  # NODE_RED_ENABLE_SAFE_MODE:
  # FLOWS:

service:
  port:
    port: 1880

persistence:
  data:
    enabled: false
    emptyDir: false
    mountPath: /data
```

If not using a service, set the `service.enabled` to `false`.
```yaml
...
service:
  enabled: false
...
```

Add files to the `templates` folder.
```yaml
# templates/common.yaml
{{ include "common.all . }}

# templates/NOTES.txt
{{ include "common.notes.defaultNotes" . }}
```

If testing locally make sure you update the dependencies with:

```bash
helm dependency update
```

## Todo
- [ ] Add features from [k8s-at-home/common](https://github.com/k8s-at-home/charts/tree/master/charts/common) v2.

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.5.0](https://github.com/norwoodj/helm-docs/releases/v1.5.0)