## Conduktor platform configuration snippets
Below outlines snippets demonstrating fundamental configurations possibility.


## Organization
`organization.name` : user-defined name to identify your organization:
```yml 
organization:
  name: conduktor // The name of your organization
```

## Cluster Configurations
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

`labels` : (optional)


## Plain Auth Example
Connect to a local cluster with no auth/encryption, for example a local development Kafka

```yml
clusters:
  - id: local
    name: My Local Kafka Cluster
    color: "#0013E7"
    ignoreUntrustedCertificate: false
    bootstrapServers: "localhost:9092"
    properties: |
      client.id=conduktor
      default.api.timeout.ms=5000
      request.timeout.ms=5000
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
    properties: |
      client.id=conduktor
      default.api.timeout.ms=5000
      request.timeout.ms=5000
    schemaRegistry:
      id: Local SR
      url: "http://localhost:8081"
      ignoreUntrustedCertificate: false
      properties: |
        acks=all
        client.id=conduktor
        default.api.timeout.ms=5000
        request.timeout.ms=5000
    labels: {}
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
      client.id=conduktor
      default.api.timeout.ms=5000
      request.timeout.ms=5000
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
      client.id=conduktor
      default.api.timeout.ms=5000
      request.timeout.ms=5000
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

## SSL Certificates Example - Aiven
Aiven example providing inline CA certificate
```yml
  - id: aiven-stg
    name: My Aiven Cluster
    bootstrapServers: "...aivencloud.com:21661"
    properties: |
      security.protocol=SASL_SSL
      sasl.mechanism=SCRAM-SHA-512
      sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="<username>" password="<password>";
      ssl.truststore.type=PEM
      ssl.truststore.certificates=-----BEGIN CERTIFICATE----- <YOUR CA CERTIFICATE> -----END CERTIFICATE-----
```
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
Coming soon !
## LDAP
Coming soon !

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
    - name: "github"
      default: false
      client-id: <client_id>
      client-secret: <client_secret>
      scopes:
        - user:email
        - read:user
      authorization-url: https://github.com/login/oauth/authorize
      token:
        url: "https://github.com/login/oauth/access_token"
        auth-method: <client_secret_post>
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
    properties: |
      client.id=conduktor
      default.api.timeout.ms=5000
      request.timeout.ms=5000
    schemaRegistry:
      id: Local SR
      url: "http://localhost:8081"
      ignoreUntrustedCertificate: false
      properties: |
        acks=all
        client.id=conduktor
        default.api.timeout.ms=5000
        request.timeout.ms=5000
    labels: {}

  - id: confluent-pkc
    name: Confluent pkc-lq8v7
    color: "#E70000"
    ignoreUntrustedCertificate: false
    bootstrapServers: "pkc-lq8v7.eu-central-1.aws.confluent.cloud:9092"
    properties: |
      client.id=conduktor
      default.api.timeout.ms=5000
      request.timeout.ms=5000
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