### URL
Conduktor Platform is available on [http://localhost:8080](http://localhost:8080)

Note if you want to reach secure Kafka clusters, you should use the [configuration file](Configuration.md) or add them within the UI at [http://localhost:8080/admin/clusters](http://localhost:8080/admin.clusters).

### Local Kafka on Linux

Connect to an unsecured kafka cluster accessible on `0.0.0.0:9092`
```sh
 docker run --rm \
  --network host \
  -e LICENSE_KEY="<your-license>" \
  -e KAFKA_BOOTSTRAP_SERVER=0.0.0.0:9092 \
  conduktor/conduktor-platform:latest
```

### Local Kafka on MacOS
There are 2 scenarios depending on where you Kafka cluster is deployed.  
#### Kafka in docker
First identify in which network Kafka is running
```sh
$ docker network ls
NETWORK ID     NAME                     DRIVER    SCOPE
c0da546f2f6f   bridge                   bridge    local
d3e3ba5279fd   host                     host      local
95c94aec5f17   kafka_default            bridge    local
```
Then identify the advertised hostname of Kafka (Kafka config KAFKA_ADVERTISED_LISTENERS)  
`KAFKA_ADVERTISED_LISTENERS: INTERNAL://kafka:9092,OUTSIDE://localhost:9094`  
This is often `kafka` or `kafka1`  
Finally, run the Conduktor Platform using the information you collected
```sh
 docker run --rm \
  -p "8080:80" \
  -e LICENSE_KEY="<your-license>" \
  -e KAFKA_BOOTSTRAP_SERVER=<advertised-host>:<advertised-port> \
  --network <network-id> \
  conduktor/conduktor-platform:latest
```
#### Kafka on the host

The only way to reach the MacOS host from inside a docker image is to use the alias `host.docker.internal`.  
Unfortunately, Kafka requires you to perform an extra step to modify the advertised listener.  
[Kafka Listeners – Explained](https://www.confluent.io/blog/kafka-listeners-explained/)  
Edit the server.properties file and look for the line `advertised.listeners`.
````sh 
$ cat server.properties | grep advertised
advertised.listeners=INTERNAL://127.0.0.1:9092
````
Append a listener after the existing one
````
advertised.listeners=INTERNAL://127.0.0.1:9092,PLAINTEXT://host.docker.internal:9093
````
Restart Kafka and run Conduktor Platform with the following command
```sh
 docker run --rm \
  -p "8080:80" \
  -e LICENSE_KEY="<your-license>" \
  -e KAFKA_BOOTSTRAP_SERVER=host.docker.internal:9093 \
  conduktor/conduktor-platform:latest
```
### Advanced configuration (SASL_SSL, SSL clusters, registry, connect, ...)
Conduktor platform can be configured using with a yaml file to define
- organization
- kafka clusters
- sso (ldap/oauth2)
- license

Generate your `platform-config.yaml` using our [Configuration Documentation](./Configuration.md) and samples.

Once you have your file ready, you can just start the platform using this simple command line:
````
 docker run --rm \
   --mount "type=bind,source=$PWD/platform-config.yaml,target=/opt/conduktor/default-platform-config.yaml" \
  conduktor/conduktor-platform:latest
````
or the following docker compose equivalent `docker-compose up -d`
````yaml
version: '3.8'
services:
  conduktor-platform:
    image: conduktor/conduktor-platform:latest
    ports:
      - 8080:80
    volumes:
      - conduktor_data:/var/conduktor
      - ./platform-config.yaml:/opt/conduktor/platform-config.yaml
    environment:
      CDK_IN_CONF_FILE: /opt/conduktor/platform-config.yaml
````
