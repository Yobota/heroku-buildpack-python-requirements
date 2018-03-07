echo "heroku-buildpack-python-requirements"

# check a Heroku API token is available
if [ -z "$HEROKU_API_TOKEN" ]; then
    echo "Token not set"
    exit 1
fi
