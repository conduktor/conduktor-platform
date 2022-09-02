# What is Conduktor Platform ?

We take the complexity out of Kafka. We give you a platform to build, explore, test, monitor, and collaborate with confidence. 
Simplifying the complexity of real-time data streaming, Conduktor Platform enables leading organizations to improve team productivity and unlock true business value.


Just want to have a look? our demo environment is there : https://demo.stg.apps.cdkt.dev/


# First Steps 

## Requirements 📑

### Software : 
- **docker** : See installation instructions [here](https://docs.docker.com/engine/install/)
- **docker-compose** : See installation instructions [here](https://docs.docker.com/compose/install/)

### Hardware :
- 16 Go RAM
- 4 CPU


## Quick start 🛫

To run conduktor-platform with all feature,[contact us](https://www.conduktor.io/demo/) to get a `private beta license` !

Once you have a `license`, choose the way that fit you : 
* [run in local quick start](./example-local/README.md)
* [setup SSO with Oauth2 OpenIdConnect Identity Provider](./example-sso-oauth2/README.md)


## Platform Standalone :  

> note :  a docker-compose with a kafka cluster is at your disposal [here](./kafka/docker-compose.yml)

### Connect to a local kafka cluster accessible on `0.0.0.0:9092`
```sh
 docker run --rm \
  --network host \
  -e LICENSE_KEY="<your-license>" \
  -e KAFKA_BOOTSTRAP_SERVER=0.0.0.0:9092 \
  conduktor/conduktor-platform:latest
```

### Connect to a local kafka & Schema registry
```sh
 docker run --rm \
  --network host \
  -e LICENSE_KEY="<your-license>" \
  -e KAFKA_BOOTSTRAP_SERVER=0.0.0.0:9092 \
  -e SCHEMA_REGISTRY_URL=http://0.0.0.0:8081 \
  conduktor/conduktor-platform
```

### Run the platform with persistance between platform run
```sh
docker run --rm \
 --network host \
 -e LICENSE_KEY="<your-license>" \
 -e KAFKA_BOOTSTRAP_SERVER=0.0.0.0:9092 \
 -e SCHEMA_REGISTRY_URL=http://0.0.0.0:8081 \
 --mount "type=bind,source=$PWD/platform_data,target=/var/conduktor" \
 conduktor/conduktor-platform:latest
```

## Platform Standalone with custom configuration
Conduktor platform can be configured using an input yaml file providing configuration for
- organization
- kafka clusters
- sso (ldap/oauth2)
- license

To provide a configuration file, you can bind a local file to override `/opt/conduktor/default-platform-config.yaml`.
Or bind local file to another location and then tell conduktor-platform where is the file located inside
the container using `CDK_IN_CONF_FILE` environment variable.

For example :
`./input-config.yml` :
```yaml
organization:
 name: demo
 
clusters:
  - id: local
    name: My Local Kafka Cluster
    color: "#0013E7"
    ignoreUntrustedCertificate: false
    bootstrapServers: "some-host:9092"
    properties: |
      client.id=conduktor
      default.api.timeout.ms=5000
      request.timeout.ms=5000
     
license: "<you license key>"
```

run with :
```shell
 docker run --rm \
   --mount "type=bind,source=$PWD/input-config.yml,target=/opt/conduktor/default-platform-config.yaml" \
  conduktor/conduktor-platform:latest
```

OR using `CDK_IN_CONF_FILE` env :
```shell
 docker run --rm \
   --mount "type=bind,source=$PWD/input-config.yml,target=/etc/platform-config.yaml" \
   -e CDK_IN_CONF_FILE="/etc/platform-config.yaml" \
  conduktor/conduktor-platform:latest
```

If no configuration file is provided, a default one is used containing
```yaml
organization:
  name: default

clusters:
  - id: local
    name: My Local Kafka Cluster
    color: "#0013E7"
    ignoreUntrustedCertificate: false
    bootstrapServers: "${KAFKA_BOOTSTRAP_SERVER:-localhost:9092}"
    properties: |
      client.id=conduktor
      default.api.timeout.ms=5000
      request.timeout.ms=5000
    schemaRegistry:
      url: "${SCHEMA_REGISTRY_URL:-http://localhost:8081}"
      ignoreUntrustedCertificate: false
      properties: |
        acks=all
        client.id=conduktor
        default.api.timeout.ms=5000
        request.timeout.ms=5000
    labels:
      env: default

envs : []

auth:
  demo-users: 
    - email: admin@demo.conduktor
      password: admin
      groups:
        - ADMIN

license: ${LICENSE_KEY:-~} # Fallback to null (~)
```

> Note : input configuration support shell-like environment variable expansion with support of fallback `${VAR:-default}`.   
> In case of default configuration, env-var `KAFKA_BOOTSTRAP_SERVER`, `SCHEMA_REGISTRY_URL` and `LICENSE_KEY` can be replaced.

### Advanced configuration options

A complete configuration documentation is available [there](./Configuration.md)

## Private beta limitation ⚠️ : 
* All data & settings will be lost at the end of private beta.
* End of private beta : October 1st.
* Do not run conduktor platform against critical production environments
* No Windows support yet.
* Does not support MSK+IAM auth

## Platforms ACLs are supported on
* Open Source Apache Kafka
* MSK


