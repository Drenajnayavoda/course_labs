set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="${ROOT_DIR}/sca/dependency-check-report"
SAST_DIR="${ROOT_DIR}/sast"
OUTPUT_DIR="${ROOT_DIR}/reports"

mkdir -p "${OUTPUT_DIR}"

PROJECT_NAME="lab07-vulnerable-app"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

echo "Lab07: Unified SAST/SCA Report Generation"
echo "Output directory: ${OUTPUT_DIR}"

SEMGREP_REPORT=""
CHECKOV_JSON=""
DEPCHECK_REPORT=""

if [ -f "${SAST_DIR}/semgrep-report.json" ]; then
  SEMGREP_REPORT="${SAST_DIR}/semgrep-report.json"
  echo "[+] Found Semgrep report: ${SEMGREP_REPORT}"
else
  echo "[-] Semgrep report not found at ${SAST_DIR}/semgrep-report.json"
fi

if [ -f "${SAST_DIR}/checkov-report.json/results_json.json" ]; then
  CHECKOV_JSON="${SAST_DIR}/checkov-report.json/results_json.json"
  echo "[+] Found Checkov report: ${CHECKOV_JSON}"
else
  echo "[-] Checkov report not found at ${SAST_DIR}/checkov-report.json/results_json.json"
fi

if [ -f "${REPORT_DIR}/dependency-check-report.json" ]; then
  DEPCHECK_REPORT="${REPORT_DIR}/dependency-check-report.json"
  echo "[+] Found Dependency-Check report: ${DEPCHECK_REPORT}"
else
  echo "[-] Dependency-Check report not found at ${REPORT_DIR}/dependency-check-report.json"
fi

UNIFIED_CSV="${OUTPUT_DIR}/unified-sast-sca-report-${TIMESTAMP}.csv"
UNIFIED_HTML="${OUTPUT_DIR}/unified-sast-sca-report-${TIMESTAMP}.html"
UNIFIED_JSON="${OUTPUT_DIR}/unified-sast-sca-report-${TIMESTAMP}.json"

# CSV header
cat > "${UNIFIED_CSV}" << 'EOF'
"Tool","Check ID","Severity","File/Resource","Issue","Description","Remediation"
EOF

if ! command -v jq >/dev/null 2>&1; then
  echo "[-] jq not found, unified CSV will contain only header."
else
  if [ -n "${SEMGREP_REPORT}" ]; then
    echo "[*] Adding Semgrep findings..."
    jq -r '
      .results[]? |
      [
        "Semgrep",
        .check_id,
        .extra.severity,
        (.path + ":" + (.start.line|tostring)),
        .extra.message,
        "Semgrep finding",
        "Fix the vulnerable code"
      ] | @csv
    ' "${SEMGREP_REPORT}" >> "${UNIFIED_CSV}" || echo "[-] Could not parse Semgrep JSON"
  fi

  if [ -n "${CHECKOV_JSON}" ]; then
    echo "[*] Adding Checkov findings..."
    jq -r '
      .results as $r |
      (
        ($r.failed_checks // []) +
        ($r.passed_checks // [])
      )[]? as $item |
      [
        "Checkov",
        ($item.check_id // "N/A"),
        ($item.severity // $item.check_severity // "UNKNOWN"),
        ($item.file_path // $item.repo_file_path // $item.resource // "N/A"),
        ($item.check_name // "N/A"),
        ($item.check_result.result // "UNKNOWN"),
        "Harden Dockerfile / IaC (e.g. add HEALTHCHECK, non-root USER)"
      ] | @csv
    ' "${CHECKOV_JSON}" >> "${UNIFIED_CSV}" || echo "[-] Could not parse Checkov JSON"
  else
    echo "[-] Checkov JSON not found, skipping Checkov findings"
  fi

  if [ -n "${DEPCHECK_REPORT}" ]; then
    echo "[*] Adding Dependency-Check findings..."

    jq '.dependencies | length' "${DEPCHECK_REPORT}" | xargs echo "[i] dependencies count:"

    jq -r '
      .dependencies[]? as $d |
      ($d.vulnerabilities[]? // empty) as $v |
      [
        "Dependency-Check",
        ($v.name // $v.cve // "N/A"),
        ($v.severity // "N/A"),
        ($d.fileName // "N/A"),
        ($v.description // "Vulnerable dependency"),
        "Vulnerable dependency",
        "Update to a fixed version"
      ] | @csv
    ' "${DEPCHECK_REPORT}" >> "${UNIFIED_CSV}"
  fi
fi

echo "[+] Unified CSV report created: ${UNIFIED_CSV}"

{
cat << 'EOF'
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
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f9f9f9; font-weight: bold; }
        .critical { background: #ffebee; }
        .high { background: #fff3e0; }
        .medium { background: #f3e5f5; }
        .low { background: #e8f5e9; }
        code { font-family: monospace; }
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
        </ul>
    </div>

    <div class="section">
        <h2>All Findings</h2>
        <table>
            <thead>
                <tr>
                    <th>Tool</th>
                    <th>Check ID / CVE</th>
                    <th>Severity</th>
                    <th>File / Dependency</th>
                    <th>Issue</th>
                    <th>Remediation</th>
                </tr>
            </thead>
            <tbody>
EOF

tail -n +2 "${UNIFIED_CSV}" | while IFS=, read -r tool checkid sev file issue desc rem; do
  tool=${tool//\"/}
  checkid=${checkid//\"/}
  sev=${sev//\"/}
  file=${file//\"/}
  issue=${issue//\"/}
  rem=${rem//\"/}
  cat <<EOF2
                <tr>
                    <td>${tool}</td>
                    <td>${checkid}</td>
                    <td>${sev}</td>
                    <td><code>${file}</code></td>
                    <td>${issue}</td>
                    <td>${rem}</td>
                </tr>
EOF2
done

cat << 'EOF'
            </tbody>
        </table>
    </div>

    <div class="section">
        <h2>Notes</h2>
        <p>For a spreadsheet-friendly version, open the CSV file in Excel/LibreOffice and save as XLSX or embed into an ODT document.</p>
    </div>
</body>
</html>
EOF
} > "${UNIFIED_HTML}"

echo "[+] Unified HTML report created: ${UNIFIED_HTML}"

cat > "${UNIFIED_JSON}" << EOF
{
  "project": "${PROJECT_NAME}",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "reports": {
    "semgrep": $([ -n "${SEMGREP_REPORT}" ] && cat "${SEMGREP_REPORT}" || echo '{}'),
    "checkov": $([ -n "${CHECKOV_JSON}" ] && cat "${CHECKOV_JSON}" || echo '{}'),
    "dependency_check": $([ -n "${DEPCHECK_REPORT}" ] && cat "${DEPCHECK_REPORT}" || echo '{}')
  }
}
EOF

echo "[+] Unified JSON report created: ${UNIFIED_JSON}"

echo
echo "Reports generated in: ${OUTPUT_DIR}"
ls -lh "${OUTPUT_DIR}"