# Conduktor Platform Configuration

- [Conduktor Platform Configuration](#conduktor-platform-configuration)
  - [Introduction](#introduction)
  - [Configuration Using Environment Variables](#configuration-using-environment-variables)
  - [Override Environment Variables](#environment-override)
- [Conduktor Platform Configuration Snippets](#conduktor-platform-configuration-snippets)
  - [Organization](#organization)
  - [Plain Auth Example](#plain-auth-example)
  - [Plain Auth With Schema Registry](#plain-auth-with-schema-registry)
  - [Amazon MSK with IAM Authentication Example](#amazon-msk-with-iam-authentication-example)
  - [Confluent Cloud Example](#confluent-cloud-example)
  - [Confluent Cloud with Schema Registry](#confluent-cloud-with-schema-registry)
  - [SSL Certificates Example - Aiven (truststore)](#ssl-certificates-example---aiven-truststore)
  - [2 Way SSL (keystore + truststore)](#2-way-ssl-keystore--truststore)
  - [Kafka Connect](#kafka-connect)
  - [SSO](#sso)
  - [OIDC](#oidc)
  - [Complete Configuration Example](#complete-configuration-example)
- [External Database Configuration](#external-database-configuration)
    - [Database requirements](#database-requirements)
    - [Setup](#setup)

## Introduction

Conduktor platform can be configured using an input yaml file providing configuration for
- organization
- external database 
- kafka clusters
- sso (ldap/oauth2)
- license

To provide a configuration file, you can bind a local file to override `/opt/conduktor/default-platform-config.yaml`.
Or bind local file to another location and then tell conduktor-platform where is the file located inside
the container using `CDK_IN_CONF_FILE` environment variable.

For example :
`./platform-config.yml` :
```yaml
organization:
  name: demo

database:
  url: postgresql://user:password@host:5432/database
  # OR in a decomposed way
  # host: "host"
  # port: 5432
  # name: "database"
  # username: "user"
  # password: "password"
  # connection_timeout: 30 # in seconds

clusters:
  - id: local
    name: "My Local Kafka Cluster"
    color: "#0013E7"
    ignoreUntrustedCertificate: false
    bootstrapServers: "some-host:9092"

auth:
  demo-users:
    - email: admin@demo.dev
      password: adminpwd
      groups:
        - ADMIN

license: "<you license key>"
```

run with :
```shell
 docker run --rm \
   --mount "type=bind,source=$PWD/platform-config.yml,target=/opt/conduktor/default-platform-config.yaml" \
  -e EMBEDDED_POSTGRES="false" \
  conduktor/conduktor-platform:1.3.1
```

OR using `CDK_IN_CONF_FILE` env :
```shell
 docker run --rm \
   --mount "type=bind,source=$PWD/platform-config.yml,target=/etc/platform-config.yaml" \
   -e CDK_IN_CONF_FILE="/etc/platform-config.yaml" \
  -e EMBEDDED_POSTGRES="false" \
  conduktor/conduktor-platform:1.3.1
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
    schemaRegistry:
      url: "${SCHEMA_REGISTRY_URL:-http://localhost:8081}"
      ignoreUntrustedCertificate: false
    labels:
      env: default
envs : []
auth:
  demo-users: 
    - email: admin@conduktor.io
      password: admin
      groups:
        - ADMIN
license: ${LICENSE_KEY:-~} # Fallback to null (~)
```

> **Note** : input configuration support **shell-like environment variable expansion** with support of fallback `${VAR:-default}`.   
>
> In case of default configuration, following environment variables can be replaced.
> - `KAFKA_BOOTSTRAP_SERVER`
> - `SCHEMA_REGISTRY_URL` 
> - `LICENSE_KEY`


## Configuration using environment variables 

| ENV | since version | until version | Default value |   | 
|-----|---------------|---------------|---------------|---|
| `RUN_MODE`          | 1.0.2 | latest | Memory presets for the platform see [ advanced settings](./Advanced_settings.md#run-mode)
| `CDK_VOLUME_DIR`    | 1.0.2 | latest | `/var/conduktor` | Volume directory where Conduktor platform store data |
| `CDK_IN_CONF_FILE`  | 1.0.2 | latest | [`/opt/conduktor/default-platform-config.yaml`](./conduktor/default-platform-config.yaml) | Conduktor platform configuration file location |
| `EMBEDDED_POSTGRES` | 1.1.2 | 1.1.3 | `true` | Flag to enabled or disable embedded Postgresql database. (Deprecated since **1.2.0**. Now if no external database is configured embedded database is used) |
| `PLATFORM_DB_URL`   | 1.1.2 | latest | None | Deprecated, use `CDK_DATABASE_URL` or decomposed external database configuration. |
| `CDK_DATABASE_URL` | 1.2.0 | latest | None | External Postgresql configuration URL in format `[jdbc:]postgresql://[user[:password]@]netloc[:port][/dbname][?param1=value1&...]`. |
| `CDK_DATABASE_HOST` | 1.2.0 | latest | None | External Postgresql server hostname |
| `CDK_DATABASE_PORT` | 1.2.0 | latest | 5432 | External Postgresql server port |
| `CDK_DATABASE_NAME` | 1.2.0 | latest | None | External Postgresql database name |
| `CDK_DATABASE_USERNAME` | 1.2.0 | latest | None | External Postgresql login role |
| `CDK_DATABASE_PASSWORD` | 1.2.0 | latest | None | External Postgresql login password |
| `CDK_DATABASE_CONNECTIONTIMEOUT` | 1.2.0 | latest | None | External Postgresql connection timeout in seconds. |
| `PLATFORM_LISTENING_PORT` | 1.1.3 | 1.2.0 | 8080 | Deprecated, use `CDK_LISTENING_PORT` |
| `CDK_LISTENING_PORT` | 1.2.0 | latest | 8080 | Platform listening port |

## Environment override 
For the full list of override environment variables, see [environment override](./Environment_Override.md).

Starting from conduktor-platform **1.2.0** input configuration fields can be provided using environment variables.  

All override environment variables are prefixed with `CDK_` and are derived from yaml field path where `.` are replaced with `_` and index `[idx].` into with `_idx_`. 

E.g. configuration field => environment variable :
- `license` => `CDK_LICENSE`
- `organization.name` => `CDK_ORGANIZATION_NAME` 
- `clusters[0].bootstrapServers` => `CDK_CLUSTERS_1_BOOTSTRAPSERVERS`
- `clusters[2].kafkaConnects[0].security.password` => `CDK_CLUSTERS_1_KAFKACONNECTS_SECURITY_PASSWORD`

## Conduktor Platform Configuration Snippets
Below outlines snippets demonstrating fundamental configurations possibility.


## Organization
`organization.name` : user-defined name to identify your organization:
```yml 
organization:
  name: conduktor // The name of your organization
```


## Plain Auth Example
Connect to a local cluster with no auth/encryption, for example a local development Kafka

```yml
clusters:
  - id: local
    name: My Local Kafka Cluster
    color: "#0013E7"
    ignoreUntrustedCertificate: false
    bootstrapServers: "localhost:9092"
```

## Plain Auth With Schema Registry
Connect to a local cluster with schema registry
```yml
clusters:
  - id: local
    name: My Local Kafka Cluster
    color: "#0013E7"
    ignoreUntrustedCertificate: false
    bootstrapServers: "localhost:9092"
    schemaRegistry:
      id: Local SR
      url: "http://localhost:8081"
      ignoreUntrustedCertificate: false
    labels: {}
```

## Amazon MSK with IAM Authentication Example
Connect to an MSK cluster with IAM Authentication using AWS Access Key and Secret
```yml
clusters:
  - id: amazon-msk-iam
    name: Amazon MSK IAM
    color: #FF9900
    bootstrapServers: "b-3-public.****.kafka.eu-west-1.amazonaws.com:9198"
    properties: |
      security.protocol=SASL_SSL
      sasl.mechanism=AWS_MSK_IAM
      sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
      sasl.client.callback.handler.class=io.conduktor.aws.IAMClientCallbackHandler
      aws_access_key_id=<access-key-id>
      aws_secret_access_key=<secret-access-key>
```
Connect to an MSK cluster with IAM credentials inherited from environment
```yml
clusters:
  - id: amazon-msk-iam
    name: Amazon MSK IAM
    color: #FF9900
    bootstrapServers: "b-3-public.****.kafka.eu-west-1.amazonaws.com:9198"
    properties: |
      security.protocol=SASL_SSL
      sasl.mechanism=AWS_MSK_IAM
      sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
      sasl.client.callback.handler.class=io.conduktor.aws.IAMClientCallbackHandler
```
On top of that, you can override either the `default` profile or the role to assume.
Override Profile
```
sasl.jaas.config = software.amazon.msk.auth.iam.IAMLoginModule required awsProfileName="other-profile";
```
Override Role
```
sasl.jaas.config = software.amazon.msk.auth.iam.IAMLoginModule required awsRoleArn="arn:aws:iam::123456789012:role/msk_client_role";
```
## Confluent Cloud Example
Connect to a confluent cloud cluster using API keys
```yml
clusters:
  - id: confluent-pkc
    name: Confluent pkc-lzoyy
    color: "#E70000"
    ignoreUntrustedCertificate: false
    bootstrapServers: "pkc-lzoyy.eu-central-1.aws.confluent.cloud:9092"
    properties: |
      security.protocol=SASL_SSL
      sasl.mechanism=PLAIN
      sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="<username>" password="<password>";
```
## Confluent Cloud with Schema Registry

Connect to a confluent cloud cluster with schema registry using basic auth
 ```yml
  - id: confluent-pkc
    name: Confluent pkc-lq8v7
    color: "#E70000"
    ignoreUntrustedCertificate: false
    bootstrapServers: "pkc-lq8v7.eu-central-1.aws.confluent.cloud:9092"
    properties: |
      security.protocol=SASL_SSL
      sasl.mechanism=PLAIN
      sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="<usernam>" password="<password>";
    schemaRegistry:
      id: confluent-sr
      url: "https://psrc-o268o.eu-central-1.aws.confluent.cloud"
      ignoreUntrustedCertificate: false
      security:
        username: <username>
        password: <password>
    labels: {}
```

## SSL Certificates Example - Aiven (truststore)
Keystore and truststore are not supported. But you can directly use the PEM formatted files (.pem or .cer)  
Aiven example providing inline CA certificate  
Please make sure the certificate is on one single line  
```yml
  - id: aiven-stg
    name: My Aiven Cluster
    bootstrapServers: "kafka-09ba.aivencloud.com:21661"
    properties: |
      security.protocol=SASL_SSL
      sasl.mechanism=SCRAM-SHA-512
      sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="<username>" password="<password>";
      ssl.truststore.type=PEM
      ssl.truststore.certificates=-----BEGIN CERTIFICATE----- <YOUR CA CERTIFICATE> -----END CERTIFICATE-----
```

## 2 Way SSL (keystore + truststore)
You should have 3 files, and generally they are embedded in 2 files:  
- Your access key (in the keystore.jks file)
- Your access certificate (in the keystore.jks file)
- Your CA certificate (in the truststore.jks file)
Please make sure to have the content is on a single line
````yaml
  - id: aiven-ssl
    name: Aiven SSL
    bootstrapServers: kafka-09ba.aivencloud.com:21650
    properties: |
      security.protocol=SSL
      ssl.truststore.type=PEM
      ssl.truststore.certificates=-----BEGIN CERTIFICATE----- <YOUR CA CERTIFICATE> -----END CERTIFICATE-----
      ssl.keystore.type=PEM
      ssl.keystore.key=-----BEGIN PRIVATE KEY----- <YOUR ACCES KEY> -----END PRIVATE KEY-----
      ssl.keystore.certificate.chain=-----BEGIN CERTIFICATE----- <YOUR ACCESS CERTIFICATE> -----END CERTIFICATE-----

````

## Kafka Connect
Cluster with Kafka Connect configured with Basic Auth
 ```yml
  - id: cluster-connect
    name: My Kafka With Connect
    color: #C90000
    bootstrapServers: "{Bootstrap Servers}"
    properties:
    kafkaConnects:
      - url: "{Kafka Connect URL}"
        id: kafka-connect
        name: kafkConnect
        security:
          username: <username>
          password: <password>
```

## SSO
- [Oauth2 OpenIdConnect Identity Provider](../example-sso-oauth2/README.md)
- [LDAP](../example-sso-ldap/README.md)

## OIDC
```yml
sso:
  oauth2:
    - name: "auth0"
      default: true
      client-id: <client_id>
      client-secret: <client_secret>
      callback-uri: http://localhost/auth/oauth/callback/auth0
      openid:
        issuer: https://conduktor-staging.eu.auth0.com/
```

### SSO Configuration Properties
- `sso` : is a key/value configuration consisting of:  
- `sso.ignoreUntrustedCertificate` : Disable SSL checks
- `sso.ldap.name`:  Ldap connection name
- `sso.ldap.server` : Ldap server host and port 
- `sso.ldap.managerDn` : Sets the manager DN
- `sso.ldap.managerPassword` : Sets the manager password
- `sso.ldap.search-base` : Sets the base DN to search.
- `sso.ldap.groups-base`: Sets the base DN to search from.
- `sso.oauth2.name` : Oauth2 connection name
- `sso.oauth2.default` : Use as default (true/false)
- `sso.oauth2.client-id` : Oauth2 client id 
- `sso.oauth2.client-secret` : Oauth2 client secret 
- `sso.oauth2.openid.issuer` : Issuer to check on token
- `sso.oauth2.scopes` : Scope to be requested in the client credentials request. 
- `sso.oauth2.authorization-url` : Authorization endpoint URL
- `sso.oauth2.token.url` :  Get token endpoint URL
- `sso.oauth2.token.auth-method` : Authentication Method one of : "CLIENT_SECRET_BASIC", "CLIENT_SECRET_JWT", "CLIENT_SECRET_POST", "NONE", "PRIVATE_KEY_JWT", "TLS_CLIENT_AUTH" 


## Complete Configuration Example

```yml
organization:
  name: conduktor // The name of your organization

clusters:
  - id: local
    name: My Local Kafka Cluster
    color: "#0013E7"
    ignoreUntrustedCertificate: false
    bootstrapServers: "localhost:9092"
    schemaRegistry:
      id: Local SR
      url: "http://localhost:8081"
      ignoreUntrustedCertificate: false
    labels: {}

  - id: confluent-pkc
    name: Confluent pkc-lq8v7
    color: "#E70000"
    ignoreUntrustedCertificate: false
    bootstrapServers: "pkc-lq8v7.eu-central-1.aws.confluent.cloud:9092"
    properties: |
      security.protocol=SASL_SSL
      sasl.mechanism=PLAIN
      sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="<usernam>" password="<password>";
    schemaRegistry:
      id: confluent-sr
      url: "https://psrc-o268o.eu-central-1.aws.confluent.cloud"
      ignoreUntrustedCertificate: false
      security:
        username: <username>
        password: <password>
    labels: {}

sso:
  oauth2:
    - name: "auth0"
      default: true
      client-id: <client_id>
      client-secret: <client_secret>
      callback-uri: http://localhost/auth/oauth/callback/auth0
      openid:
        issuer: https://conduktor-staging.eu.auth0.com/

license: "<license_key>"
```


## External database configuration
For quickstart purpose platform run with an internal embedded database (default).   

For production environmnents conduktor-platform support (from version [**1.1.2**](../README.md#112-20-10-2022)) external database configuration. 

### Database requirements
- PostgreSQL 14+
- Provided connection role should have grant `ALL PRIVILEGES` on configured database. Platform should be able to create/update/delete schema and tables on database.


### Database Configuration Properties

- `database` : is a key/value configuration consisting of:  
- `database.url` : database connection url in the format `[jdbc:]postgresql://[user[:password]@]netloc[:port][/dbname][?param1=value1&...]`    
- `database.host` : Postgresql server host name   
- `database.port` : Postgresql server port   
- `database.name` : Database name    
- `database.username` : Database login role   
- `database.password` : Database login password   
- `database.connection_timeout` : Connection timeout option in seconds   

### Setup

There is several possibility to configure external database: 

1. From a single connection url
   - With `CDK_DATABASE_URL` environment variable.  
   - With `database.url` configuration field.
In either cases, this connection url is using a standard PostgreSQL url in the format `[jdbc:]postgresql://[user[:password]@]netloc[:port][/dbname][?param1=value1&...]`

2. From decomposed configuration fields
   - With `CDK_DATABASE_*` env vars. (see [environment variables list](#configuration-using-environment-variables))
   - With `database.*` on configuration file. 
```yaml
database: 
  host: "host"
  port: 5432
  name: "database"
  username: "user"
  password: "password"
  connection_timeout: 30 # in seconds
```

Example : 
```shell
docker run \
  -e CDK_DATABASE_URL="postgresql://user:password@host:5432/database" \
  conduktor/conduktor-platform:1.2.0
```
> **Note 1** : If all connection url **AND** decomposed configuration fields are provided, the decomposed configuration fields take priority.

> **Note 2** : If an invalid connection url or some mandatory configuration fields (`host`, `username` and `name`) are missing, conduktor-platform will crash with meaningful error message.

> **Note 3** : Before **1.2.0** `EMBEDDED_POSTGRES=false` was mandatory to enable external postgresql configuration. If no external database is configured either from url or decompose fields, platform will start using embedded database.
