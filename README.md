<a name="readme-top" id="readme-top"></a>

<p align="center">
  <img src="https://raw.githubusercontent.com/conduktor/conduktor.io-public/main/logo/transparent.png" width="256px" />
</p>
<h1 align="center">
    <strong>Conduktor Console</strong>
</h1>

<p align="center">
    <a href="https://docs.conduktor.io/"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://www.conduktor.io/changelog"><img alt="GitHub Release" src="https://img.shields.io/docker/v/conduktor/conduktor-console?sort=semver&color=BCFE68"></a>
    ·
    <a href="https://conduktor.io/"><img src="https://img.shields.io/badge/Website-conduktor.io-192A4E?color=BCFE68" alt="Scale Data Streaming With Security and Control"></a>
    ·
    <a href="https://twitter.com/getconduktor"><img alt="X (formerly Twitter) Follow" src="https://img.shields.io/twitter/follow/getconduktor?color=BCFE68"></a>
    ·
    <a href="https://conduktor.io/slack"><img src="https://img.shields.io/badge/Slack-Join%20Community-BCFE68?logo=slack" alt="Slack"></a>
</p>

We take the complexity out of Kafka. Console gives you visibility into your Kafka ecosystem and concentrates all of the Kafka APIs into a single interface. Troubleshoot and debug Kafka, drill-down into topic data, and continuously monitor your streaming applications. 

Conduktor supports all Kafka providers (Apache Kafka, MSK, Confluent, Aiven, Redpanda, Strimzi etc.)

![image](https://repository-images.githubusercontent.com/530997875/bd058e18-34c8-434d-a844-92303767167d)


# 👩‍💻 Get Started

You have two options for getting started:

1. Quick-Start: Preconfigured with embedded Redpanda + Datagen
```` shell
# Start Conduktor in seconds, powered with Redpanda
curl -L https://releases.conduktor.io/quick-start -o docker-compose.yml && docker compose up
````

2. Console Only: Start Conduktor and connect your own Kafka
```` shell
# Start Conduktor and connect it to your own Kafka
curl -L https://releases.conduktor.io/console -o docker-compose.yml && docker compose up
````

Once started, you can access the console at **http://localhost:8080**

See our [docs](https://docs.conduktor.io/) for more information on
 - [Configuring your Kafka cluster](https://docs.conduktor.io/platform/installation/get-started/docker/#step-3-configure-your-existing-kafka-cluster)
 - [User authentication (SSO, LDAP)](https://docs.conduktor.io/platform/category/user-authentication/)
 - [Environment variables](https://docs.conduktor.io/platform/configuration/env-variables/) 
 - [Deployment methods](https://docs.conduktor.io/platform/category/get-started/)

# 🆘 Looking for help?

* [Console Changelog](https://www.conduktor.io/changelog)
* [Console Documentation](https://docs.conduktor.io/)
* Contact us for anything else: support@conduktor.io

# Going further

For deeper exploration, take a look at these curated lists:
- Kafka Connect connectors: https://github.com/conduktor/awesome-kafka-connect
- Apache Kafka resources, tools, libraries, and applications: https://github.com/conduktor/awesome-kafka

# Get Involved

* Follow <a href="https://twitter.com/getconduktor">@getconduktor on Twitter</a>
* Read the Conduktor <a href="https://www.conduktor.io/blog">blog</a>
* Looking for a job? <a href="https://www.conduktor.io/careers">careers</a>
* Learning Apache Kafka? We have a whole <a href="https://www.conduktor.io/kafka">learning website</a> dedicated for you!
