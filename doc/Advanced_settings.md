#  Advanced settings


## Run mode
to configure Conduktor Platform fo a particular hardware, you can use the environment variable 
`RUN_MODE`
| ENV     | Available RAM    |      
|---------|--------------------|
| `nano`    | `8GB`  |
| `small`   | `16GB` |
| `medium`  | `32GB` |
| `large`   | `64GB` |

example : 
```sh
 docker run --rm \
  -p "8080:8080" \
  -e LICENSE_KEY="<your-license>" \
  -e RUN_MODE="small" \
  -e KAFKA_BOOTSTRAP_SERVER=0.0.0.0:9092 \
  conduktor/conduktor-platform:1.5.1
```
### URL
Conduktor Platform is available on [http://localhost:8080](http://localhost:8080)

### Disable a module

All module can be disabled by environment variable.

Default value : 
```sh
      CONSOLE_ENABLED="true"
      TESTING_ENABLED="true"
      MONITORING_ENABLED="true"
      DATA_MASKING_ENABLED="true"
      SCANNER_ENABLED="true"
      GOVERNANCE_ENABLED="true"
```

Example: disable topic scanner
```sh
 docker run --rm \
  -p "8080:8080" \
  -e LICENSE_KEY="<your-license>" \
  -e RUN_MODE="small" \
  -e SCANNER_ENABLED="false" \
  -e KAFKA_BOOTSTRAP_SERVER=0.0.0.0:9092 \
  conduktor/conduktor-platform:1.5.1
```
