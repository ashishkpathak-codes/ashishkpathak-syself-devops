{{- define "busybox.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{- define "busybox.fullName" -}}
{{ printf "%s-%s" (include "busybox.name" .) .Release.Name   }}
{{- end -}}

{{- define "busybox.labels" -}}
app: {{ include "busybox.name" . }}
release: {{ include "busybox.fullName" . }}
type: "backend"
{{- end -}}