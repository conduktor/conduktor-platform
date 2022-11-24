## Upgrading Conduktor Platform.

### Release cadence 
Conduktor plans to provide a new release at least monthly.  We suggest that upgrades are done at least bi-monthly.

### Upgrade process
Conduktor Platform is released as a Docker container, the process for upgrading from one release to the next is:


```sh
docker pull conduktor/conduktor-platform
docker restart conduktor/conduktor-platform
```