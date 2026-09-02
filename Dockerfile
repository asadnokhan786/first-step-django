FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# copy requirements first so the pip layer caches
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
RUN chmod +x entrypoint.sh

# collectstatic imports settings, so it needs *something* for required env vars.
# Use throwaway values — never bake real secrets into a layer.
RUN SECRET_KEY=build-time-only DEBUG=0 \
    python manage.py collectstatic --noinput

RUN useradd --create-home app && chown -R app:app /app
USER app

EXPOSE 8000
ENTRYPOINT ["./entrypoint.sh"]
