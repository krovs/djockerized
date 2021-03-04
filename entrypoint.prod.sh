#!/bin/sh
set -e

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi


python manage.py migrate
python manage.py collectstatic --no-input

gunicorn djangoproject.wsgi:application --bind 0.0.0.0:8000

exec "$@"