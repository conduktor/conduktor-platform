# 🚀 Conduktor SQL Alpha 

This alpha introduces SQL as a first-class citizen in Conduktor for exploration, troubleshooting and quality purposes. It also makes your Kafka data accessible via API to integrate with your existing dashboards and pipelines (e.g. Grafana, Apache Superset, dbt). 

Note that all SQL queries provides an ad-hoc view of the data inside Kafka at query execution time, it is not a replacement for SQL processing, i.e. push queries (ksqlDB, Flink, Spark).

# Why 

 - Our intention is to reconcile Kafka data with those using SQL (everyone knows SQL, right?)
 - Converge Kafka data at source with Analytics data, eliminating unnecessary data pipelines
 - Simplify access to data while also facilitating the development towards 'data as a product'
 - Faster resolution of Kafka troubleshooting (message data and metadata) through SQL 

# How

## Run
```
docker compose up
```

## Query data inside Conduktor

When the container is up, you will find a new SQL tab inside the Console interface:

![condukor-sql-quickstart-min](https://github.com/conduktor/kafka-security-manager/assets/2573301/c33d643a-b964-430e-804c-a921cfd819b7)

Run a `DESCRIBE <table>` query to view the underlying schema, note that you can also query message metadata such as:
 - partition, offset, key
 - batch compression type, batch size
 - schemaId


## Query data outside Conduktor (Clickhouse, MySQL, PostgreSQL)

To access your Kafka data via SQL outside Conduktor, you can use either clickhouse, mysql or postgres connections.

**Host**: `conduktor-sql`

**Ports**:
| Connection | Port |
|----------|----------|
| Clickhouse HTTP    | `8123`    |
| Clickhouse native    | `9000`    |
| mysql    | `9004`    |
| postgres    | `9005`    |

Note that it's recommended to use Clickhouse or mysql for the best experience today. 

**Database**: `<your cluster name inside Conduktor>`

**Authentication**: For Clickhouse, you can use the same credentials used to log into Conduktor. For mysql and postgres, you should use the environment variables from the docker compose (i.e. default values of `conduktor` and `change_me`). 

## Want to discuss this Alpha? Need support?

We'd love to chat, get in [contact](https://www.conduktor.io/contact/demo/) with us.








