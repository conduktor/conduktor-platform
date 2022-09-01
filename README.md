# What is Conduktor Platform ?

We take the complexity out of Kafka. We give you a platform to build, explore, test, monitor, and collaborate with confidence. 
Simplifying the complexity of real-time data streaming, Conduktor Platform enables leading organizations to improve team productivity and unlock true business value.


Just want to have a look? our demo environment is there : https://demo.stg.apps.cdkt.dev/


# First Steps 

## Requirements 📑

### Software : 
- **docker** : See installation instructions [here](https://docs.docker.com/engine/install/)
- **docker-compose** : See installation instructions [here](https://docs.docker.com/compose/install/)

### Hardware :
- 16 Go RAM
- 4 CPU


## Quick start 🛫

To run conduktor-platform with all feature, contact us ⚠️ TODO : there ⚠️ to get a `private beta license` !

Once you have a `license`, choose the way that fit you : 
* [run in local quick start](./example-local/README.md)


## Platform Standalone & Advanced settings :  

> note :  a docker-compose with a kafka cluster is at your disposal [here](./kafka/docker-compose.yml)

Connect to a local kafka cluster accessible on `0.0.0.0:9092`
```sh
 docker run --rm \
  --network host \
  -e KAFKA_BOOTSTRAP_SERVER=0.0.0.0:9092 \
  conduktor/conduktor-platform:latest
```

Connect to a local kafka & Schema registry
```sh
 docker run --rm \
  --network host \
  -e KAFKA_BOOTSTRAP_SERVER=0.0.0.0:9092 \
  -e SCHEMA_REGISTRY_URL=http://0.0.0.0:8081 \
  conduktor/conduktor-platform
```

Run the platform with persistance between platform run
```sh
docker run --rm \
 --network host \
 -e KAFKA_BOOTSTRAP_SERVER=0.0.0.0:9092 \
 --mount "type=bind,source=$PWD/platform_data,target=/var/conduktor" \
 conduktor/conduktor-platform:latest
```



TODO : 
 docker run example SSO / external kafka etc

 License


## Private beta limitation ⚠️ : 
* All data & settings will be lost at the end of private beta.
* End of private beta : 1 October.
* Do not run conduktor platform against critical production environments
* No Windows support yet.



