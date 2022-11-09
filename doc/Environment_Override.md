# Override Environment Variables

Starting from conduktor-platform 1.2.0 input configuration fields can be provided using environment variables.

Below shows the mapping of configuration fields in the `platform-config.yaml` to environment variables.

- [Configuration Field Mapping](#configuration-field-mapping)
- [Property Definitions](#property-definitions)

## Configuration Field Mapping

| Configuration Field     | Environment Variable    |
|-----|-----|
| `organization.name`    | `CDK_ORGANIZATION_NAME`  |
| `clusters[0].id`    | `CDK_CLUSTERS_1_ID`  |
| `clusters[0].name`    | `CDK_CLUSTERS_1_NAME`  |
| `clusters[0].color`    | `CDK_CLUSTERS_1_COLOR`  |
| `clusters[0].ignoreUntrustedCertificate`    | `CDK_CLUSTERS_1_IGNOREUNTRUSTEDCERTIFICATE`  |
| `clusters[0].bootstrapServers`    | `CDK_CLUSTERS_1_BOOTSTRAPSERVERS`  | 
| `clusters[0].zookeeperServer`    | `CDK_CLUSTERS_1_ZOOKEEPERSERVER`  | 
| `clusters[0].properties`    | `CDK_CLUSTERS_1_PROPERTIES`  | 
| `clusters[0].schemaRegistry.id`    | `CDK_CLUSTERS_1_SCHEMAREGISTRY_ID`  | 
| `clusters[0].schemaRegistry.url`    | `CDK_CLUSTERS_1_SCHEMAREGISTRY_URL`  | 
| `clusters[0].schemaRegistry.ignoreUntrustedCertificate`    | `CDK_CLUSTERS_1_SCHEMAREGISTRY_IGNOREUNTRUSTEDCERTIFICATE`  | 
| `clusters[0].schemaRegistry.properties`    | `CDK_CLUSTERS_1_SCHEMAREGISTRY_PROPERTIES`  | 
| `clusters[0].schemaRegistry.security.username`    | `CDK_CLUSTERS_1_SCHEMAREGISTRY_SECURITY_USERNAME`  | 
| `clusters[0].schemaRegistry.security.password`    | `CDK_CLUSTERS_1_SCHEMAREGISTRY_SECURITY_PASSWORD`  | 
| `clusters[0].kafkaConnects[0].id`    | `CDK_CLUSTERS_1_KAFKACONNECTS_1_ID`  | 
| `clusters[0].kafkaConnects[0].url`    | `CDK_CLUSTERS_1_KAFKACONNECTS_1_URL`  | 
| `clusters[0].kafkaConnects[0].security.username`    | `CDK_CLUSTERS_1_KAFKACONNECTS_1_SECURITY_USERNAME`  | 
| `clusters[0].kafkaConnects[0].security.username`    | `CDK_CLUSTERS_1_KAFKACONNECTS_1_SECURITY_PASSWORD`  |
| `clusters[0].jmxScrapePort`    | `CDK_CLUSTERS_1_JMXSCRAPEPORT`  |
| `clusters[0].nodeScrapePort`   | `CDK_CLUSTERS_1_NODECRAPEPORT`  |
| `database.url`    | `CDK_DATABASE_URL`  | 
| `database.host`    | `CDK_DATABASE_HOST`  |
| `database.port`    | `CDK_DATABASE_PORT`  |
| `database.name`    | `CDK_DATABASE_NAME`  |
| `database.username`    | `CDK_DATABASE_USERNAME`  |
| `database.password`    | `CDK_DATABASE_PASSWORD`  |
| `database.connection_timeout`    | `CDK_DATABASE_CONNECTIONTIMEOUT`  |
| `auth.demo_users[0].email` | `CDK_AUTH_DEMOUSERS_0_email` | 
| `auth.demo_users[0].password` | `CDK_AUTH_DEMOUSERS_0_password` |
| `auth.demo_users[0].groups[0]` | `CDK_AUTH_DEMOUSERS_0_groups_0` |

## Property Definitions

- `organization.name` : Organization name
- `clusters[].id` : String used to uniquely identify your Kafka cluster
- `clusters[].name` : Alias or user-friendly name for your Kafka cluster
- `clusters[].color` : (optional) Attach a color to associate with your cluster in the UI
- `clusters[].ignoreUntrustedCertificate` : (optional) Skip SSL certificate validation
- `clusters[].bootstrapServers` : List of host:port for your Kafka brokers
- `clusters[].zookeeperServer` : (optional)
- `clusters[].properties` : Any cluster configuration properties. See [configuration snippets](./Configuration.md#confluent-cloud-example)
- `clusters[].schemaRegistry` (optional)  Configuration parameters if using schema registry
- `clusters[].schemaRegistry.id` : String used to uniquely identify your schema registry
- `clusters[].schemaRegistry.url` : The schema registry URL
- `clusters[].schemaRegistry.ignoreUntrustedCertificate` : (optional) Skip SSL certificate validation
- `clusters[].schemaRegistry.properties` : Any schema registry configuration parameters See [configuration snippets](./Configuration.md#confluent-cloud-example)
- `clusters[].schemaRegistry.security` (optional)
- `clusters[].schemaRegistry.security.username` : Basic auth username
- `clusters[].schemaRegistry.security.password` : Basic auth password
- `clusters[].kafkaConnects` : (optional) List of KafkaConnects servers
- `clusters[].kafkaConnects[].id` : String used to uniquely identify your Kafka Connect
- `clusters[].kafkaConnects[].url` : The Kafka connect URL
- `clusters[].kafkaConnects[].security` : (optional)
- `clusters[].kafkaConnects[].security.username` : Basic auth username
- `clusters[].kafkaConnects[].security.password` : Basic auth password 
- `clusters[].jmxScrapePort` : JMX-exporter port used to scrape kafka broker metrics for monitoring. (optional, `9101` by default)
- `clusters[].nodeScrapePort` : Node-exporter port used to scrape kafka host metrics for monitoring. (optional, `9100` by default)
- `clusters[].labels` : (optional)
- `database` : is a key/value configuration consisting of:  
- `database.url` : database connection url in the format `[jdbc:]postgresql://[user[:password]@]netloc[:port][/dbname][?param1=value1&...]`    
- `database.host` : Postgresql server host name   
- `database.port` : Postgresql server port   
- `database.name` : Database name    
- `database.username` : Database login role   
- `database.password` : Database login password   
- `database.connection_timeout` : Connection timeout option in seconds 
- `auth.demo_users` : List of local platform users 
- `auth.demo_users[].email` : User login
- `auth.demo_users[].password` : User password
- `auth.demo_users[].groups[]` : User groups list (optional)
