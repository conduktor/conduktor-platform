# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## 1.5.1 (2022-11-18)

### **Features** 

- **Platform**
  - Add support of external S3 storage for monitoring data. see [documentation](./doc/Environment_Override.md#monitoring-properties)
  - Add support of custom Truststore configuration for SSL/TLS connections. see [documentation](./doc/Environment_Override.md#docker-image-environment-variables)
  - SSO : Add more configuration parameters for LDAP connection. see [documentation](./doc/Environment_Override.md#ldap-properties)

- **Console**
  - Consumer Groups - Reset Offsets: New "datetime" strategy to choose when to reset the offsets to
  - Consumer Groups: You can now duplicate a Consumer Group
  - Topics configuration: You can now update your Topics configuration
  - Topics configuration: You can now reset your Topics configuration
  - IAM support: Our io.conduktor.aws.IAMClientCallbackHandler class used to configure IAM in the Platform now complies with the "credentials provider chain" mechanism of AWS. It'll first try to find your credentials/role on your machine, as `software.amazon.msk.auth.iam.IAMClientCallbackHandler` would do. If nothing is found, then it'll use our mechanism. For more info, see [documentation](./doc/Configuration.md#amazon-msk-with-iam-authentication-example).     
  To summarize, our `io.conduktor.aws.IAMClientCallbackHandler` class can now be used as a drop-in replacement of `software.amazon.msk.auth.iam.IAMClientCallbackHandler` in your Kafka properties:
```yaml
properties: |
  security.protocol=SASL_SSL
  sasl.mechanism=AWS_MSK_IAM
  sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
  sasl.client.callback.handler.class=io.conduktor.aws.IAMClientCallbackHandler
```

- **Testing**
  - Added a structured summary in console at the end of executions
  - AWS IAM : default credential chain compliance

- **Monitoring**
  - It's now possible to select a custom date/time range
  - Number of messages in / s is also available when you don't configure a jmx agent

- **Admin**
  - The clusters UI now supports read/write/delete (cluster, schema registry, kafka connect)
  - The clusters configuration int the configuration file can be used as a 1st initialization but is not mandatory anymore to create clusters

### **Fixes**

- **Platform**
  - Remove unused configuration fields (`auth.local-users[].groups` and `slack-token` )

- **Console**
  - Create Topic form: The replication factor was not aligned with the Cluster configuration
  - Create Topic form: Improve error handling
  - CTRL+F is now working in the data viewers
  - Consumer Group: When "Overall Lag" and/or "Members" values were 0, they were displayed as N/A
  - Sometimes, in the top-level bar of the app, your Clusters were reported as "Not connected" while they were connected
  - Sometimes, when producing Avro data, an "Invalid JSON returned. Please try again" error was incorrectly displayed, and the produced data was not correctly displayed

- **Testing**
  - Fix agent connectivity hanging when using multiple instances of an agent
  - Fix menu tooltips being displayed behind the canvas
  - Fix loader not being centered
  - Fix Text4Shell CVE from org.apache.commons.commons-text-1.9

- **Data Masking**
  - Fix the creation rule form when a lot of field are added. The "create button" stay accessible now.


## 1.4.0 (2022-11-10)

### **Features** 
- **Platform**
  - Notify when a new Platform version is available
  - Environment variable generation from configuration file https://conduktor.github.io/yaml-to-env/
- **Console**
  - Create Topic form - Advanced configuration: The user can now configure all the settings of the topic
- **Testing**
  - Apply data masking rules before filters
- **Data Masking**
  - Apply data masking rules before filters
- **Admin**
  - Clusters now have technical id

### **Fixes**
- **Platform**
  - Fix authentication with SSO when no local user definition is provided
  - Fix `clusters[].schemaRegistry` parsing from env
- **Console**
  - Producer was producing too many messages when it was configured in automatic producing mode with an elapsed time stop condition
- **Testing**
  - Prevent connecting two nodes at once
  - Quota error on some executions
- **Data Masking**
  - Add scroll to Policy form panel
- **Admin**
  - Fix the cluster creation capacity for enterprise license

### **Deprecated**
- **Platform**
  - `auth.demo-users` deprecated and replaced with `auth.local-users`. (support both for now to avoid breaking change)

  
## 1.3.1 (2022-11-03)

### **Features** 
- **Platform**
   - Support ignoreUntrustedCertificate for SSO
- **Console**
  - Improve error messages displayed to the user on Kafka errors
  - Consume: The Bytes deserializer now uses the Kafka BytesDeserializer instead of returning a base64 version of the raw bytes
  - Consumer Groups - Reset Offsets:
    - It's now possible to choose which Topic and which partition to reset
    - New "shift by" option
  - Consumer Group: You can now delete a Consumer Group
  - Kafka Connect - Create new connector: It's now possible to select on which Kafka Connect instance the connector will be created
  - Kafka Connect - It's now possible to select on which Kafka Connect instance the connector will be paused/resumed/restarted/deleted
- **Testing**
  - Improve agent version tracking and related warnings
  - Improve dark mode support
- **Data Masking**
  - Implement scope filtering in datamasking
  - UI improvements
- **Admin**
- New sidebar design
- Clusters have a human friendly "technical id" to ease url sharing

### **Fixes**
- **Console**
  - Fix: Kafka Connect - The connectors data table is now refreshed when an action is performed on a connector
- **Testing**
  - Fix: Screen/Modals freezing on some actions
  - Fix: Can't connect multiple edges to some nodes
  - Fix: Reading large CSV files
  - Fix:  Text4Shell CVE from org.apache.commons.commons-text-1.9
- **Monitoring**
  - fix cluster discovery that failed in some cases
- **Data Masking**
  - Fix: Number fields are not masked
- **Admin**
  - Fix: Missing auth events in Audit log

## 1.2.0 (2022-10-28)

### **Features** 
- **Platform**
    - Platform configurations can be overridden from environment variables (see [configuration documentation](./doc/Configuration.md#environment-override))
- **Home**
    - Remove beta tag from Monitoring + Data Masking
- **Testing**
    - Simplify source selection in checks
    - Add support of S3 in LoadCSV
    - Add Comparison data node

### **Fixes**
- **Platform** 
    - Fix help menu items
    - Enable solutions in product switcher to open in new tab
    - Use intercom widget on feedback tab
- **Console**
    - Accept certificate chains in Kafka properties
    - Quick search in data tables is now case insensitive
    - Produce - partition selection dropdown was not working
    - Kafka Connect - Improve connector definition validation
- **Testing**
    - Accept certificate chains in Kafka properties
- **Monitoring**
    - Lag metrics now work with TLS
    - Clusters are now displayed as within other apps
- **Data masking**
    - Fix masking delete policy
    - Align policies table with Platform UI standards

## 1.1.3 (2022-10-20)

### **Features**
- Customize Platform Port with [PLATFORM_LISTENING_PORT](./doc/Configuration.md#configuration-using-environment-variables)
- Support for MSK with IAM auth in Console and Testing -  see [documentation](./doc/Configuration.md#amazon-msk-with-iam-authentication-example)
- Testing: Regenerate Agent token

## 1.1.2 (2022-10-20)

### **Features**
- Support for external PostgreSQL see configuration [documentation](./doc/Configuration.md#external-database-configuration)
- Console: Consumer Groups | Reset offsets
- Console: Kafka Connect   | Create, Update, Delete, Pause, Restart Operations
- Console: Schema Registry | Compare schema versions
- Add new conduktor logo
- Test connection on Schema Registry
- Admin: support users with uppercases in the emails

### **Fixes**:
- Group search was using "startWith", now it uses "contains"
- Admin: clusters sort by date

### **Improvements**:
- Audit log UX when masking page for members

## 1.0.2 (2022-09-26)

Initial public release 
