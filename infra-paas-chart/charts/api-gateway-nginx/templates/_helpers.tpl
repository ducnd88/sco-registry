{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "apigateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "apigateway.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified controller name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "apigateway.controller.fullname" -}}
{{- printf "%s-%s" (include "apigateway.fullname" .) .Values.apigateway.controller.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Construct the path for the publish-service.

By convention this will simply use the <namespace>/<controller-name> to match the name of the
service generated.

Users can provide an override for an explicit service they want bound via `.Values.apigateway.controller.publishService.pathOverride`

*/}}
{{- define "apigateway.controller.publishServicePath" -}}
{{- $defServiceName := printf "%s/%s" .Release.Namespace (include "apigateway.controller.fullname" .) -}}
{{- $servicePath := default $defServiceName .Values.apigateway.controller.publishService.pathOverride }}
{{- print $servicePath | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified default backend name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "apigateway.defaultBackend.fullname" -}}
{{- printf "%s-%s" (include "apigateway.fullname" .) .Values.apigateway.defaultBackend.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "apigateway.serviceAccountName" -}}
{{- if .Values.apigateway.serviceAccount.create -}}
    {{ default (include "apigateway.fullname" .) .Values.apigateway.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.apigateway.serviceAccount.name }}
{{- end -}}
{{- end -}}
