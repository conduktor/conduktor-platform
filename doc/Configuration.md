# Conduktor Platform Configuration

- [Conduktor Platform Configuration](#conduktor-platform-configuration)
  - [Introduction](#introduction)
  - [Configuration using environment variables](#configuration-using-environment-variables)
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
  - [Cluster Configuration Properties](#cluster-configuration-properties)
  - [External database configuration](#external-database-configuration)
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

database_url: postgresql://user:password@host:5432/database

clusters:
  - id: local
    name: My Local Kafka Cluster
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
  conduktor/conduktor-platform:1.1.3
```

OR using `CDK_IN_CONF_FILE` env :
```shell
 docker run --rm \
   --mount "type=bind,source=$PWD/platform-config.yml,target=/etc/platform-config.yaml" \
   -e CDK_IN_CONF_FILE="/etc/platform-config.yaml" \
  -e EMBEDDED_POSTGRES="false" \
  conduktor/conduktor-platform:1.1.3
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
| `CDK_VOLUME_DIR`    | 1.0.2 | latest | `/var/conduktor`                                                                          | Volume directory where Conduktor platform store data                                                                                                                         |
| `CDK_IN_CONF_FILE`  | 1.0.2 | latest | [`/opt/conduktor/default-platform-config.yaml`](./conduktor/default-platform-config.yaml) | Conduktor platform configuration file location                                                                                                                               |
| `EMBEDDED_POSTGRES` | 1.1.2 | latest | `true`                                                                                    | (since version **1.1.2**) Flag to enabled or disable embedded Postgresql database.  |
| `PLATFORM_DB_URL`   | 1.1.2 | latest | None                                                                                      | (since version **1.1.2**) External Postgresql configuration URL in format `[jdbc:]postgresql://[user[:password]@]netloc[:port][/dbname][?param1=value1&...]`. Only used if `EMBEDDED_POSTGRES=false` |
| `PLATFORM_LISTENING_PORT`          | 1.1.3 | latest | 8080 | 

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


## Cluster Configuration Properties
`clusters` : is a key/value configuration consisting of:

`clusters.id` : string used to uniquely identify your Kafka cluster

`clusters.name` : alias or user-friendly name for your Kafka cluster

`clusters.color` : (optional) attach a color to associate with your cluster in the UI

`clusters.ignoreUntrustedCertificate` : (optional) skip SSL certificate validation
`clusters.bootstrapServers` : list of host:port for your Kafka brokers

`clusters.zookeeperServer` : (optional)

`clusters.properties` : any cluster configuration properties. See docs.

`schemaRegistry` (optional)  Configuration parameters if using schema registry

`schemaRegistry.id` : string used to uniquely identify your schema registry

`schemaRegistry.url` : the schema registry URL

`schemaRegistry.ignoreUntrustedCertificate` : (optional) skip SSL certificate validation

`schemaRegistry.properties` : any schema registry configuration parameters

`schemaRegistry.security` (optional)

`schemaRegistry.security.username` : Basic auth username

`schemaRegistry.security.password` : Basic auth password

`kafkaConnects` : (optional)

`kafkaConnects.id` : string used to uniquely identify your Kafka Connect

`kafkaConnects.url` : the Kafka connect URL

`kafkaConnects.security` : (optional)

`kafkaConnects.security.username` : Basic auth username

`kafkaConnects.security.password` : Basic auth password
 
 `jmxScrapePort` : JMX port used to scrap cluster metrics for monitoring. (optional, `9101` by default)

`labels` : (optional)

## External database configuration
For quickstart purpose platform run with an internal embedded database (default).   

For production environmnents platform support (from version [**1.1.2**](../README.md#112-20-10-2022)) external database configuration. 

### Database requirements
- PostgreSQL 14+
- Provided connection role should have grant `ALL PRIVILEGES` on configured database. Platform should be able to create/update/delete schema and tables on database.

### Setup
To disable embedded database use `EMBEDDED_POSTGRES=false` environment variable.

Then database connection url can be defined using a standard PostgreSQL url in the format `[jdbc:]postgresql://[user[:password]@]netloc[:port][/dbname][?param1=value1&...]`

This URL can be passed either with environment variable `PLATFORM_DB_URL` or inside platform yaml configuration file in `database_url`.

Example : 
```shell
docker run \
  -e EMBEDDED_POSTGRES="false" \
  -e PLATFORM_DB_URL="postgresql://user:password@host:5432/database" \
  conduktor/conduktor-platform:1.1.3
```
