# <img src="https://user-images.githubusercontent.com/2573301/192741305-0e1441a4-308b-4308-947a-656a1dc53577.png" width="25">  What is Conduktor Platform ?

We take the complexity out of Kafka. We give you a platform to build, explore, test, monitor, and collaborate with confidence. 
Simplifying the complexity of real-time data streaming, Conduktor Platform enables leading organizations to improve team productivity and unlock true business value.
<p align="center">
  <a href="https://www.conduktor.io">
    <img src="https://staging.conduktor.io/images/hero/explorer1.png" alt="Conduktor Platform" height="400"/>
  </a>
</p>

---

# 📢 Our Roadmap

We really want our community to be part of our evolution.

Please upvote or comment everything we're doing. WE. ARE. LISTENING.

[I want Conduktor to implement what I need](https://product.conduktor.help/tabs/1-in-development)

---

# 👩‍💻 Get Started

We offer you 3 simple ways to experience Conduktor Platform.

## Online Demo: 1-click away!

Go to https://demo.conduktor.io to experience Conduktor Platform in 1-click, nothing to setup on you side.

A dedicated Kafka cluster is running alongside a few Kafka applications to provide some life and demo everything easily.

## Start with a built-in Apache Kafka cluster

Start docker-compose on your side, with an embedded Apache Kafka, Schema Registry and Kafka Connect.

- [Quick start without cloning the repository](/example-local/autorun/README.md)
- [Take me to the docker-compose](/example-local)

## Connect to your own Apache Kafka cluster

You have your own Apache Kafka clusters and you want to connect them to Conduktor Platform?

- [Connect my clusters to Conduktor Platform](./doc/Custom.md)
- [I need more advanced settings](./doc/Advanced_settings.md)

---

# 🆘 Looking for help?

* [Our Platform Changelog](CHANGELOG.md)
* [Our Platform Documentation](doc/)
* [Contact us for anything else](support@conduktor.io)

---

# Specs

## Hardware requirements

Minimal : 
- 4 CPU cores
- 8 Go of RAM (`RUN_MODE=nano`)
- 5 Go of disk space

Recommended : 
- 4+ CPU cores
- 16+ Go of RAM (`RUN_MODE=small`)
- 10+ Go of disk space

## Platforms ACLs are supported on

* Open Source Apache Kafka
* MSK

## Where does Monitoring work?

Some aspects of Conduktor Monitoring support all flavours of Kafka. Specifically, you will have insight into consumer lag of your applications out-of-the-box.

To use Monitoring at full capacity you must [setup the Monitoring agent](doc/monitoring/monitoring.md). This currently supports open-source Apache Kafka.

[See documentation](doc/monitoring/monitoring.md).

---

# Get Involved

* [Our Roadmap](https://product.conduktor.help/tabs/1-in-development)
* Follow <a href="https://twitter.com/getconduktor">@getconduktor on Twitter</a>
* Read the Conduktor <a href="https://www.conduktor.io/blog">blog</a>
* Looking for a job? <a href="https://www.conduktor.io/careers">careers</a>
* Learning Apache Kafka? We have a whole <a href="https://www.conduktor.io/kafka">learning website</a> dedicated for you!
