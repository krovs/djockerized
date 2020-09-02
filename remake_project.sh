#!/bin/sh

# create the new project
if [ "$#" -ne 1 ]
then
  echo "Usage: sh restart_project.sh <project name>"
  exit 1
fi

# clean the work dir
echo 'Cleaning workdir /app...'
find app/* -not -name requirements.txt -delete

# create a django project inside web container
echo 'Executing django-admin startproject inside the container...'
docker-compose exec web django-admin startproject $1 .
sudo chown -R ${USER:=$(/usr/bin/id -run)}:$USER app/

# replace all ocurrencies of old name
echo 'Replaceing all ocurrencies of the old project...'
sed -i "s/command.*/command: gunicorn $1.wsgi:application --bind 0.0.0.0:8000/" docker-compose.prod.yml
sed -i "s/upstream.*/upstream $1 {/" nginx/nginx.conf
sed -i "s-proxy_pass.*-proxy_pass http://$1;-" nginx/nginx.conf

# add to settings.py
echo 'Adapting settings.py with env variables'
sed -i "/from pathlib.*/a import os" app/$1/settings.py
sed -i "s/SECRET.*/SECRET_KEY = os.environ.get(\"SECRET_KEY\")/" app/$1/settings.py
sed -i "s/DEBUG.*/DEBUG = int(os.environ.get(\"DEBUG\", default=0))/" app/$1/settings.py
sed -i "s/ALLOWED.*/ALLOWED_HOSTS = os.environ.get(\"ALLOWED_HOSTS\").split(\" \")/" app/$1/settings.py

echo 'Adding static and media folders...'
echo "STATIC_ROOT = os.path.join(BASE_DIR, \"static\")" >> app/$1/settings.py
echo "MEDIA_URL = \"/media/\"" >> app/$1/settings.py
echo "MEDIA_ROOT = os.path.join(BASE_DIR, \"media\")" >> app/$1/settings.py

echo 'Rebuilding containers...'
docker-compose down -v
docker-compose up --build


echo "New Django project created!"