{{/*
Expand the name of the chart.
*/}}
{{- define "infra.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "infra.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "infra.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "infra.labels" -}}
helm.sh/chart: {{ include "infra.chart" . }}
{{ include "infra.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "infra.selectorLabels" -}}
app.kubernetes.io/name: {{ include "infra.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "infra.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "infra.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define the datadog-env.
*/}}
{{- define "infra.dd_env" -}}
{{- $org_id := default "dummy" .Values.image.env.chartValues.ORG_ID }}
{{- printf "%s-%s" "on-prem" $org_id | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Define the datadog-tags.
*/}}
{{- define "infra.dd_tags" -}}
{{- $org_id := default "dummy" .Values.image.env.chartValues.ORG_ID }}
{{- printf "%s:%s" "org_id" $org_id | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Define the docker login json.
*/}}
{{- define "infra.regcred" -}}
{{- $jfrog_key := default "dummy" .Values.image.env.chartValues.JFROG_KEY }}
{{- printf "%s%s%s" "{ \"auths\": { \"https://linearb-on-prem.jfrog.io\": { \"username\": \"on-prem\", \"password\": \"" $jfrog_key "\" } } }"  }}
{{- end }}


{{/*
Define the proxy_pass_api_destination.
*/}}
{{- define "infra.proxy_pass_api_destination" -}}
{{- if .Values.image.env.chartValues.EXTERNAL_PROXY }}
  {{- printf "socat-socat-tunneller.linearb.svc.cluster.local:8443" }}
{{- else }}
  {{- printf .Values.image.env.chartValues.LINEARB_PUBLIC_API_HOST }}
{{- end }}
{{- end }}

{{/*
Define the minio_pv_size.
*/}}
{{- define "infra.minio_pv_size" -}}
{{- default "500Gi" .Values.image.env.chartValues.PV_SIZE }}
{{- end }}