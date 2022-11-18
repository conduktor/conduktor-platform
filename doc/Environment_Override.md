# Configuration properties and environment variables

Jump to:
- [Docker Image Environment Variables](#docker-image-environment-variables)
- [Platform Properties Reference](#platform-properties-reference)

## Docker image environment variables

| ENV | Since Version | Until Version | Default Value |   | 
|-----|---------------|---------------|---------------|---|
| **`RUN_MODE`**          | 1.0.2 | latest | `nano` | Memory presets for the platform see [ advanced settings](../installation/hardware.md)
| **`CDK_VOLUME_DIR`**    | 1.0.2 | latest | `/var/conduktor` | Volume directory where Conduktor platform store data **|
| **`CDK_IN_CONF_FILE`**  | 1.0.2 | latest | [`/opt/conduktor/default-platform-config.yaml`](./introduction.md#configuration-file)) | Conduktor platform configuration file location **|
| **`CDK_LISTENING_PORT`** | 1.2.0 | latest | `8080` | Platform listening port **|
| **`CDK_SSL_TRUSTSTORE_PATH`** | 1.5.0 | latest | None | Truststore file path used by platform kafka, SSO, S3, ... clients SSL/TLS verification
| **`CDK_SSL_TRUSTSTORE_PASSWORD`** | 1.5.0 | latest | None | Truststore password (optional)
| **`CDK_SSL_TRUSTSTORE_TYPE`** | 1.5.0 | latest | `jks` | Truststore type (optional)

## Platform properties reference

Starting from Conduktor Platform `1.2.0` input configuration fields can be provided using environment variables.

Below shows the mapping of configuration fields in the `platform-config.yaml` to environment variables.
You can use this [website helper](https://conduktor.github.io/yaml-to-env/) to convert configuration yaml to environment variables list.

### Global properties
- **`organization.name`** :  Your organizations name     
    - *Env* : **`CDK_ORGANIZATION_NAME`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : `"default"`

- **`license`** :  Enterprise license key. If not provided, fallback to free plan.
    - *Env* : **`CDK_LICENSE`** or **`LICENSE_KEY`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅
    
> **Tips** : If you need more that what free plan offer, you can [contact us](https://www.conduktor.io/contact/sales) for a trial license.

### Database properties
See database configuration [documentation](./database) for more info

- **`database.url`** : External Postgresql configuration URL in format `[jdbc:]postgresql://[user[:password]@]netloc[:port][/dbname][?param1=value1&...]`. 
    - *Env* : **`CDK_DATABASE_URL`** (prior to `1.2.0` it was *`PLATFORM_DB_URL`*)
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`database.host`** : External Postgresql server hostname 
    - *Env* : **`CDK_DATABASE_HOST`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`database.port`** : External Postgresql server port 
    - *Env* : **`CDK_DATABASE_PORT`** 
    - *Mandatory* : false
    - *Type* : int
    - *Default* : ∅

- **`database.name`** : External Postgresql database name 
    - *Env* : **`CDK_DATABASE_NAME`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`database.username`** : External Postgresql login role 
    - *Env* : **`CDK_DATABASE_USERNAME`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`database.password`** : External Postgresql login password 
    - *Env* : **`CDK_DATABASE_PASSWORD`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`database.connection_timeout`** : External Postgresql connection timeout in seconds. 
    - *Env* : **`CDK_DATABASE_CONNECTIONTIMEOUT`** 
    - *Mandatory* : false
    - *Type* : int
    - *Default* : ∅

### Monitoring properties 

- **`monitoring.storage.s3.endpoint`** : External monitoring S3 storage endpoint
    - *Env* : **`CDK_MONITORING_STORAGE_S3_ENDPOINT`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅
    - *Since* : `1.5.0`

- **`monitoring.storage.s3.region`** : External monitoring S3 storage region
    - *Env* : **`CDK_MONITORING_STORAGE_S3_REGION`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅
    - *Since* : `1.5.0`

- **`monitoring.storage.s3.bucket`** : External monitoring S3 storage bucket name
    - *Env* : **`CDK_MONITORING_STORAGE_S3_BUCKET`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅
    - *Since* : `1.5.0`

- **`monitoring.storage.s3.insecure`** : External monitoring S3 storage SSL/TLS check flag
    - *Env* : **`CDK_MONITORING_STORAGE_S3_INSECURE`** 
    - *Mandatory* : false
    - *Type* : bool
    - *Default* : `false`
    - *Since* : `1.5.0`

- **`monitoring.storage.s3.accessKeyId`** : External monitoring S3 storage access key
    - *Env* : **`CDK_MONITORING_STORAGE_S3_ACCESSKEYID`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅
    - *Since* : `1.5.0`

- **`monitoring.storage.s3.secretAccessKey`** : External monitoring S3 storage access key secret
    - *Env* : **`CDK_MONITORING_STORAGE_S3_SECRETACCESSKEY`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅
    - *Since* : `1.5.0`

### Kafka clusters properties

- **`clusters[].id`** : String used to uniquely identify your Kafka cluster     
    - *Env* : **`CDK_CLUSTERS_0_ID`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`clusters[].name`** : Alias or user-friendly name for your Kafka cluster     
    - *Env* : **`CDK_CLUSTERS_0_NAME`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`clusters[].color`** : Attach a color to associate with your cluster in the UI     
    - *Env* : **`CDK_CLUSTERS_0_COLOR`** 
    - *Mandatory* : false
    - *Type* : string in hexadecimal format (`#FFFFFF`)
    - *Default* : random

- **`clusters[].ignoreUntrustedCertificate`** : Skip SSL certificate validation     
    - *Env* : **`CDK_CLUSTERS_0_IGNOREUNTRUSTEDCERTIFICATE`** 
    - *Mandatory* : false
    - *Type* : boolean
    - *Default* : `false`

- **`clusters[].bootstrapServers`** : List of host:port for your Kafka brokers separated by coma `,`     
    - *Env* : **`CDK_CLUSTERS_0_BOOTSTRAPSERVERS`** 
    - *Mandatory* : true
    - *Type* : string 
    - *Default* : ∅

- **`clusters[].zookeeperServer`** : Zookeeper server url
    - *Env* : **`CDK_CLUSTERS_0_ZOOKEEPERSERVER`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`clusters[].properties`** : Any cluster configuration properties. 
    - *Env* : **`CDK_CLUSTERS_0_PROPERTIES`** 
    - *Mandatory* : false
    - *Type* : string where each line is a property
    - *Default* : ∅
    > **Tips** : To set multi-line properties using environment variable, separate each properties with `\n` like `prop1=value1\nprop3=value3`.

- **`clusters[].schemaRegistry.id`** : String used to uniquely identify your schema registry     
    - *Env* : **`CDK_CLUSTERS_0_SCHEMAREGISTRY_ID`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`clusters[].schemaRegistry.url`** : The schema registry URL    
    - *Env* : **`CDK_CLUSTERS_0_SCHEMAREGISTRY_URL`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`clusters[].schemaRegistry.ignoreUntrustedCertificate`** : Skip SSL certificate validation
    - *Env* : **`CDK_CLUSTERS_0_SCHEMAREGISTRY_IGNOREUNTRUSTEDCERTIFICATE`**
    - *Mandatory* : false
    - *Type* : boolean
    - *Default* : `false`

- **`clusters[].schemaRegistry.properties`** : Any schema registry configuration parameters   
    - *Env* : **`CDK_CLUSTERS_0_SCHEMAREGISTRY_PROPERTIES`** 
    - *Mandatory* : false
    - *Type* : string where each line is a property
    - *Default* : ∅
    > **Tips** : To set multi-line properties using environment variable, separate each properties with `\n` like `prop1=value1\nprop3=value3`.

- **`clusters[].schemaRegistry.security.username`** : Basic auth username     
    - *Env* : **`CDK_CLUSTERS_0_SCHEMAREGISTRY_SECURITY_USERNAME`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`clusters[].schemaRegistry.security.password`** : Basic auth password     
    - *Env* : **`CDK_CLUSTERS_0_SCHEMAREGISTRY_SECURITY_PASSWORD`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`clusters[].kafkaConnects[].id`** : String used to uniquely identify your Kafka Connect     
    - *Env* : **`CDK_CLUSTERS_0_KAFKACONNECTS_0_ID`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`clusters[].kafkaConnects[].url`** : The Kafka connect URL     
    - *Env* : **`CDK_CLUSTERS_0_KAFKACONNECTS_0_URL`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`clusters[].kafkaConnects[].security.username`** : Basic auth username     
    - *Env* : **`CDK_CLUSTERS_0_KAFKACONNECTS_0_SECURITY_USERNAME`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`clusters[].kafkaConnects[].security.username`** : Basic auth password     
    - *Env* : **`CDK_CLUSTERS_0_KAFKACONNECTS_0_SECURITY_PASSWORD`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`clusters[].jmxScrapePort`** : JMX-exporter port used to scrape kafka broker metrics for monitoring
    - *Env* : **`CDK_CLUSTERS_0_JMXSCRAPEPORT`** 
    - *Mandatory* : false
    - *Type* : int
    - *Default* : `9101`

- **`clusters[].nodeScrapePort`** : Node-exporter port used to scrape kafka host metrics for monitoring   
    - *Env* : **`CDK_CLUSTERS_0_NODESCRAPEPORT`** 
    - *Mandatory* : false
    - *Type* : int
    - *Default* : `9100`


### Environment properties (for governance feature)
Optional list of environments used by governance.

- **`envs[].name`** : Environment name used by governance
    - *Env* : **`CDK_ENVS_0_NAME`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`envs[].clusterId`** : Environment linked clusterId    
    - *Env* : **`CDK_ENVS_0_CLUSTERID`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

### Application properties (for governance feature)
Optional list of applications used by governance.

- **`applications[].name`** : Application name
    - *Env* : **`CDK_APPLICATIONS_0_NAME`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`applications[].description`** : Application description
    - *Env* : **`CDK_APPLICATIONS_0_DESCRIPTION`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`applications[].slug`** : Application slug 
    - *Env* : **`CDK_APPLICATIONS_0_SLUG`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`applications[].tags[]`** : Application tags list
    - *Env* : **`CDK_APPLICATIONS_0_TAGS`** 
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`applications[].owner`** : Application owner email 
    - *Env* : **`CDK_APPLICATIONS_0_OWNER`** 
    - *Mandatory* : true
    - *Type* : string (e.g: `U:user@company.com`)
    - *Default* : ∅


### Local users properties
Optional local accounts list used to login on conduktor-platform

- **`auth.local-users[].email`** : User login 
    - *Env* : **`CDK_AUTH_LOCALUSERS_0_EMAIL`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : `"admin@conduktor.io"`

- **`auth.local-users[].password`** : User password 
    - *Env* : **`CDK_AUTH_LOCALUSERS_0_PASSWORD`** 
    - *Mandatory* : true
    - *Type* : string
    - *Default* : `"admin"`

### SSO properties
SSO authentication properties (only on enterprise plan). 
See authentication [documentation](./user-authentication) for snipets

- **`sso.ignoreUntrustedCertificate`** : Disable SSL checks
    - *Env* : **`SSO_IGNORE-UNTRUSTED-CERTIFICATE`**
    - *Mandatory* : false
    - *Type* : boolean
    - *Default* : `false`
    - *Since* : `1.3.0`

#### LDAP properties

- **`sso.ldap[].name`** :  Ldap connection name
    - *Env* : **`SSO_LDAP_0_NAME`**
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`sso.ldap[].server`** : Ldap server host and port 
    - *Env* : **`SSO_LDAP_0_SERVER`**
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅
    
- **`sso.ldap[].managerDn`** : Sets the manager DN
    - *Env* : **`SSO_LDAP_0_MANAGERDN`**
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`sso.ldap[].managerPassword`** : Sets the manager password
    - *Env* : **`SSO_LDAP_0_MANAGERPASSWORD`**
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`sso.ldap[].search-subtree`** : Sets if the subtree should be searched.
    - *Env* : **`SSO_LDAP_0_SEARCH-subtree`**
    - *Mandatory* : false
    - *Type* : boolean
    - *Default* : `true`
    - *Since* : `1.5.0`

- **`sso.ldap[].search-base`** : Sets the base DN to search.
    - *Env* : **`SSO_LDAP_0_SEARCH-BASE`**
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`sso.ldap[].search-filter`** : Sets the search filter. 
    - *Env* : **`SSO_LDAP_0_SEARCH-FILTER`**
    - *Mandatory* : false
    - *Type* : string
    - *Default* : `"(uid={0})"`
    - *Since* : `1.5.0`

- **`sso.ldap[].search-attributes`** : Sets the attributes list to return.
    - *Env* : **`SSO_LDAP_0_SEARCH-ATTRIBUTES`**
    - *Mandatory* : false
    - *Type* : string array
    - *Default* : `[]`
    - *Since* : `1.5.0`

- **`sso.ldap[].groups-enabled`** : Sets if group search is enabled.
    - *Env* : **`SSO_LDAP_0_GROUPS-ENABLED`**
    - *Mandatory* : false
    - *Type* : boolean
    - *Default* : `false`
    - *Since* : `1.5.0`

- **`sso.ldap[].groups-subtree`** : Sets if the subtree should be searched. 
    - *Env* : **`SSO_LDAP_0_GROUPS-SUBTREE`**
    - *Mandatory* : false
    - *Type* : boolean
    - *Default* : `true`
    - *Since* : `1.5.0`

- **`sso.ldap[].groups-base`** : Sets the base DN to search from.
    - *Env* : **`SSO_LDAP_0_GROUPS-BASE`**
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`sso.ldap[].groups-filter`** : Sets the group search filter. 
    - *Env* : **`SSO_LDAP_0_GROUPS-FILTER`**
    - *Mandatory* : false
    - *Type* : string
    - *Default* : `"uniquemember={0}"`
    - *Since* : `1.5.0`

- **`sso.ldap[].groups-filter-attribute`** : Sets the name of the user attribute to bind to the group search filter. 
    - *Env* : **`SSO_LDAP_0_GROUPS-FILTER-ATTRIBUTE`**
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅
    - *Since* : `1.5.0`

- **`sso.ldap[].groups-attribute`** : SSets the group attribute name
    - *Env* : **`SSO_LDAP_0_GROUPS-ATTRIBUTE`**
    - *Mandatory* : false
    - *Type* : string
    - *Default* : `"cn"`
    - *Since* : `1.5.0`

#### Oauth2 properties

- **`sso.oauth2[].name`** : Oauth2 connection name
    - *Env* : **`SSO_OAUTH2_0_NAME`**
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`sso.oauth2[].default`** : Use as default 
    - *Env* : **`SSO_OAUTH2_0_DEFAULT`**
    - *Mandatory* : true
    - *Type* : boolean
    - *Default* : ∅

- **`sso.oauth2[].client-id`** : Oauth2 client id 
    - *Env* : **`SSO_OAUTH2_0_CLIENT-ID`**
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`sso.oauth2[].client-secret`** : Oauth2 client secret 
    - *Env* : **`SSO_OAUTH2_0_CLIENT-SECRET`**
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`sso.oauth2[].openid.issuer`** : Issuer to check on token
    - *Env* : **`SSO_OAUTH2_0_OPENID_ISSUER`**
    - *Mandatory* : true
    - *Type* : string
    - *Default* : ∅

- **`sso.oauth2[].scopes`** : Scope to be requested in the client credentials request. 
    - *Env* : **`SSO_OAUTH2_0_SCOPES`**
    - *Mandatory* : true
    - *Type* : string
    - *Default* : `[]`

- **`sso.oauth2[].authorization-url`** : Authorization endpoint URL
    - *Env* : **`SSO_OAUTH2_0_AUTHORIZATION-URL`**
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`sso.oauth2[].token.url`** :  Get token endpoint URL
    - *Env* : **`SSO_OAUTH2_0_TOKEN_URL`**
    - *Mandatory* : false
    - *Type* : string
    - *Default* : ∅

- **`sso.oauth2[].token.auth-method`** : Authentication Method 
    - *Env* : **`SSO_OAUTH2_0_TOKEN_AUTH-METHOD`**
    - *Mandatory* : false
    - *Type* : string one of : `"CLIENT_SECRET_BASIC"`, `"CLIENT_SECRET_JWT"`, `"CLIENT_SECRET_POST"`, `"NONE"`, `"PRIVATE_KEY_JWT"`, `"TLS_CLIENT_AUTH" `
    - *Default* : ∅

> **Note** : In environment variables, lists start at index 0 and are provided using `_idx_` syntax. 