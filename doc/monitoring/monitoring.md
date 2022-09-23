## Conduktor Monitoring

Conduktor Monitoring gives you insight into the most significant Kafka metrics. 
Note that what you are able to access will depend on your Kafka infrastructure. 

### Metrics 

Below details the metrics and graphs that you should expect to see populated depending on your infrastructure:

- [Out-of-the-box Monitoring](#header-1)
- [With the Monitoring Agent](#header-2)
- [With the Monitoring Agent + Node Exporter](#header-3)

### Agent Setup

- [Learn how to setup the Monitoring Agent](#header-1)


***

### <a name="header-1">Out-of-the-box Monitoring</a>

When you launch Conduktor Platform and connect a Kafka cluster, you will be able to view some metrics in Monitoring with **no additional setup**. 

| Metrics      | Description | Availability     |
|    :----:   |    :----:   |    :----:   |
| Apps Monitoring      | Provides active monitoring of consumer lag for your applications       | :white_check_mark:   |

Note that:
- Apps Monitoring: Supports all Kafka flavours :white_check_mark:
    - _except those that are not currently supported by Conduktor Platform_
    - _specifically, MSK + IAM_ ⚠️



***


  ### <a name="header-2">With the Monitoring Agent</a>

Install the Monitoring Agent to use Monitoring at full capacity. 

Completing this step will give you access to:

| Metrics      | Description | Availability     |
|    :----:   |    :----:   |    :----:   |
| Apps Monitoring      | Provides active monitoring of consumer lag for your applications       | :white_check_mark:   |
| Cluster Health - Activity   | Provides insight into producer activity| :white_check_mark:      |
| Cluster Health - Partitions Health   | Provides insight into offline partitions and under replicated partitions        | :white_check_mark:       |
| Cluster Health - Disk   | Provides insight into a Kafka brokers disk durability         | ❌      |
| Cluster Health - Partitions Distribution   | Provides insight into the total number of partitions across your cluster        | :white_check_mark:       |
| Cluster Health - Capacity   | Provides insight into the number of active brokers, partitions and controllers        | ❌      |

Note that the Monitoring Agent supports: 

| Kafka      | Availability |
|    :----:   |    :----:   |
| Open-Source Apache Kafka      | :white_check_mark:       |
| Confluent OSS      | :white_check_mark:       |

***

### <a name="header-3">With the Monitoring Agent & Node Exporter</a>

Setting up node exporter is another optional configuration. This will also enable you to monitor **Disk** & **Capacity** metrics. 


| Metrics      | Description | Availability     |
|    :----:   |    :----:   |    :----:   |
| Apps Monitoring      | Provides active monitoring of consumer lag for your applications       | :white_check_mark:   |
| Cluster Health - Activity   | Provides insight into producer activity| :white_check_mark:      |
| Cluster Health - Partitions Health   | Provides insight into offline partitions and under replicated partitions        | :white_check_mark:       |
| Cluster Health - Disk   | Provides insight into a Kafka brokers disk durability         | :white_check_mark:      |
| Cluster Health - Partitions Distribution   | Provides insight into the total number of partitions across your cluster        | :white_check_mark:       |
| Cluster Health - Capacity   | Provides insight into the number of active brokers, partitions and controllers        | :white_check_mark:      |


Node Exporter supports: 

| Kafka      | Availability |
|    :----:   |    :----:   |
| Open-Source Apache Kafka      | :white_check_mark:       |
| Confluent OSS      | :white_check_mark:       |


***
