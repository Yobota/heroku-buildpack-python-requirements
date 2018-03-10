#!/usr/bin/env bash

echo "Testing heroku-buildpack-python-requirements"

echo
echo - Checking for Heroku OAuth access token

if [ -n "$HEROKU_TOKEN" ]; then
    echo "Heroku OAuth access token found"
else
    echo "Heroku OAuth access token missing"
    echo "Check value of HEROKU_TOKEN"
    exit 1
fi

echo
echo - check can access a Heroku API endpoint

HEROKU_URL="https://api.heroku.com/"
HEROKU_VERSION_HEADER="Accept: application/vnd.heroku+json; version=3"
HEROKU_AUTH_HEADER="Authorization: Bearer $HEROKU_TOKEN"
APPS_URL="${HEROKU_URL}apps/"
call_apps() {
    curl -s -I \
        -o /dev/null \
        -w %{http_code} \
        -H "$HEROKU_VERSION_HEADER" \
        -H "$HEROKU_AUTH_HEADER" \
        $APPS_URL
}

response=$(call_apps)
if [ $response -eq 200 ]; then
    echo "GET $APPS_URL success"
else
    echo "GET $APPS_URL $response"
    exit 1
fi
