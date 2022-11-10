# How to supply a JKS for LDAPS

## 1. Generate a JKS from the certificate (or certificates)
The goal is to create a single jks file with all necessary certificates inside.
Repeat this operation for each .pem or .crt file at your disposal. Change the alias for each certificate.
When asked for a password, just type "changeit", securing the certificate store is not important.

## 2. Run the authentication module with JAVA_OPTS
Now edit the docker-compose.yml file to mount the file in the docker image and reference the truststore into the java program. 
Leave pre-existing volumes mounts or environments vars untouched

```yaml
version: '3.8'

services:
  conduktor-platform:
    image: conduktor/conduktor-platform:1.4.0
    ports:
      - 8080:8080
    volumes:
      - ./truststore.jks:/opt/conduktor/truststore.jks
    environment:
      AUTHENTICATOR_JAVA_OPS: -Djavax.net.ssl.trustStore=/opt/conduktor/truststore.jks -Djava.net.ssl.trustStorePassword=changeit
```

## 3. Restart the platform and check the logs
Use this simple command to filter out the non-"authenticator" logs
```sh
docker compose down && docker compose up -d
docker compose logs --follow | grep authenticator -A 50
```

## Trouble shooting

### JKS not mounted correctly
If the JKS is not mounted correctly you will see something like the below.  If this is the case verify that you have the correct JKS file, and it's in the container located at /opt/conduktor/truststore.jks
```
platform-conduktor-platform-1  | 20:00:49.397 [scheduled-executor-thread-1] ERROR i.micronaut.scheduling.TaskExecutors - Error occurred executing @Async method [void onSuccess(LoginSuccessfulEvent event)]: Inaccessible trust store: /opt/conduktor/truststore-wrong.jks See https://www.graalvm.org/reference-manual/native-image/CertificateManagement#runtime-options for more details about runtime certificate management.
platform-conduktor-platform-1  | com.oracle.svm.core.jdk.UnsupportedFeatureError: Inaccessible trust store: /opt/conduktor/truststore-wrong.jks See https://www.graalvm.org/reference-manual/native-image/CertificateManagement#runtime-options for more details about runtime certificate management.
platform-conduktor-platform-1  | 	at com.oracle.svm.core.util.VMError.unsupportedFeature(VMError.java:89)
```