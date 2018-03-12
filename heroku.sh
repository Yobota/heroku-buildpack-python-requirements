#!/usr/bin/env bash

# Functions to call the Heroku API

HEROKU_URL="https://api.heroku.com/"
HEROKU_VERSION_HEADER="Accept: application/vnd.heroku+json; version=3"
HEROKU_AUTH_HEADER="Authorization: Bearer $HEROKU_TOKEN"

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

heroku-api() {
    local endpoint=$1
    local method=$2
    local option=$3
    local status_only=false
    local json=false
    local args=()
    local command=cat

    if [ -n "$option" ]; then
        case $option in
            "STATUS")
                status_only=true
                ;;
            "JSON")
                json=true
                local filter=$4
                if [ -z "$filter" ]; then
                    echo a filter is required when using JSON.
                    echo Use \'.\' for passthrough.
                    exit 1
                fi
                ;;
            *)
                echo $option invalid option
                exit 1
                ;;
        esac
    fi

    if $status_only; then
        args+=(--head)
        args+=(--output /dev/null)
        args+=(--write-out %{http_code}) 
    elif $json; then
        command="jq $filter"
    fi

    args+=(--silent)
    args+=(--request $method)


    curl ${args[@]} \
        --header "$HEROKU_AUTH_HEADER" \
        --header "$HEROKU_VERSION_HEADER" \
        ${HEROKU_URL}${endpoint} \
        | $command
}
