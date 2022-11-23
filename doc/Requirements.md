## Conduktor Platform requirements

### Operating system and deployment options.
Conduktor platform is distributed as a [Docker container](https://hub.docker.com/r/conduktor/conduktor-platform).  

As a Docker container it can be deployed nearly anywhere including bare metal, VMs or kubernetes. 

### Resource requirements
The suggest resources for Conduktor Platform is at least:

| Resource | Amount |
| --------- | --------  |
| CPU       | 8 Cores   |
| Memory    |  16Gb |
| Disk  |   100Gb   |

### Database
Conduktor platform utilizes a [Postgres](https://www.postgresql.org/) database for stateful storage of things like RBAC configurations as well as metrics for monitoring and topic analyizer.  By default a Postgres database is built into the Conduktor Platform container.  

If required for scaling reasons, or other reasons there is the ability to externalize the database.  [This document](https://github.com/conduktor/conduktor-platform/blob/main/doc/Environment_Override.md#database-properties) describes the configuration required to configure Conduktor platform to use a stand alone database.

### Network
Conduktor platform requires two network paths, one to your Apache Kafka cluster(s) and one for user access.

For connection to your Apache Kafka cluster you will need to open network rules to allow connections on the same ports your existing clients use, most commmonly  tcp/9092.

Client access is done over port 80 or 443, utilizing the HTTP(S) protocol.

### AWS diagram
A suggested diagram for an AWS deployment looks like:

![AWS Diagram](https://github.com/conduktor/conduktor-platform/tree/main/doc/images/aws_diagram.png)