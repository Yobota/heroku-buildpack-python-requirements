#!/usr/bin/env bash

source heroku.sh

#echo "Testing heroku-buildpack-python-requirements"

HEROKU_APP="heroku-buildpack-python-requirements"

test_heroku_token() {
    echo - Checking for Heroku OAuth access token
    if [ -n "$HEROKU_TOKEN" ]; then
        echo "Heroku OAuth access token found"
    else
        echo "Heroku OAuth access token missing"
        echo "Check value of HEROKU_TOKEN"
        exit 1
    fi
}

test_heroku_api_connection() {
    echo - check can access a Heroku API endpoint
    local endpoint="apps"

    response=$(heroku-api $endpoint GET STATUS)
    if [ $response -eq 200 ]; then
        echo "GET $endpoint success"
    else
        echo "GET $endpoint $response"
        exit 1
    fi
}

test_heroku_build_app_exists() {
    echo - check the app $HEROKU_APP exists

    local endpoint="apps/$HEROKU_APP"
    response=$(heroku-api $endpoint GET STATUS)
    if [ $response -eq 200 ]; then
        echo "GET $endpoint success"
    else
        echo "GET $endpoint $response"
        exit 1
    fi
}

test_heroku_token
test_heroku_api_connection
test_heroku_build_app_exists
