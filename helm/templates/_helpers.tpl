{{/*
Expand the name of the chart.
*/}}
{{- define "platform.name" -}}
{{-   default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "platform.chart" -}}
{{-   printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Set the running environment
*/}}
{{- define "platform.env" -}}
{{-   printf "%s" .Values.platform.env -}}
{{- end -}}

{{/*
Maintainers helper function
*/}}
{{- define "platform.maintainers" -}}
  {{- if not .Chart.Maintainers -}}
    {{- fail "Chart.yaml is missing maintainers" -}}
  {{- end -}}
  {{- range .Chart.Maintainers }}
    {{- printf "%s" (.Name | replace " " "-" | lower) -}}
  {{- end -}}
{{- end -}}

{{/*
Conduktor labels
*/}}
{{- define "platform.conduktorLabels" -}}
conduktor.io/team: {{ include "platform.maintainers" . }}
conduktor.io/app-name: {{ include "conduktor.platform.fullname" . }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "platform.labels" -}}
{{    include "platform.conduktorLabels" . }}
app.kubernetes.io/name: {{ include "platform.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ include "platform.chart" . }}
{{-   if .Values.platform.labels }}
{{-     include "common.tplvalues.render" (dict "value" .Values.platform.labels "context" $) | nindent 4 }}
{{-   end -}}
{{- end -}}

{{/*
Service selector labels
*/}}
{{- define "platform.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


{{/*
Return the proper devtools_onprem image name
*/}}
{{- define "platform.deployment.image" -}}
{{-   $repositoryName := .Values.platform.deployment.image.repository -}}
{{-   $tag := required "value platform.deployment.image.tag is required" .Values.platform.deployment.image.tag | toString -}}
{{-   printf "%s:%s" $repositoryName $tag -}}
{{- end -}}

{{/*
Create a default fully qualified app name for Platform.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "conduktor.platform.fullname" -}}
{{-   if .Values.fullnameOverride -}}
{{-     .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{-   else -}}
{{-     $name := default .Chart.Name .Values.nameOverride -}}
{{-     if contains $name .Release.Name -}}
{{-       .Release.Name | trunc 63 | trimSuffix "-" -}}
{{-     else -}}
{{-       printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{-     end -}}
{{-   end -}}
{{- end -}}

{{/*
Return backend ingress address for http(s) and ws(s)
*/}}
{{- define "platform.ingress.web" -}}
{{-   $url := .Values.platform.ingress.host -}}
{{-   if .Values.platform.ingress.tls -}}
{{-     printf "%s://%s/%s/graphql" "https" $url "api" -}}
{{-   else -}}
{{-     printf "%s://%s/%s/graphql" "http" $url "api" -}}
{{-   end -}}
{{- end -}}

{{- define "platform.ingress.websocket" -}}
{{-   $url := .Values.platform.ingress.host -}}
{{-   if .Values.platform.ingress.tls -}}
{{-     printf "%s://%s/%s/graphql" "wss" $url "ws" -}}
{{-   else -}}
{{-     printf "%s://%s/%s/graphql" "ws" $url "ws" -}}
{{-   end -}}
{{- end -}}

{{/*
Computes the kafka bootstrap server URL. Resolves to embedded kafka by default but can be
opt-out for a custom bootstrap server.
*/}}
{{- define "conduktor.platform.kafka-bootstrap-server" -}}
{{-   if .Values.kafka.enabled -}}
{{-     printf "%s-kafka.%s.svc.cluster.local:9092" .Release.Name .Release.Namespace -}}
{{-   else -}}
{{-     required "value .kafka.boostrapServers is required" .Values.kafka.bootstrapServers -}}
{{-   end -}}
{{- end -}}

{{/*
Return the platform configuration configmap contents
*/}}
{{- define "platform.config" -}}
{{- if .Values.platform.configMapRef -}}
{{-   printf "%s" (tpl .Values.platform.config $) -}}
{{- else }}
{{    required "value .platform.config is required when .platform.configMapRef is specified" .Values.platform.config }}
{{- end -}}
{{- end -}}
