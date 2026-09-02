#!/bin/sh
set -e

python manage.py migrate --noinput

exec gunicorn myproject.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --timeout 60 \
    --worker-tmp-dir /dev/shm \
    --access-logfile - \
    --error-logfile -
