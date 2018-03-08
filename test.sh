echo "heroku-buildpack-python-requirements"
HEROKU_API_URL="https://api.heroku.com/"
HEROKU_VERSION_HEADER="Accept: application/vnd.heroku+json; version=3"

# check a Heroku API key is available

if [ -n "$HEROKU_API_KEY" ]; then
    echo "Heroku API key found"
else
    echo "Heroku API key not set"
    exit 1
fi


# check can access a Heroku API endpoint

APPS_URL="${HEROKU_API_URL}apps"
GET_APPS_STATUS="curl -s -o /dev/null -w %{http_code} $APPS_URL"
response=$($GET_APPS_STATUS)

if [ $response -eq 200 ]; then
    echo "GET $APPS_URL success"
else
    echo "GET $APPS_URL $response"
    exit 1
fi
