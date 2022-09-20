# Produce Data
Conduktor Platform can help you to send messages into your topic. It's useful to test something without having to write a complete application.

Conduktor supports common Kafka serializers to produce data:  
- String or JSON
- Avro, Protobuf and JSON-Schema
  - As of today, only Confluent or Confluent-like Schema Registry is supported.
  - As of today, only [TopicNameStrategy](https://docs.confluent.io/platform/current/schema-registry/serdes-develop/index.html#subject-name-strategy) is supported by Conduktor Platform.
- Binary (using b64 representation)


### Random Data Generator
The Random Data Generator will quickly let you produce a valid sample message for your serializer.   
Just click the "Generate once" button next to the Serializer dropdown.  
Random Data Generator supports all Serializers, and is possible for records Key and record Value.  
![random-generator.png](random-generator.png)

### Flow mode
Using the Flow mode, you can produce multiple event in a row.

In the following example, the producer is configured like this:
- Produce 2 messages per batch
- Reuse the same Key for all records
- Generate a random Value (using the associated Serializer)
- Send a batch (of 2 records) every seconds
- Stop the producer after 60 seconds

![flow-mode.png](flow-mode.png)