# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

### **Fix**
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

### **Fix**
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

### **Fix**
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

### **Fix**:
- Group search was using "startWith", now it uses "contains"
- Admin: clusters sort by date

### **Improvements**:
- Audit log UX when masking page for members

## 1.0.2 (2022-09-26)

Initial public release 
