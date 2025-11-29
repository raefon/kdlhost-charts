{{- if and .Values.addons.prometheus ( .Values.addons.prometheus.serviceMonitor.enabled ) -}}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ include "common.fullname" . }}-servicemonitor
  labels:
{{- with .Values.addons.prometheus.serviceMonitor.labels }}
{{ toYaml . | indent 4 }}
{{- else }}
    app.kubernetes.io/name: {{ .Chart.Name | quote }}
    app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}
{{- if .Values.addons.prometheus.serviceMonitor.namespace }}
  namespace: {{ .Values.addons.prometheus.serviceMonitor.namespace }}
{{- end }}
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ .Chart.Name }}
      app.kubernetes.io/instance: {{ .Release.Name }}
  namespaceSelector:
{{- if .Values.addons.prometheus.serviceMonitor.namespace }}
    matchNames:
      - {{ .Values.addons.prometheus.serviceMonitor.namespace }}
{{- else }}
    any: true
{{- end }}
  endpoints:
{{- $defaultInterval := .Values.addons.prometheus.serviceMonitor.interval | default "30s" }}
{{- $defaultTimeout := .Values.addons.prometheus.serviceMonitor.scrapeTimeout | default "10s" }}
{{- range $i, $ep := .Values.addons.prometheus.serviceMonitor.endpoints }}
  - {{- if $ep.port }}port: {{ $ep.port }}{{- end }}
    {{- if $ep.targetPort }}targetPort: {{ $ep.targetPort }}{{- end }}
    {{- if $ep.path }}path: {{ $ep.path }}{{- end }}
    interval: {{ $ep.interval | default $defaultInterval }}
    scrapeTimeout: {{ $ep.scrapeTimeout | default $defaultTimeout }}
    {{- if $ep.scheme }}scheme: {{ $ep.scheme }}{{- end }}
    {{- if $ep.params }}
    params:
{{ toYaml $ep.params | indent 6 }}
    {{- end }}
{{- end }}
{{- end }}