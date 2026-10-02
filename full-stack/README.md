# Full Conduktor stack

A single Docker Compose file running every Conduktor component together, with the infrastructure they need:

| Service                 | Component                                | Host endpoint                    |
| ----------------------- | ---------------------------------------- | -------------------------------- |
| `conduktor-console`     | Conduktor Console                        | http://localhost:8080            |
| `conduktor-gateway`     | Conduktor Gateway (admin API)            | http://localhost:8888            |
| `schema-registry-proxy` | Conduktor Schema Registry Proxy          | http://localhost:7070            |
|                         | (Prometheus metrics)                     | http://localhost:9464/metrics    |
| `conduktor-monitoring`  | Cortex, Console's metrics and alerting   | internal only                    |
| `kafka`                 | Apache Kafka (KRaft, single node)        | `localhost:19092`                |
| `schema-registry`       | Confluent Schema Registry                | http://localhost:8081            |
| `keycloak`              | Keycloak, JWT issuer for the proxy       | http://localhost:8180            |
| `postgresql`            | PostgreSQL, Console's database           | internal only                    |

Gateway's Kafka listener (`conduktor-gateway:6969`) is only reachable from inside the Compose network.
To use it, run Kafka clients in a container on that network, e.g. `docker compose exec kafka kafka-topics --bootstrap-server conduktor-gateway:6969 --list`.

> **Not for production.** Every credential below is a deliberately weak default, traffic is plaintext HTTP/Kafka, and Kafka does not authenticate clients.

## Start

A Conduktor license is required. It is read from `full-stack/.env`, which is git-ignored. Do not put the license in `docker-compose.yml`.

```shell
cd full-stack
cp .env.example .env    # then set CONDUKTOR_LICENSE in .env
docker compose up -d --wait
```

Stop with `docker compose down`, or `docker compose down -v` to also delete all data.

## Credentials

| What                          | Username / client ID   | Password / secret |
| ----------------------------- | ---------------------- | ----------------- |
| Console                       | `admin@conduktor.io`   | `adminP4ss!`      |
| Gateway admin API             | `admin`                | `conduktor`       |
| Keycloak admin console        | `admin`                | `admin`           |
| Keycloak client (realm `conduktor`) | `app-a`          | `app-a-secret`    |
| Keycloak client (realm `conduktor`) | `app-b`          | `app-b-secret`    |
| PostgreSQL                    | `conduktor`            | `change_me`       |

## How the pieces fit

- Console manages two clusters, both the same Kafka: `local-kafka` (direct) and `cdk-gateway` (via Gateway).
- Clients call the Schema Registry Proxy with a Keycloak JWT. The proxy identifies them by the `preferred_username` claim, which for a client-credentials token is `service-account-<client-id>`. It forwards authorized requests to the Confluent Schema Registry.
- Proxy permissions are granted in Console through self-service. Console publishes them to the proxy over Kafka (`_conduktor_srp_commands`), and the proxy announces itself on `_conduktor_srp_events`.
- The Confluent Schema Registry is also exposed directly on port 8081, without authentication.

## Try it

Get a token and call the proxy. With no permissions granted, writes are denied:

```shell
TOKEN=$(curl -s -d grant_type=client_credentials -d client_id=app-a -d client_secret=app-a-secret \
  http://localhost:8180/realms/conduktor/protocol/openid-connect/token | jq -r .access_token)

curl -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/vnd.schemaregistry.v1+json' \
  -d '{"schema":"{\"type\":\"string\"}"}' \
  http://localhost:7070/subjects/orders-value/versions
# 403 Forbidden
```

Grant `app-a` the `orders` prefix with the [Conduktor CLI](https://docs.conduktor.io/platform/reference/cli-reference/), then repeat the request:

```shell
export CDK_BASE_URL=http://localhost:8080 CDK_USER=admin@conduktor.io CDK_PASSWORD='adminP4ss!'
conduktor apply -f self-service/app-a.yaml
# app-a can now read and write orders-* subjects; app-b still cannot
```
