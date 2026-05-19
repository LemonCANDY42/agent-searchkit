#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$ROOT/.env.local"
COMPOSE=(docker compose --project-name openclaw-agent-searchkit --env-file "$ENV_FILE" -f "$ROOT/docker-compose.yml")

if [[ ! -f "$ENV_FILE" ]]; then
  if [[ -f "$ROOT/.env.example" ]]; then
    echo "No .env.local found. Copying from .env.example..."
    cp "$ROOT/.env.example" "$ENV_FILE"
  else
    echo "Missing $ENV_FILE"
    exit 1
  fi
fi

compose_default() {
  COMPOSE_PROFILES= "${COMPOSE[@]}" "$@"
}

compose_extras() {
  COMPOSE_PROFILES=extras "${COMPOSE[@]}" "$@"
}

wait_for_searxng() {
  source "$ENV_FILE"
  local url="http://127.0.0.1:${SEARXNG_PORT}/search?q=openclaw&format=json&language=en-US"
  local attempts="${1:-20}"
  local body
  local i
  for ((i=1; i<=attempts; i++)); do
    if body="$(curl -fsS "$url" 2>/dev/null)" && [[ "$body" == *'"results"'* || "$body" == *'"query"'* ]]; then
      echo "SearXNG ready"
      return 0
    fi
    sleep 1
  done
  echo "SearXNG not ready after ${attempts}s" >&2
  return 1
}

case "${1:-}" in
  up)
    compose_default up -d --remove-orphans
    wait_for_searxng
    ;;
  up-extras)
    compose_extras up -d --remove-orphans
    wait_for_searxng
    ;;
  down)
    compose_default down --remove-orphans
    ;;
  restart)
    compose_default down --remove-orphans
    compose_default up -d --remove-orphans
    wait_for_searxng
    ;;
  restart-extras)
    compose_extras down --remove-orphans
    compose_extras up -d --remove-orphans
    wait_for_searxng
    ;;
  ps|status)
    compose_default ps
    ;;
  logs)
    shift || true
    compose_default logs -f "${@:-}"
    ;;
  pull)
    compose_default pull
    ;;
  pull-extras)
    compose_extras pull
    ;;
  test)
    "$ROOT/smoke-test.sh"
    ;;
  wait)
    wait_for_searxng
    ;;
  urls)
    source "$ENV_FILE"
    cat <<EOF
SearXNG : http://127.0.0.1:${SEARXNG_PORT}
ntfy    : http://127.0.0.1:${NTFY_PORT} (optional: ./manage.sh up-extras)
EOF
    ;;
  *)
    echo "Usage: $0 {up|up-extras|down|restart|restart-extras|ps|status|logs|pull|pull-extras|test|wait|urls}"
    exit 1
    ;;
esac
