echo "heroku-buildpack-python-requirements"

# check a Heroku API key is available
if [ -z "$HEROKU_API_KEY" ]; then
    echo "Heroku API key not set"
    exit 1
fi
