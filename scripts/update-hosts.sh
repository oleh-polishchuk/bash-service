#!/usr/bin/env bash

OPERATION_TYPE=$1
SITE=$2
HOSTS="/etc/hosts"

ROOT_PASSWORD=$(cat config.json | jq --raw-output '.rootPassword')

addSite() {
    echo ${ROOT_PASSWORD} | sudo -S sh -c "echo '127.0.0.1  ${SITE} www.${SITE}' >> '${HOSTS}'"
}

removeSite() {
    echo ${ROOT_PASSWORD} | sudo -S sh -c "sed -i '' '/${SITE}/d' '${HOSTS}'"
}

if [ "$OPERATION_TYPE" = "add" ]; then
    removeSite
    addSite
else
    removeSite
fi
