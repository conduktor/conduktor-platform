

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