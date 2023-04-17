# Run Conduktor Platform locally

### Usage

Run Conduktor Platform without installing any file, replace `<your-license>` by a value (without license you will only have free version):

```sh
curl -sS https://raw.githubusercontent.com/conduktor/conduktor-platform/main/example-local/autorun/autorun.sh | \
 LICENSE_TOKEN="<your-license>" bash -s setup
```

For local run, it will ask for inputs (like your license). You can also provide variables: 

```
LICENSE_TOKEN=""
ORGANIZATION_NAME=""
ADMIN_EMAIL=""
ADMIN_PSW=""
```

If you want to delete all Conduktor Platform data
```sh
curl -sS https://raw.githubusercontent.com/conduktor/conduktor-platform/main/example-local/autorun/autorun.sh | sh -s clean
```
### URL
Conduktor Platform is available on [http://localhost:8080](http://localhost:8080)

## Platform Url
[http://localhost:8080/home/](http://localhost:8080/home/)

### Credentials 
use the credentials your provided when running the script

## Requirements

- docker
