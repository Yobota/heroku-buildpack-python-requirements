#!/usr/bin/env bash

# Functions to call the Heroku API

HEROKU_URL="https://api.heroku.com/"
HEROKU_VERSION_HEADER="Accept: application/vnd.heroku+json; version=3"
HEROKU_AUTH_HEADER="Authorization: Bearer $HEROKU_TOKEN"

heroku-api() {
    local endpoint=$1
    local method=$2
    local option=$3
    local status_only=false
    local args=()

    if [ -n "$option" ]; then
        if [ "$option" == "STATUS" ]; then
            status_only=true
        fi
    fi

    if $status_only; then
        args+=(--head)
        args+=(--output /dev/null)
        args+=(--write-out %{http_code}) 
    fi

    args+=(--silent)
    args+=(--request $method)


    curl ${args[@]} \
        -H "$HEROKU_AUTH_HEADER" \
        -H "$HEROKU_VERSION_HEADER" \
        ${HEROKU_URL}${endpoint}
}

configure-jq() {

    local word_size=$(getconf LONG_BIT)
    local executable

    if [ $word_size -eq 64 ]; then
        executable=jq-linux64
    elif [ $word_size -eq 32 ]; then
        executable=jq-linux32
    else
        echo jq not available for architecture $word_size
        exit 1
    fi

    mkdir --parents ./bin
    PATH=$PATH:./bin
    ln --symbolic --force ../jq/$executable bin/jq
    chmod +x ./bin/jq
}

configure-jq
