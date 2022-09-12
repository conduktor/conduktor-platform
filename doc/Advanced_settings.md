#  Advanced settings


## Run mode
to configure conduktor platform fo a particular hardware, you can use the environment variable 
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
  --network host \
  -e LICENSE_KEY="<your-license>" \
  -e RUN_MODE="small" \
  -e KAFKA_BOOTSTRAP_SERVER=0.0.0.0:9092 \
  conduktor/conduktor-platform:latest
```
### URL
Conduktor Platform is available on [http://localhost:80](http://localhost:80)
