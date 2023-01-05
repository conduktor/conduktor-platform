#!/usr/bin/env bash
set -e

PLATFORM_CONTAINER_ID=$(docker container ls -a --filter "name=conduktor-platform" --filter "status=running" --format "{{.ID}}")

if [ -z "$PLATFORM_CONTAINER_ID" ]; then
    echo "Platform container not found"
    exit 1
fi

echo "Platform container found: $PLATFORM_CONTAINER_ID"

echo "Stop SSO"
docker exec -it "$PLATFORM_CONTAINER_ID" /bin/bash -c 'source /etc/profile && supervisorctl stop authenticator'

DEBUG_CONFIG=$(cat << EOF
logger:
  levels:
    io.micronaut.security: TRACE
    io.micronaut.security.ldap: TRACE
EOF
)

echo "Update SSO config"
echo -e "$DEBUG_CONFIG" | docker exec -i "$PLATFORM_CONTAINER_ID" /bin/bash -c 'cat >> /var/conduktor/configs/authenticator.yml'

echo "Start SSO"
docker exec -it "$PLATFORM_CONTAINER_ID" /bin/bash -c 'source /etc/profile && supervisorctl start authenticator'

docker exec -it "$PLATFORM_CONTAINER_ID" /bin/bash -c 'tail -f /var/conduktor/log/authenticator*.log'
