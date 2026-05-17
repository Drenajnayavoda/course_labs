#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="${PROJECT_NAME:-lab09-vulnerable-app}"
SCAN_PATH="${SCAN_PATH:-app}"
OUT_DIR="${OUT_DIR:-pipeline/sca/reports}"
DC_BIN="${DC_BIN:-dependency-check.sh}"

mkdir -p "$OUT_DIR"

ARGS=(
    --project   "$PROJECT_NAME"
    --scan      "$SCAN_PATH"
    --format    ALL
    --out       "$OUT_DIR"
    --enableExperimental
    --failOnCVSS 9
)

if [[ -n "${NVD_API_KEY:-}" ]]; then
    ARGS+=(--nvdApiKey "$NVD_API_KEY")
fi

echo "[dependency-check] running: $DC_BIN ${ARGS[*]}"
"$DC_BIN" "${ARGS[@]}"
echo "[dependency-check] reports saved to: $OUT_DIR"
