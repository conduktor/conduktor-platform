# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## 1.2.0 (2022-10-28)
Features : 
- Platform :
    - Platform configurations can be overridden from environment variables (see [configuration documentation](./doc/Configuration.md#environment-override))
- Home
    - Remove beta tag from Monitoring + Data Masking
- Testing
    - Simplify source selection in checks
    - Add support of S3 in LoadCSV
    - Add Comparison data node

Fix :
- Platform 
    - Fix help menu items
    - Enable solutions in product switcher to open in new tab
    - Use intercom widget on feedback tab
- Home / Admin
    - Fix userId issue in Segment identify event
- Console
    - Accept certificate chains in Kafka properties
    - Quick search in data tables is now case insensitive
    - Produce - partition selection dropdown was not working
    - Kafka Connect - Improve connector definition validation
- Testing
    - Fix certificate chains
- Monitoring
    - Lag metrics now work with TLS
    - Clusters are now displayed as within other apps
- Data masking
    - Fix masking delete policy
    - Bring policies table in-line with Platform UI standards

## 1.1.3 (2022-10-20)

Features :
- Customize Platform Port with [PLATFORM_LISTENING_PORT](./doc/Configuration.md#configuration-using-environment-variables)
- Support for MSK with IAM auth in Console and Testing -  see [documentation](./doc/Configuration.md#amazon-msk-with-iam-authentication-example)
- Testing: Regenerate Agent token

## 1.1.2 (2022-10-20)

Features :
- Support for external PostgreSQL see configuration [documentation](./doc/Configuration.md#external-database-configuration)
- Console: Consumer Groups | Reset offsets
- Console: Kafka Connect   | Create, Update, Delete, Pause, Restart Operations
- Console: Schema Registry | Compare schema versions
- Add new conduktor logo
- Test connection on Schema Registry
- Admin: support users with uppercases in the emails

Fix:
- Group search was using "startWith", now it uses "contains"
- Admin: clusters sort by date

Improvements:
- Audit log UX when masking page for members

## 1.0.2 (2022-09-26)

Initial public release 
