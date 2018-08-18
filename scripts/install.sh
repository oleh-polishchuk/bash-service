#!/usr/bin/env bash

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

# -------------------- #
#   JSON parse tool
# -------------------- #
installJq() {
    if [ "$(getOsName)" = "OSX" ]; then
        brew install jq

    elif [ "$(getOsName)" = "LINUX" ]; then
        sudo apt-get install jq -y

    fi
}

######

echo "==> Installing required dependencies..." \
    && installJq \
    && echo "...Done!"
