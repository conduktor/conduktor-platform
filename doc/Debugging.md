# How to debug Conduktor platform 
## Verify platform is up and running.

For this example we'll use  [Conduktor's example-local](https://github.com/conduktor/conduktor-platform/tree/main/example-local).

First step verify that all the components are running.
```sh 
mitch@m1-mbp example-local % docker-compose ps
NAME                                 COMMAND                  SERVICE              STATUS              PORTS
example-local-conduktor-platform-1   "/opt/conduktor/scri…"   conduktor-platform   running (healthy)   0.0.0.0:8080->8080/tcp
example-local-kafka-1                "/opt/conduktor/scri…"   kafka                running             0.0.0.0:9092-9093->9092-9093/tcp, 0.0.0.0:9101->9101/tcp, 9999/tcp
example-local-schema-registry-1      "/etc/confluent/dock…"   schema-registry      running             0.0.0.0:8081->8081/tcp
example-local-zookeeper-1            "/docker-entrypoint.…"   zookeeper            running             2888/tcp, 3888/tcp, 0.0.0.0:2181->2181/tcp, 8080/tcp
```

If you are using an external Kafka installation you will only need to verify that the "conduktor-platform" container is showing "healthy" as the STATUS.

If anything is not showing or showing "exited" as the status, a good first step is to check the `docker logs` output with `docker logs ${CONDUKTOR_PLATFORM_CONTAINER_NAME}`, for example in the example-local docker it would be `docker logs example-local-conduktor-platform-1`.  These logs can be saved to a file with `docker logs example-local-conduktor-platform-1 >& docker-logs-output.txt`.

## Check services within the Conduktor-platform container
First we will need to invoke a shell within the Conduktor-platform container.  This is a short cut to do this:
```sh
docker exec -it `docker ps |grep conduktor-platform|awk '{ print $1 }'` /bin/bash
```
The other option is to `docker exec -it ${CONTAINER_ID} /bin/bash`

From within the container the first step should be verify that all expected services are started.  Conduktor platform uses supervisord inside of the container to ensure various services are started:
```sh
root@15012271cc24:/# supervisorctl
admin-portal                     RUNNING   pid 32, uptime 0:49:39
alertmanager                     RUNNING   pid 43, uptime 0:49:39
authenticator                    RUNNING   pid 29, uptime 0:49:39
console                          RUNNING   pid 33, uptime 0:49:39
cortex                           RUNNING   pid 47, uptime 0:49:39
crond                            EXITED    Nov 07 07:33 PM
data_masking                     FATAL     Exited too quickly (process log may have details)
governance_api                   FATAL     Exited too quickly (process log may have details)
kafka_lag_exporter               RUNNING   pid 71, uptime 0:49:39
kafka_monitoring_api             RUNNING   pid 31, uptime 0:49:39
platform_api                     RUNNING   pid 39, uptime 0:49:39
postgresql                       RUNNING   pid 28, uptime 0:49:39
prometheus                       RUNNING   pid 41, uptime 0:49:39
proxy                            RUNNING   pid 72, uptime 0:49:39
testing                          RUNNING   pid 35, uptime 0:49:39
testing-agent                    RUNNING   pid 38, uptime 0:49:39
topic_scanner                    RUNNING   pid 69, uptime 0:49:39
supervisor>
```

In the above example you can see that data_masking and governance_api failed to start.  This tells us what log files will be most important.  
Logs are kept in /var/conduktor/log

For example
```sh
 cat /var/conduktor/log/data_masking-stdout---supervisor-gm63c0c8.log
```
There is a `stdout` & and a `stderr` file for each services (APIs)
the last part `-supervisor-gm63c0c8` is just a random run ID.

This log should contain the information necessary to work with support@conduktor.io or self trouble shoot the issue.

