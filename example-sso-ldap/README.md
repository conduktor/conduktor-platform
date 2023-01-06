# Run Conduktor Platform locally with LDAP

This example run conduktor-platform using an LDAP SSO configuration providing users for login.


### Configuration 

The LDAP use in this example is a [OpenLDAP](https://www.openldap.org/) instance running in a docker container.
LDAP configuration can be found in [users.ldif](./custom-ldif/users.ldif) file.

Login accounts are :

| Username | Password    |
|----------|-------------|
| `user01` | `password1` |
| `user02` | `password2` |

LDAP configuration can be found in [platform-config.yml](platform-config.yaml) under `sso.ldap` key.

```yaml
sso:
  ldap:
    - name: "default"                                                 # Custom name for ldap connection           
      server: "ldap://openldap:1389"                                  # LDAP server URI with port
      managerDn: "cn=admin,dc=example,dc=org"                         # Bind DN
      managerPassword: "adminpassword"                                # Bind Password
      search-subtree: true                                            # Enable search in sub-tree
      search-base: "ou=users,dc=example,dc=org"                       # Base DN to search for users
      search-filter: "(uid={0})"                                      # Filter to search for users  
      search-attributes: ["uid", "cn", "mail", "email", "givenName", "sn", "displayName"] # Attributes to retrieve from user
      groups-enabled: true                                            # Enable group search
      groups-base: "ou=groups,dc=example,dc=org"                      # Base DN to search for groups
      groups-filter: "(member={0})"                                   # Filter to search for groups
      groups-attribute: "cn"                                          # Attribute to retrieve from group
```

### Usage

Run Conduktor Platform :    
Replace `<your-license>` with the license provided
```sh
./run-local.sh "<your-license>"
```

Stop Conduktor Platform
```sh
./stop-local.sh
```

If you want to delete all Conduktor Platform data
```sh
./rm-local.sh
```
### URL
Conduktor Platform is available on [http://localhost:8080](http://localhost:8080)

### Debug LDAP connection
If you want to debug LDAP connection on Platform, we provide a [debug SSO script](./sso-debug.sh) that enable TRACE logs for SSO and print Platform logs.

#### Usage
```sh
./run-local.sh "<your-license>"
# wait for platform to be ready on http://localhost:8080
./sso-debug.sh
```
