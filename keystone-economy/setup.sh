#!/usr/bin/env bash
# Keystone Economy — VPS setup. Idempotent; safe to re-run.
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f .env ]]; then
  echo "==> Creating .env from template. EDIT IT (set DB passwords) then re-run."
  cp .env.example .env
  exit 1
fi

echo "==> Checking Docker..."
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker not found. Install Docker Engine + compose plugin first:"
  echo "  https://docs.docker.com/engine/install/"
  exit 1
fi

echo "==> Pulling images..."
docker compose pull

echo "==> Starting stack (MariaDB applies sql/schema.sql on first run)..."
docker compose up -d

echo
echo "==> Up. Next:"
echo "   - txAdmin:   http://<this-vps-ip>:40120  (complete wizard once, link Cfx account)"
echo "   - Logs:      docker compose logs -f fxserver"
echo "   - Firewall:  allow TCP/UDP 30120 and TCP 40120"
echo "   - Set sv_licenseKey in server-data/server.cfg (https://keymaster.fivem.net)"
