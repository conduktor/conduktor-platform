# Run conduktor platform locally with LDAP

This example run conduktor-platform using an LDAP SSO configuration providing users for login.

### Requirements

See [here](../README.md#requirements-📑)


### Configuration 

For example purpose the LDAP used is from [zflexldap](https://www.zflexldapadministrator.com/index.php/blog/82-free-online-ldap)

Login accounts are :

| Username | Password         |
|----------|------------------|
| `guest1` | `guest1password` |
| `guest3` | `guest3password` |

LDAP configuration can be found in [platform-config.yml](platform-config.yaml) under `sso.ldap` key.

```yaml
sso:
  ldap:
    - name: "default"                                                # Custom name for ldap connection
      server: "ldap://www.zflexldap.com:389"                         # LDAP server URI with port
      managerDn: "cn=ro_admin,ou=sysadmins,dc=zflexsoftware,dc=com"  # Bind DN 
      managerPassword: "zflexpass"                                   # Bind Password
      search-base: "ou=users,ou=guests,dc=zflexsoftware,dc=com"      # Base DN to search for users
      groups-base: "ou=groups,ou=guests,dc=zflexsoftware,dc=com"     # Base DN to search for groups
```

### Usage

Run conduktor platform :    
Replace `<your license key>` with the license provided
```sh
./run-local.sh "<your license key>"
```

Stop conduktor platform
```sh
./stop-local.sh
```

If you want to delete all conduktor platform data
```sh
./rm-local.sh
```
