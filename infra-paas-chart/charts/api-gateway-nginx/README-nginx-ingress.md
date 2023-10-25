# nginx-ingress

[nginx-ingress](https://github.com/kubernetes/ingress-nginx) is an Ingress controller that uses ConfigMap to store the nginx configuration.

To use, add the `kubernetes.io/ingress.class: nginx` annotation to your Ingress resources.

## TL;DR;

```console
$  helm install --name nginx-api-gateway-service .
```

## Introduction

This chart bootstraps an nginx-ingress deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites
  - Kubernetes 1.6+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release nginx-ingress
```

The command deploys nginx-ingress on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the nginx-ingress chart and their default values.

Parameter | Description | Default
--- | --- | ---
`apigateway.controller.name` | name of the controller component | `controller`
`global.registry` | local docker registry location | `docker-repository:8082/`
`global.imagePullSecret.create` | If to use name of Secret resource containing private registry credentials | `true`
`global.imagePullSecret.name` | Name of the Secret | `registrykey`
`global.imagePullSecret.encodedsecret` | 64bit encoded dockerJson file | `ew0KICAgICAgICAiYXV0aHMiOiB7DQogICAgICAgICAgICAgICAgImRvY2tlci1yZXBvc2l0b3J5OjgwODIiOiB7DQogICAgICAgICAgICAgICAgICAgICAgICAiYXV0aCI6ICJZV1J0YVc0NllXUnRhVzR4TWpNPSINCiAgICAgICAgICAgICAgICB9DQogICAgICAgIH0NCn0`
`apigateway.controller.image.repository` | controller container image repository | `quay.io/kubernetes-ingress-controller/nginx-ingress-controller`
`apigateway.controller.image.tag` | controller container image tag | `0.24.1`
`apigateway.controller.image.pullPolicy` | controller container image pull policy | `IfNotPresent`
`apigateway.controller.image.runAsUser` | User ID of the controller process. Value depends on the Linux distribution used inside of the container image. By default uses debian one. | `33`
`apigateway.controller.config` | nginx ConfigMap entries | none
`apigateway.controller.hostNetwork` | If the nginx deployment / daemonset should run on the host's network namespace. Do not set this when `apigateway.controller.service.externalIPs` is set and `kube-proxy` is used as there will be a port-conflict for port `80` | false
`apigateway.controller.defaultBackendService` | default 404 backend service; required only if `apigateway.defaultBackend.enabled = false` | `""`
`apigateway.controller.dnsPolicy` | If using `hostNetwork=true`, change to `ClusterFirstWithHostNet`. See [pod's dns policy](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy) for details | `ClusterFirst`
`apigateway.controller.electionID` | election ID to use for the status update | `ingress-controller-leader`
`apigateway.controller.extraEnvs` | any additional environment variables to set in the pods | `{}`
`apigateway.controller.extraContainers` | Sidecar containers to add to the controller pod. See [LemonLDAP::NG controller](https://github.com/lemonldap-ng-controller/lemonldap-ng-controller) as example | `{}`
`apigateway.controller.extraVolumeMounts` | Additional volumeMounts to the controller main container | `{}`
`apigateway.controller.extraVolumes` | Additional volumes to the controller pod | `{}`
`apigateway.controller.extraInitContainers` | Containers, which are run before the app containers are started | `[]`
`apigateway.controller.ingressClass` | name of the ingress class to route through this controller | `nginx`
`apigateway.controller.scope.enabled` | limit the scope of the ingress controller | `false` (watch all namespaces)
`apigateway.controller.scope.namespace` | namespace to watch for ingress | `""` (use the release namespace)
`apigateway.controller.extraArgs` | Additional controller container arguments | `{}`
`apigateway.controller.kind` | install as Deployment or DaemonSet | `Deployment`
`apigateway.controller.daemonset.useHostPort` | If `apigateway.controller.kind` is `DaemonSet`, this will enable `hostPort` for TCP/80 and TCP/443 | false
`apigateway.controller.daemonset.hostPorts.http` | If `apigateway.controller.daemonset.useHostPort` is `true` and this is non-empty, it sets the hostPort | `"80"`
`apigateway.controller.daemonset.hostPorts.https` | If `apigateway.controller.daemonset.useHostPort` is `true` and this is non-empty, it sets the hostPort | `"443"`
`apigateway.controller.daemonset.hostPorts.stats` | If `apigateway.controller.daemonset.useHostPort` is `true` and this is non-empty, it sets the hostPort | `"18080"`
`apigateway.controller.tolerations` | node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`apigateway.controller.affinity` | node/pod affinities (requires Kubernetes >=1.6) | `{}`
`apigateway.controller.minReadySeconds` | how many seconds a pod needs to be ready before killing the next, during update | `0`
`apigateway.controller.nodeSelector` | node labels for pod assignment | `{}`
`apigateway.controller.podAnnotations` | annotations to be added to pods | `{}`
`apigateway.controller.podLabels` | labels to add to the pod container metadata | `{}`
`apigateway.controller.replicaCount` | desired number of controller pods | `1`
`apigateway.controller.minAvailable` | minimum number of available controller pods for PodDisruptionBudget | `1`
`apigateway.controller.resources` | controller pod resource requests & limits | `{}`
`apigateway.controller.priorityClassName` | controller priorityClassName | `nil`
`apigateway.controller.lifecycle` | controller pod lifecycle hooks | `{}`
`apigateway.controller.service.annotations` | annotations for controller service | `{}`
`apigateway.controller.service.labels` | labels for controller service | `{}`
`apigateway.controller.publishService.enabled` | if true, the controller will set the endpoint records on the ingress objects to reflect those on the service | `false`
`apigateway.controller.publishService.pathOverride` | override of the default publish-service name | `""`
`apigateway.controller.service.clusterIP` | internal controller cluster service IP | `""`
`apigateway.controller.service.externalIPs` | controller service external IP addresses. Do not set this when `apigateway.controller.hostNetwork` is set to `true` and `kube-proxy` is used as there will be a port-conflict for port `80` | `[]`
`apigateway.controller.service.externalTrafficPolicy` | If `apigateway.controller.service.type` is `NodePort` or `LoadBalancer`, set this to `Local` to enable [source IP preservation](https://kubernetes.io/docs/tutorials/services/source-ip/#source-ip-for-services-with-typenodeport) | `"Cluster"`
`apigateway.controller.service.healthCheckNodePort` | If `apigateway.controller.service.type` is `NodePort` or `LoadBalancer` and `apigateway.controller.service.externalTrafficPolicy` is set to `Local`, set this to [the managed health-check port the kube-proxy will expose](https://kubernetes.io/docs/tutorials/services/source-ip/#source-ip-for-services-with-typenodeport). If blank, a random port in the `NodePort` range will be assigned | `""`
`apigateway.controller.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`apigateway.controller.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`apigateway.controller.service.enableHttp` | if port 80 should be opened for service | `true`
`apigateway.controller.service.enableHttps` | if port 443 should be opened for service | `true`
`apigateway.controller.service.targetPorts.http` | Sets the targetPort that maps to the Ingress' port 80 | `80`
`apigateway.controller.service.targetPorts.https` | Sets the targetPort that maps to the Ingress' port 443 | `443`
`apigateway.controller.service.type` | type of controller service to create | `NodePort`
`apigateway.controller.service.nodePorts.http` | If `apigateway.controller.service.type` is `NodePort` and this is non-empty, it sets the nodePort that maps to the Ingress' port 80 | `30007`
`apigateway.controller.service.nodePorts.https` | If `apigateway.controller.service.type` is `NodePort` and this is non-empty, it sets the nodePort that maps to the Ingress' port 443 | `30008`
`apigateway.controller.livenessProbe.initialDelaySeconds` | Delay before liveness probe is initiated | 10
`apigateway.controller.livenessProbe.periodSeconds` | How often to perform the probe | 10
`apigateway.controller.livenessProbe.timeoutSeconds` | When the probe times out | 5
`apigateway.controller.livenessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful after having failed. | 1
`apigateway.controller.livenessProbe.failureThreshold` | Minimum consecutive failures for the probe to be considered failed after having succeeded. | 3
`apigateway.controller.livenessProbe.port` | The port number that the liveness probe will listen on. | 10254
`apigateway.controller.readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated | 10
`apigateway.controller.readinessProbe.periodSeconds` | How often to perform the probe | 10
`apigateway.controller.readinessProbe.timeoutSeconds` | When the probe times out | 1
`apigateway.controller.readinessProbe.successThreshold` | Minimum consecutive successes for the probe to be considered successful after having failed. | 1
`apigateway.controller.readinessProbe.failureThreshold` | Minimum consecutive failures for the probe to be considered failed after having succeeded. | 3
`apigateway.controller.readinessProbe.port` | The port number that the readiness probe will listen on. | 10254
`apigateway.controller.stats.enabled` | if `true`, enable "vts-status" page | `false`
`apigateway.controller.stats.service.annotations` | annotations for controller stats service | `{}`
`apigateway.controller.stats.service.clusterIP` | internal controller stats cluster service IP | `""`
`apigateway.controller.stats.service.externalIPs` | controller service stats external IP addresses | `[]`
`apigateway.controller.stats.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`apigateway.controller.stats.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`apigateway.controller.stats.service.type` | type of controller stats service to create | `ClusterIP`
`apigateway.controller.metrics.enabled` | if `true`, enable Prometheus metrics (`apigateway.controller.stats.enabled` must be `true` as well) | `false`
`apigateway.controller.metrics.service.annotations` | annotations for Prometheus metrics service | `{}`
`apigateway.controller.metrics.service.clusterIP` | cluster IP address to assign to service | `""`
`apigateway.controller.metrics.service.externalIPs` | Prometheus metrics service external IP addresses | `[]`
`apigateway.controller.metrics.service.labels` | labels for metrics service | `{}`
`apigateway.controller.metrics.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`apigateway.controller.metrics.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`apigateway.controller.metrics.service.servicePort` | Prometheus metrics service port | `9913`
`apigateway.controller.metrics.service.type` | type of Prometheus metrics service to create | `ClusterIP`
`apigateway.controller.metrics.serviceMonitor.enabled` | Set this to `true` to create ServiceMonitor for Prometheus operator | `false`
`apigateway.controller.metrics.serviceMonitor.additionalLabels` | Additional labels that can be used so ServiceMonitor will be discovered by Prometheus | `{}`
`apigateway.controller.metrics.serviceMonitor.namespace` | namespace where servicemonitor resource should be created | `the same namespace as nginx ingress`
`apigateway.controller.customTemplate.configMapName` | configMap containing a custom nginx template | `""`
`apigateway.controller.customTemplate.configMapKey` | configMap key containing the nginx template | `""`
`apigateway.controller.headers` | configMap key:value pairs containing the [custom headers](https://github.com/kubernetes/ingress-nginx/tree/master/docs/examples/customization/custom-headers) for Nginx | `{}`
`apigateway.controller.updateStrategy` | allows setting of RollingUpdate strategy | `{}`
`apigateway.defaultBackend.enabled` | If false, apigateway.controller.defaultBackendService must be provided | `true`
`apigateway.defaultBackend.name` | name of the default backend component | `default-backend`
`apigateway.defaultBackend.image.repository` | default backend container image repository | `k8s.gcr.io/defaultbackend`
`apigateway.defaultBackend.image.tag` | default backend container image tag | `1.4`
`apigateway.defaultBackend.image.pullPolicy` | default backend container image pull policy | `IfNotPresent`
`apigateway.defaultBackend.extraArgs` | Additional default backend container arguments | `{}`
`apigateway.defaultBackend.port` | Http port number | `8080`
`apigateway.defaultBackend.tolerations` | node taints to tolerate (requires Kubernetes >=1.6) | `[]`
`apigateway.defaultBackend.affinity` | node/pod affinities (requires Kubernetes >=1.6) | `{}`
`apigateway.defaultBackend.nodeSelector` | node labels for pod assignment | `{}`
`apigateway.defaultBackend.podAnnotations` | annotations to be added to pods | `{}`
`apigateway.defaultBackend.podLabels` | labels to add to the pod container metadata | `{}`
`apigateway.defaultBackend.replicaCount` | desired number of default backend pods | `1`
`apigateway.defaultBackend.minAvailable` | minimum number of available default backend pods for PodDisruptionBudget | `1`
`apigateway.defaultBackend.resources` | default backend pod resource requests & limits | `{}`
`apigateway.defaultBackend.priorityClassName` | default backend  priorityClassName | `nil`
`apigateway.defaultBackend.service.annotations` | annotations for default backend service | `{}`
`apigateway.defaultBackend.service.clusterIP` | internal default backend cluster service IP | `""`
`apigateway.defaultBackend.service.externalIPs` | default backend service external IP addresses | `[]`
`apigateway.defaultBackend.service.loadBalancerIP` | IP address to assign to load balancer (if supported) | `""`
`apigateway.defaultBackend.service.loadBalancerSourceRanges` | list of IP CIDRs allowed access to load balancer (if supported) | `[]`
`apigateway.defaultBackend.service.type` | type of default backend service to create | `ClusterIP`
`apigateway.rbac.create` | if `true`, create & use RBAC resources | `true`
`apigateway.podSecurityPolicy.enabled` | if `true`, create & use Pod Security Policy resources | `false`
`apigateway.serviceAccount.create` | if `true`, create a service account | ``
`apigateway.serviceAccount.name` | The name of the service account to use. If not set and `create` is `true`, a name is generated using the fullname template. | ``
`apigateway.revisionHistoryLimit` | The number of old history to retain to allow rollback. | `10`
`apigateway.tcp` | TCP service key:value pairs | `{}`
`apigateway.udp` | UDP service key:value pairs | `{}`
Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install nginx-ingress --name my-release -f values.yaml
```

A useful trick to debug issues with ingress is to increase the logLevel
as described [here](https://github.com/kubernetes/ingress-nginx/blob/master/docs/troubleshooting.md#debug)

```console
$ helm install nginx-ingress --set apigateway.controller.extraArgs.v=2
```
> **Tip**: You can use the default [values.yaml](../values.yaml)

## PodDisruptionBudget
Note that the PodDisruptionBudget resource will only be defined if the replicaCount is greater than one,
else it would make it impossible to evacuate a node. See [gh issue #7127](https://github.com/helm/charts/issues/7127) for more info.

## Prometheus Metrics

The Nginx ingress controller can export Prometheus metrics. In order for this to work, the VTS dashboard must be enabled as well.

```console
$ helm install nginx-ingress --name my-release \
    --set apigateway.controller.stats.enabled=true \
    --set apigateway.controller.metrics.enabled=true
```

You can add Prometheus annotations to the metrics service using `apigateway.controller.metrics.service.annotations`. Alternatively, if you use the Prometheus Operator, you can enable ServiceMonitor creation using `apigateway.controller.metrics.serviceMonitor.enabled`.

## ExternalDNS Service configuration

Add an [ExternalDNS](https://github.com/kubernetes-incubator/external-dns) annotation to the LoadBalancer service:

```yaml
annotations:
  external-dns.alpha.kubernetes.io/hostname: kubernetes-example.com.
```

## Use your own docker private registry location

```console
$ helm install nginx-ingress --name my-release \
    --set global.imagePullSecret.encodedsecret=<your encoded dockerJson> \
    --set global.registry=<your-repo-location>
```

## Use your own docker private registry location but your registry needs no Secret/authentication

```console
$ helm install nginx-ingress --name my-release \
    --set global.imagePullSecret.create=false \
    --set global.registry=<your-repo-location>
```