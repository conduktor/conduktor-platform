# Warning

This is just a demo of a simplified helm chart and this is not ment to be used in production.

# How to run the demo ?
Run the following commands
```sh
helm dependency update
helm install -f demo-platform-config.yaml platform .
```

This will run :
 * a local kafka/zookeeper (single node)
 * a postgres (unused at the stage, but will be used as an example of external db config)
 * Condutkor Platform

Open http://localhost and login with the follinwg credentials and you should access to a local Conduktor Platform demo environment in your k8s environement:
* Login: `admin@foobar.io`
* Password: `password`

# Using nginx as an ingress

```
platform:
  ingress:
    annotations:
      nginx.ingress.kubernetes.io/rewrite-target: /
      # https://kubernetes.github.io/ingress-nginx/user-guide/miscellaneous/#websockets
      nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"
      nginx.ingress.kubernetes.io/proxy-send-timeout: "3600"
```