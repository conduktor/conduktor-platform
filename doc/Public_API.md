# Conduktor platform Public API

## Healthcheck endpoints

### Liveness endpoint `/platform/api/modules/health/live`
Return a status 200 when platform-api http server is up.  

Curl example :
```shell
$ curl -s  http://localhost:8080/platform/api/modules/health/live | jq .
#"Ok"
```

Could be used to setup probes on kubernetes or docker-compose. 

#### docker-compose probe setup
```yaml
healthcheck:
    test: ["CMD-SHELL", "curl --fail http://localhost/platform/api/modules/health/live"]
    interval: 10s
    start_period: 120s # Leave time for the psql init scripts to run
    timeout: 5s
    retries: 3
```

#### Kubernetes liveness probe
```yaml
livenessProbe:
    httpGet:
        path: /platform/api/modules/health/live
        port: http
    initialDelaySeconds: 5
    periodSeconds: 10
    timeoutSeconds: 5
```

### Readyness/startup endpoint `/platform/api/modules/health/ready`

Return readiness of the platform and each module.
Modules status  :
- `STARTING` (initial state)
- `UP`
- `DOWN`
- `DISABLED` (disabled modules by license or manually)

This endpoint return 200 statusCode if all modules are in `UP` or `DISABLED` state.
Otherwise, return 503 ("Service Unavailable") if at least one module is in `STARTING` or `DOWN` state.

Curl example :
```shell
$ curl -s  http://localhost:8080/platform/api/modules/health/ready | jq .
#{
#  "authenticator": "DOWN",
#  "admin": "UP",
#  "console": "UP",
#  "testing": "STARTING",
#  "data_masking": "UP",
#  "monitoring": "UP",
#  "topic_analyzer": "DISABLED",
#  "topic_as_service": "DISABLED"
#}
```

#### Kubernetes startup probe
```yaml
startupProbe:
    httpGet:
        path: /platform/api/modules/health/ready
        port: http
    initialDelaySeconds: 30
    periodSeconds: 10
    timeoutSeconds: 5
    failureThreshold: 30
```

## Platform infos

### Platform versions `/platform/api/modules/versions`
This endpoint expose modules version used to build the platform along with platform current version.

Curl example :
```shell
curl -s  http://localhost:8080/platform/api/modules/versions | jq .
# {
# "platform": "1.1.2-281af34d06dd83b4551a4f8a75aed8f54285a74c",
# "devtools": "1.7.1",
# "analyser": "0.9.0",
# "governance_api": "0.11.11",
# "governance_web": "0.13.0",
# "portal": "1.66.0",
# "portal_front": "0.24.0",
# "data_masking": "0.19.0",
# "authenticator": "1.3.7",
# "home": "0.21.0",
# "monitoring": "0.30.0",
# "testing_api": "0.22.0",
# "testing_agent": "0.22.0",
# "testing_ui": "0.22.3"
# }
```
