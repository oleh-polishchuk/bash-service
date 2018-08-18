#!/usr/bin/env bash

# ------------------------------------------------------------------------------------------------------------------- #
#   Input variables
# ------------------------------------------------------------------------------------------------------------------- #
COMMAND=$1
ACTION=$2

# ------------------------------------------------------------------------------------------------------------------- #
#   Constants
# ------------------------------------------------------------------------------------------------------------------- #
HOSTS="/etc/hosts"
CONFIG=~/.siri_config.json

# ------------------------------------------------------------------------------------------------------------------- #
#   Functions
# ------------------------------------------------------------------------------------------------------------------- #

##
# Function return operation system name in readable way
#
getOsName() {
    case "$OSTYPE" in
      solaris*) echo "SOLARIS" ;;
      darwin*)  echo "OSX" ;;
      linux*)   echo "LINUX" ;;
      bsd*)     echo "BSD" ;;
      msys*)    echo "WINDOWS" ;;
      *)        echo "unknown: $OSTYPE" ;;
    esac
}

savePassword() {
    if [ -z "$1" ]; then
        echo "==> ERROR: Password is not provided!"
        exit 1
    fi

    echo "==> Saving password into file $CONFIG..." \
        && echo "{\"rootPassword\":\"$1\"}" > ${CONFIG} \
        && echo "...Done!"
}

##
# JSON parse tool
#
installJq() {
    if [ "$(getOsName)" = "OSX" ]; then
        brew install jq

    elif [ "$(getOsName)" = "LINUX" ]; then
        sudo apt-get install jq -y

    fi
}

addSite() {
    if [ -z "$1" ]; then
        echo "==> ERROR: Site name is not provided!"
        exit 1
    fi

    echo "==> Adding site $1 into file $HOSTS..." \
        && echo ${ROOT_PASSWORD} | sudo -S sh -c "echo '127.0.0.1  $1 www.$1' >> '${HOSTS}'" \
        && echo "...Done!"
}

removeSite() {
    if [ -z "$1" ]; then
        echo "==> ERROR: Site name is not provided!"
        exit 1
    fi

    echo "==> Removing site $1 into file $HOSTS..." \
        && echo ${ROOT_PASSWORD} | sudo -S sh -c "sed -i '' '/$1/d' '${HOSTS}'" \
        && echo "...Done!"
}

executeInstall() {
    echo "==> Installing required dependencies..." \
        && installJq \
        && echo "...Done!"
}

executeHosts() {
    case "$1" in
      add)
            removeSite $2
            addSite $2
            ;;
      remove)
            removeSite $2
            ;;
      *)
            echo $"Usage: $0 {add|remove}"
            exit 1
            ;;
    esac
}

# ------------------------------------------------------------------------------------------------------------------- #
#   Initialization
# ------------------------------------------------------------------------------------------------------------------- #
if [ -f ${CONFIG} ]; then
    ROOT_PASSWORD=$(cat ${CONFIG} | jq --raw-output '.rootPassword')
else
    echo "Please, provide root password:"
    read ROOT_PASSWORD
    savePassword ${ROOT_PASSWORD}
fi

case "$COMMAND" in
  install)
        executeInstall
        ;;
  hosts)
        executeHosts $2 $3
        ;;
  *)
        echo $"Usage: $0 {install|hosts}"
        exit 1
        ;;
esac
