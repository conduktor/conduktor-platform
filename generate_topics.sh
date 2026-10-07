#!/bin/bash

# Script to generate 1000 unique Kafka topic YAML configurations
# Usage: ./generate_topics.sh [output_file]

# Set default output file if not provided
OUTPUT_FILE=${1:-"kafka_topics_1000.yaml"}

# Clear the output file
> "$OUTPUT_FILE"

echo "Generating 1000 Kafka topic configurations..."

# Generate 1000 topics (numbered 1-1000)
for i in {1..1000}; do
    cat >> "$OUTPUT_FILE" << EOF
---
apiVersion: v2
kind: Topic
metadata:
  name: emma-performance-testing-$i
  cluster: local
  labels:
    myLabel: yo
    conduktor.io/application: yo
    catalogVisibility: PUBLIC
spec:
  partitions: 3
  replicationFactor: 1
  configs:
    cleanup.policy: "delete"
EOF
done

echo "Successfully generated 1000 topic configurations in '$OUTPUT_FILE'"
echo "File size: $(du -h "$OUTPUT_FILE" | cut -f1)"
echo "Number of topics: $(grep -c "name: emma-performance-testing-" "$OUTPUT_FILE")"
