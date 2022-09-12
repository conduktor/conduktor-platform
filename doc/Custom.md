### Connect to an unsecured kafka cluster accessible on `0.0.0.0:9092`
```sh
 docker run --rm \
  --network host \
  -e LICENSE_KEY="<your-license>" \
  -e KAFKA_BOOTSTRAP_SERVER=0.0.0.0:9092 \
  conduktor/conduktor-platform:latest
```

### URL
Conduktor Platform is available on [http://localhost:80](http://localhost:80)


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
      - 80:80
    volumes:
      - conduktor_data:/var/conduktor
      - ./platform-config.yaml:/opt/conduktor/platform-config.yaml
    environment:
      CDK_IN_CONF_FILE: /opt/conduktor/platform-config.yaml
````
