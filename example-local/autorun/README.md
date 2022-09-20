# Run conduktor platform locally

### Usage

Run Conduktor Platform without installing any file, replace `<your-license>` by a value:

```sh
curl -sS https://raw.githubusercontent.com/conduktor/conduktor-platform/main/example-local/autorun/autorun.sh | \
 LICENSE_KEY="<your-license>" sh -s run
```

**If you have `yq` on your machine, your config (like your license) will be persisted**

For local run, it will ask for inputs (like your license). You can also provide variables: 

```
LICENSE_KEY=""
ORGANISATION_NAME=""
ADMIN_EMAIL=""
ADMIN_PSW=""
```

If you want to delete all conduktor platform data
```sh
curl -sS https://raw.githubusercontent.com/conduktor/conduktor-platform/main/example-local/autorun/autorun.sh | sh -s clean
```
### URL
Conduktor Platform is available on [http://localhost:80](http://localhost:80)

## Platform Url
[http://localhost:8080/home/](http://localhost:8080/home/)

### Credentials 
use the credentials your provided when running the script

## Requirements

- docker