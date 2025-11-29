{{/*==============================================*\
     Prometheus ServiceMonitor Addon (TPL standard)
\*==============================================*/}}

{{- define "common.addon.prometheus.servicemonitor" -}}
{{- $sm := .Values.addons.prometheus.serviceMonitor -}}
{{- if $sm.enabled }}

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
    matchLabels:
      app.kubernetes.io/name: {{ include "common.names.name" . }}
  namespaceSelector:
    matchNames:
      - {{ .Release.Namespace }}
  endpoints:
    {{- if $sm.endpoints }}
    {{- toYaml $sm.endpoints | nindent 4 }}
    {{- else }}
    - port: metrics
      interval: {{ $sm.interval | default "30s" }}
      scrapeTimeout: {{ $sm.scrapeTimeout | default "10s" }}
    {{- end }}

{{- end }}
{{- end }}
