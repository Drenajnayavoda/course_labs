set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "=== lab07: SAST + SCA for vulnerable-app ==="

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "ERROR: '$1' not found in PATH"; exit 1; }
}

need_cmd docker
need_cmd docker-compose || need_cmd docker compose || true

echo "[*] Tools check: docker OK"

echo
echo "Build & run vulnerable-app (Docker)"

if command -v docker-compose >/dev/null 2>&1; then
  docker-compose -f "${ROOT_DIR}/docker-compose.yml" up -d --build
else
  docker compose -f "${ROOT_DIR}/docker-compose.yml" up -d --build
fi

echo "[+] vulnerable-app is up"

echo
echo "SAST with Semgrep"

if command -v semgrep >/dev/null 2>&1; then
  cd "${ROOT_DIR}"

  echo "[*] Semgrep: custom rules only"
  semgrep --config sast/semgrep-rules.yml \
    --json \
    --output sast/semgrep-report.json \
    vulnerable-app/ || true

  echo "[+] Semgrep report saved to sast/semgrep-report.json"

else
  echo "[-] Semgrep not found, skipping SAST"
fi

echo
echo "SAST with Checkov (Dockerfile / IaC)"

if command -v checkov >/dev/null 2>&1; then
  cd "${ROOT_DIR}"
  checkov \
    --framework dockerfile \
    --file vulnerable-app/Dockerfile docker-compose.yml \
    --output json \
    --output-file-path sast/checkov-report.json \
    --soft-fail || true
  
  echo "[+] Checkov report saved to sast/checkov-report.json"
else
  echo "[-] Checkov not found, skipping Docker/IaC SAST"
fi

echo
echo "SCA with OWASP Dependency-Check"

if [ -x "${ROOT_DIR}/sca/dependency-check.sh" ]; then
  cd "${ROOT_DIR}"
  bash sca/dependency-check.sh
else
  echo "[-] sca/dependency-check.sh not found or not executable."
fi

echo
echo "Unified SAST/SCA Report Generation"

if [ -x "${ROOT_DIR}/sca/generate_unified_report.sh" ]; then
  bash "${ROOT_DIR}/sca/generate_unified_report.sh"
else
  echo "[-] generate_unified_report.sh not found or not executable"
fi

echo
echo "lab07 complete"
echo "Review:"
echo "  - Semgrep SAST findings"
echo "  - Checkov Docker/IaC findings"
echo "  - OWASP Dependency-Check SCA findings"
echo "  - Unified reports in reports/ directory (CSV, HTML, JSON)"
echo "  - Open CSV in Excel/LibreOffice and save as XLSX/ODT"