# Browse Data

The Conduktor Platform enables you to view messages in Kafka Topics.

By default, the most recent 20 messages of a topic are displayed.
You can refine your search depending on the amount of records in your topic combining the filters at your disposal.

All filters are persisted across sessions for each topic.

## Filtering

- [Max Records](#max-records)
- [Show From](#show-from)
- [Partitions](#partitions)
- [JS Filters](#js-filters)
- [Quick search](#quick-search)


### Max Records
This filter restricts the number of record returned to the browser. You can increase that number up to a maximum of 1000.

### Show From
Positions the consumer any given point in time, returning up to `max-records` records to the browser.
- Most Recent: Consume from the end of the topic to always provide you with the `max-records` most recent records. 
  - Each partition is queried equally: Most recent 1000 records in a 5 partitions topics: 200 most recent records of each partition
- Last Hour / Today / Yesterday: Starts from a relative time in the past
- From Specific Date / From Timestamp: Starts from an absolute time in the past
- From Beginning: Starts from the very beginning of the topic
- From Offset: Starts from a specified offset (best used combined with [Partitions](#partitions))
- From Consumer Group: Starts from the last committed offsets of selected Consumer Group. 
  - This is very useful to troubleshoot a stopped application and understand "where" it's stopped.

### Partitions
If you know the partition you want to browse, this filter will help you reduce the number of records returned to the browser.  
This filter is available behind the "More options" button.

### JS Filters
JavaScript Filters lets you perform complex search on the json representation of the record, including its metadata.   
This lets you quickly search through several thousands of records without directly viewing them in your browser.  
This is the recommended way to filter through topics with more than a several thousands records per day.    
A few examples:

````js
// Matches Paris, Palermo, Pasadena
return value.City.startsWith("Pa")
// Has Header "sender" with value "Conduktor"
return headers.sender == "Conduktor"
````

Check the embedded documentation in Conduktor Platform for more details.

### Quick search
This filter performs a plaintext search on the records already sent to the browser.
It is best used combined with any previous filtering applied.

## Deserialization

By default, we try to identify the Deserializer automatically for both the Key and the Value.  

If the deserialization fails or doesn't represent the data as you expect, you can manually pick which deserializer to use.  
Deserializers are available behind the "More options" button.
