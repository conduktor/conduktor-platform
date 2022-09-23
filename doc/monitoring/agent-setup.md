## Monitoring Agent Setup

You should install the Agent to use Monitoring at full capacity.

[Find out](monitoring.md) what metrics you will have access to depending on your infra.

***

### :one: Download the agent and its configuration

Create a new directory for jmx-exporter

```mkdir /opt/jmx-exporter```

Download the jar into your newly generated directory

```curl https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.17.0/jmx_prometheus_javaagent-0.17.0.jar -o/opt/jmx-exporter/jmx_prometheus_javaagent-0.17.0.jar```

Download the associated monitoring configuration file

```curl http://demo.conduktor.io/monitoring/kafka-broker.yml -o /opt/jmx-exporter/kafka-broker.yml```

***

### :two: Setup your Kafka service

Your kafka server must start with the following javaagent:

```-javaagent:/opt/jmx-exporter/jmx_prometheus_javaagent-0.17.0.jar=9101:/opt/jmx-exporter/kafka-broker.yml```

For instance, you can set the environment variable:

```KAFKA_OPTS=-javaagent:/opt/jmx-exporter/jmx_prometheus_javaagent-0.17.0.jar=9101:/opt/jmx-exporter/kafka-broker.yml```

***

### :three: Setup Node Exporter (Optional)

Install Prometheus node exporter on your server (apt based systems)

```apt install prometheus-node-exporter```

Note on other systems you can install it manually (<a href="https://prometheus.io/docs/guides/node-exporter/#installing-and-running-the-node-exporter">docs</a>).

⚠️ Node exporter can be started with its default configuration and should listen on port 9100. However, you may want to select which filesystems are monitored. You can use the --collector.filesystem.mount-points-exclude=... option for this.




