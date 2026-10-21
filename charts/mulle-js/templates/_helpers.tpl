{{- define "mulle-js.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mulle-js.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "mulle-js.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "mulle-js.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "mulle-js.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mulle-js.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mulle-js.serverAddress" -}}
{{- if .Values.web.serverAddress }}
{{- .Values.web.serverAddress }}
{{- else if and .Values.ingress.enabled .Values.server.enabled }}
{{- printf "%s://%s%s" (ternary "wss" "ws" (not (empty .Values.ingress.tls))) .Values.ingress.host .Values.server.ingressPath }}
{{- end }}
{{- end }}

{{- define "mulle-js.webImage" -}}
{{- printf "%s:%s" .Values.web.image.repository (default .Values.web.language .Values.web.image.tag) }}
{{- end }}
