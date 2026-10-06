#!/usr/bin/env bash
# Builds the image locally, loads it on the server and restarts the container.
#
#   ./deploy.sh
#   DEPLOY_HOST=user@host ./deploy.sh
set -euo pipefail

HOST="${DEPLOY_HOST:-root@krasosu.de}"
DIR="${DEPLOY_DIR:-/opt/containers/landingpage}"
URL="${DEPLOY_URL:-https://krasosu.de}"
IMAGE=krasosu-landingpage:latest

cd "$(dirname "$0")"
if [ -n "$(git status --porcelain)" ]; then
  echo "note: uncommitted changes are deployed as well" >&2
fi

docker build -t "$IMAGE" .
docker save "$IMAGE" | gzip | ssh "$HOST" "gunzip | docker load"
rsync -az docker-compose.yml "$HOST:$DIR/"
ssh "$HOST" "cd '$DIR' && docker compose up -d && docker image prune -f >/dev/null"

echo "waiting for $URL ..."
for _ in $(seq 60); do
  if curl -fsS -o /dev/null "$URL/"; then
    echo "deployed: $URL"
    exit 0
  fi
  sleep 3
done
echo "$URL does not answer after 3 minutes" >&2
exit 1
