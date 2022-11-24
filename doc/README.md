## Conduktor Platform Docs 📝

- [Getting Started](#getting-started)
- [Solution Docs](#solution-docs)
    - [Conduktor Console](#conduktor-console)
    - [Conduktor Testing](#conduktor-testing)
    - [Conduktor Monitoring](#conduktor-monitoring)
    - [Conduktor Data Masking](#conduktor-data-masking)
- [Known Issues](#known-issues)

***

### Getting Started

#### Starting Conduktor Platform

There are 3 simple ways to experience Conduktor Platform. Explore them via the [README](https://github.com/conduktor/conduktor-platform#get-started) in the root directory.

#### Using the Configuration File

Conduktor platform can be setup using a yaml file that provides configuration for:
- organization
- kafka clusters
- sso (ldap/oauth2)
- license

[Learn how](Configuration.md) to use the configuration file and more [advanced](Advanced_settings.md) settings of the platform.  For most deployments and orginizations the setup and configuration of Conduktor Platform takes about an hour.


#### Using platform public apis

Conduktor platform expose some api that could be used to monitor internal state.

More details on thoses api can be found [here](Public_API.md)

***

## Solution Docs

### Conduktor Console
- Learn how to explore your Kafka data:
    - [Filtering data](https://github.com/conduktor/conduktor-platform/blob/main/doc/console/browse-data.md#filtering)
    - [Deserialization](https://github.com/conduktor/conduktor-platform/blob/main/doc/console/browse-data.md#deserialization)
- Learn about producing data:
    - [Producer](console/produce-data.md)
    - [Random data generation](https://github.com/conduktor/conduktor-platform/blob/main/doc/console/produce-data.md#random-data-generator)
    - ['Flow' mode](https://github.com/conduktor/conduktor-platform/blob/main/doc/console/produce-data.md#flow-mode)

***

### Conduktor Testing
- [Conduktor Testing Docs](testing/testing.md)

***

### Conduktor Monitoring
- [Conduktor Monitoring Docs](monitoring/monitoring.md)

***

### Conduktor Data Masking

Note that Data Masking is only available in Enterprise plans. If you are interested in gaining access to this feature, please [contact us](https://www.conduktor.io/contact).
- [Learn how to implement Data Masking](data%20masking/data-masking.md)


