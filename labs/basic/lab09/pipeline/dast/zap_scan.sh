#!/usr/bin/env bash
set -euo pipefail

ZAP_IMAGE="${ZAP_IMAGE:-ghcr.io/zaproxy/zaproxy:stable}"
TARGET_URL="${TARGET_URL:-http://host.docker.internal:8080}"
OUT_DIR="${OUT_DIR:-pipeline/dast/reports}"
CONF_FILE="${CONF_FILE:-pipeline/dast/zap-baseline.conf}"

mkdir -p "$OUT_DIR"
cp "$CONF_FILE" "$OUT_DIR/zap-baseline.conf"

docker run --rm \
    --add-host=host.docker.internal:host-gateway \
    -v "$(pwd)/$OUT_DIR":/zap/wrk:rw \
    "$ZAP_IMAGE" \
    zap-baseline.py \
        -t "$TARGET_URL" \
        -c zap-baseline.conf \
        -J zap-report.json \
        -r zap-report.html \
        -I

echo "[zap] reports saved to: $OUT_DIR"
