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

Kafka and Gateway both require SASL/PLAIN. Client configs for each Kafka user are in [`clients/`](clients/), and are mounted into the `kafka` container at `/clients`.
Gateway's Kafka listener (`conduktor-gateway:6969`) is only reachable from inside the Compose network, so run clients in a container on that network:

```shell
docker compose exec kafka kafka-topics --bootstrap-server conduktor-gateway:6969 \
  --command-config /clients/admin.properties --list
```

From the host, Kafka is at `localhost:19092` with the same client configs.

> **Not for production.** Every credential below is a deliberately weak default, and all traffic is unencrypted (no TLS).

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
| Kafka (SASL/PLAIN, super user) | `admin`               | `admin-secret`    |
| Kafka (SASL/PLAIN)            | `app-a`                | `app-a-secret`    |
| Kafka (SASL/PLAIN)            | `app-b`                | `app-b-secret`    |
| Schema Registry (basic auth)  | `admin-sr`             | `sr-secret`       |
| Keycloak admin console        | `admin`                | `admin`           |
| Keycloak client (realm `conduktor`) | `app-a`          | `app-a-secret`    |
| Keycloak client (realm `conduktor`) | `app-b`          | `app-b-secret`    |
| PostgreSQL                    | `conduktor`            | `change_me`       |

## How the pieces fit

- Console manages two clusters, both the same Kafka: `local-kafka` (direct) and `cdk-gateway` (via Gateway).
- Kafka enforces ACLs. `admin` is a super user, used by every Conduktor component and by the Schema Registry. `app-a` and `app-b` start with no access.
- Gateway authenticates clients against Kafka with their own credentials (`KAFKA_MANAGED`), so Kafka ACLs apply to traffic through Gateway too.
- Clients call the Schema Registry Proxy with a Keycloak JWT. The proxy identifies them by the `azp` claim, the Keycloak client ID, which matches the client's Kafka username (`app-a`, `app-b`). It forwards authorized requests to the Confluent Schema Registry as `admin-sr`.
- Access is granted in Console through self-service. One ApplicationInstance creates Kafka ACLs for the service account and publishes the matching schema permissions to the proxy over Kafka (`_conduktor_srp_commands`). The proxy announces itself on `_conduktor_srp_events`.
- The Confluent Schema Registry is also exposed directly on port 8081, protected by basic auth.

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
# app-a can now read and write orders-* topics, consumer groups and subjects; app-b still cannot
```

Topics are not auto-created through Gateway. Create them as `admin` first:

```shell
docker compose exec kafka kafka-topics --bootstrap-server kafka:29092 \
  --command-config /clients/admin.properties --create --topic orders --partitions 1
```
