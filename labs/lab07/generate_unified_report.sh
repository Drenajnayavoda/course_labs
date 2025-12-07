set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="${ROOT_DIR}/sca/dependency-check-report"
SAST_DIR="${ROOT_DIR}/sast"
OUTPUT_DIR="${ROOT_DIR}/reports"

mkdir -p "${OUTPUT_DIR}"

PROJECT_NAME="lab07-vulnerable-app"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "Lab07: Unified SAST/SCA Report Generation"
echo "Output directory: ${OUTPUT_DIR}"

SEMGREP_REPORT=""
CHECKOV_REPORT=""
DEPCHECK_REPORT=""

if [ -f "${SAST_DIR}/semgrep-report.json" ]; then
  SEMGREP_REPORT="${SAST_DIR}/semgrep-report.json"
  echo "[+] Found Semgrep report: ${SEMGREP_REPORT}"
else
  echo "[-] Semgrep report not found at ${SAST_DIR}/semgrep-report.json"
fi

if [ -f "${SAST_DIR}/checkov-report.json" ]; then
  CHECKOV_REPORT="${SAST_DIR}/checkov-report.json"
  echo "[+] Found Checkov report: ${CHECKOV_REPORT}"
else
  echo "[-] Checkov report not found at ${SAST_DIR}/checkov-report.json"
fi

if [ -f "${REPORT_DIR}/dependency-check-report.json" ]; then
  DEPCHECK_REPORT="${REPORT_DIR}/dependency-check-report.json"
  echo "[+] Found Dependency-Check report: ${DEPCHECK_REPORT}"
else
  echo "[-] Dependency-Check report not found at ${REPORT_DIR}/dependency-check-report.json"
fi

UNIFIED_CSV="${OUTPUT_DIR}/unified-sast-sca-report-${TIMESTAMP}.csv"

cat > "${UNIFIED_CSV}" << 'EOF'
"Tool","Check ID","Severity","File/Resource","Issue","Description","Remediation"
EOF

# Добавляем Semgrep findings
if [ -n "${SEMGREP_REPORT}" ] && command -v jq >/dev/null 2>&1; then
  echo "[*] Processing Semgrep findings..."
  jq -r '.results[] | "\("Semgrep"),\(.check_id),\(.severity),\(.path):\(.start.line),\(.message),Potential security issue,Review and fix vulnerability" | @csv' "${SEMGREP_REPORT}" >> "${UNIFIED_CSV}" 2>/dev/null || echo "[-] Could not parse Semgrep JSON"
fi

# Добавляем Checkov findings
if [ -n "${CHECKOV_REPORT}" ] && command -v jq >/dev/null 2>&1; then
  echo "[*] Processing Checkov findings..."
  jq -r '.check_type_to_results.dockerfile[]? | "\("Checkov"),\(.check_id),\(.check_severity),\(.file_path),\(.check),\(.check_name),Add HEALTHCHECK or USER directive" | @csv' "${CHECKOV_REPORT}" >> "${UNIFIED_CSV}" 2>/dev/null || echo "[-] Could not parse Checkov JSON"
fi

# Добавляем Dependency-Check findings
if [ -n "${DEPCHECK_REPORT}" ] && command -v jq >/dev/null 2>&1; then
  echo "[*] Processing Dependency-Check findings..."
  jq -r '.reportSchema.dependencies[]? | select(.vulnerabilities[]?) | .packages[]? as $pkg | .vulnerabilities[]? | "\("Dependency-Check"),\(.cve),\(.severity),\($pkg),\(.description),Vulnerable dependency,Update to patched version" | @csv' "${DEPCHECK_REPORT}" >> "${UNIFIED_CSV}" 2>/dev/null || echo "[-] Could not parse Dependency-Check JSON"
fi

echo "[+] Unified CSV report created: ${UNIFIED_CSV}"

UNIFIED_HTML="${OUTPUT_DIR}/unified-sast-sca-report-${TIMESTAMP}.html"

cat > "${UNIFIED_HTML}" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lab07 Unified SAST/SCA Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .header { background: #1f3333; color: white; padding: 20px; border-radius: 5px; }
        .section { background: white; margin: 20px 0; padding: 20px; border-radius: 5px; }
        h2 { color: #134252; border-bottom: 2px solid #2180a6; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f9f9f9; font-weight: bold; }
        .critical { background: #ffebee; }
        .high { background: #fff3e0; }
        .medium { background: #f3e5f5; }
        .low { background: #e8f5e9; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Lab07: Unified SAST/SCA Security Report</h1>
        <p>Generated: <script>document.write(new Date().toLocaleString())</script></p>
    </div>
    
    <div class="section">
        <h2>Executive Summary</h2>
        <ul>
            <li><strong>Project:</strong> lab07-vulnerable-app</li>
            <li><strong>Scan Tools:</strong> Semgrep (SAST), Checkov (Docker/IaC), OWASP Dependency-Check (SCA)</li>
            <li><strong>Report Date:</strong> <script>document.write(new Date().toLocaleDateString())</script></li>
        </ul>
    </div>

    <div class="section">
        <h2>Findings Overview</h2>
        <p>See the attached CSV file for detailed vulnerability list.</p>
    </div>

    <div class="section">
        <h2>Remediation Recommendations</h2>
        <ol>
            <li>Fix Semgrep SAST findings: SQL injection, RCE, LFI vulnerabilities in app.py</li>
            <li>Add Dockerfile hardening: HEALTHCHECK instruction and non-root USER</li>
            <li>Update vulnerable dependencies identified by Dependency-Check</li>
            <li>Implement secure configuration practices (remove hardcoded secrets)</li>
        </ol>
    </div>
</body>
</html>
EOF

echo "[+] Unified HTML report created: ${UNIFIED_HTML}"

UNIFIED_JSON="${OUTPUT_DIR}/unified-sast-sca-report-${TIMESTAMP}.json"

cat > "${UNIFIED_JSON}" << EOF
{
  "project": "${PROJECT_NAME}",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "reports": {
    "semgrep": $([ -n "${SEMGREP_REPORT}" ] && cat "${SEMGREP_REPORT}" || echo '{}'),
    "checkov": $([ -n "${CHECKOV_REPORT}" ] && cat "${CHECKOV_REPORT}" || echo '{}'),
    "dependency_check": $([ -n "${DEPCHECK_REPORT}" ] && cat "${DEPCHECK_REPORT}" || echo '{}')
  }
}
EOF

echo "[+] Unified JSON report created: ${UNIFIED_JSON}"

echo
echo "Reports generated in: ${OUTPUT_DIR}"
ls -lh "${OUTPUT_DIR}"

echo
echo "Next steps:"
echo "1. Open ${UNIFIED_CSV} in Excel/LibreOffice and save as XLSX"
echo "2. Open ${UNIFIED_HTML} in a browser for summary view"
echo "3. Use ${UNIFIED_JSON} for programmatic processing"