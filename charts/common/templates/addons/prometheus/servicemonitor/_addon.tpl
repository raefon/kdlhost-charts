{{/*==============================================*\
     Prometheus ServiceMonitor Addon (TPL standard)
\*==============================================*/}}

{{- define "common.addon.prometheus.servicemonitor" -}}
{{- $sm := .Values.addons.prometheus.serviceMonitor -}}
{{- if $sm.enabled }}

---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ include "common.names.fullname" . }}
  namespace: {{ default .Release.Namespace $sm.namespace }}
  labels:
    app.kubernetes.io/name: {{ include "common.names.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    {{- range $key, $value := $sm.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
spec:
  selector:
    {{- if $sm.selector }}
    {{- toYaml $sm.selector | nindent 4 }}
    {{- else }}
    matchLabels:
      app.kubernetes.io/name: {{ include "common.names.name" . }}
    {{- end }}

  namespaceSelector:
    {{- if $sm.namespaceSelector }}
    {{- toYaml $sm.namespaceSelector | nindent 4 }}
    {{- else }}
    matchNames:
      - {{ default .Release.Namespace $sm.namespace }}
    {{- end }}

  endpoints:
    {{- if not $sm.endpoints }}
      {{- fail "addons.prometheus.serviceMonitor.enabled is true but addons.prometheus.serviceMonitor.endpoints is empty; please provide endpoints in values.yaml" }}
    {{- end }}
    {{- toYaml $sm.endpoints | nindent 4 }}

{{- end }}
{{- end }}
