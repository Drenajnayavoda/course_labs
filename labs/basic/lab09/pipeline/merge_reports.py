"""Агрегатор отчётов SAST / SCA / Trivy / DAST в единый HTML.

Запускается из job `report` в .github/workflows/devsecops-lab09.yml после
download-artifact. На вход подаётся директория pipeline/artifacts/ со
скачанными артефактами:
    sast-reports/      semgrep-report.json, checkov-report.json
    sca-reports/       dependency-check-report.json
    trivy-report/      trivy-report.json
    dast-reports/      zap-report.json, zap-report.html

Скрипт ищет известные имена файлов рекурсивно, считает по каждому
инструменту количество находок по severity и собирает HTML.
"""

from __future__ import annotations

import datetime as dt
import json
import os
import pathlib
import sys
from typing import Any

from jinja2 import Template

ARTIFACTS_DIR = pathlib.Path("pipeline/artifacts")
OUTPUT_HTML = pathlib.Path("pipeline/unified-report.html")


def _read_json(path: pathlib.Path) -> Any:
    try:
        with path.open(encoding="utf-8") as fp:
            return json.load(fp)
    except (OSError, json.JSONDecodeError) as exc:
        print(f"[merge] cannot read {path}: {exc}", file=sys.stderr)
        return None


def _find(name: str) -> pathlib.Path | None:
    if not ARTIFACTS_DIR.exists():
        return None
    for path in ARTIFACTS_DIR.rglob(name):
        return path
    return None


def parse_semgrep() -> dict[str, Any]:
    path = _find("semgrep-report.json")
    if not path:
        return {"tool": "Semgrep", "available": False, "findings": []}
    data = _read_json(path) or {}
    findings = []
    for r in data.get("results", []):
        sev = r.get("extra", {}).get("severity", "INFO")
        findings.append(
            {
                "severity": sev,
                "rule": r.get("check_id", ""),
                "file": r.get("path", ""),
                "line": r.get("start", {}).get("line", ""),
                "message": r.get("extra", {}).get("message", "").strip().split("\n")[0],
            }
        )
    return {"tool": "Semgrep", "available": True, "source": str(path), "findings": findings}


def parse_checkov() -> dict[str, Any]:
    path = _find("checkov-report.json")
    if not path:
        return {"tool": "Checkov", "available": False, "findings": []}
    data = _read_json(path) or {}
    results = data if isinstance(data, list) else [data]
    findings = []
    for r in results:
        failed = r.get("results", {}).get("failed_checks", [])
        for c in failed:
            findings.append(
                {
                    "severity": c.get("severity") or "MEDIUM",
                    "rule": c.get("check_id", ""),
                    "file": c.get("file_path", ""),
                    "line": (c.get("file_line_range") or [""])[0],
                    "message": c.get("check_name", ""),
                }
            )
    return {"tool": "Checkov", "available": True, "source": str(path), "findings": findings}


def parse_dependency_check() -> dict[str, Any]:
    path = _find("dependency-check-report.json")
    if not path:
        return {"tool": "Dependency-Check", "available": False, "findings": []}
    data = _read_json(path) or {}
    findings = []
    for dep in data.get("dependencies", []):
        for v in dep.get("vulnerabilities", []):
            sev = v.get("severity", "")
            cvss = v.get("cvssv3", {}).get("baseScore") or v.get("cvssv2", {}).get("score")
            findings.append(
                {
                    "severity": sev.upper(),
                    "rule": v.get("name", ""),
                    "file": dep.get("fileName", ""),
                    "line": cvss,
                    "message": (v.get("description") or "").strip().split("\n")[0][:200],
                }
            )
    return {"tool": "Dependency-Check", "available": True, "source": str(path), "findings": findings}


def parse_trivy() -> dict[str, Any]:
    path = _find("trivy-report.json")
    if not path:
        return {"tool": "Trivy", "available": False, "findings": []}
    data = _read_json(path) or {}
    findings = []
    for res in data.get("Results", []) or []:
        for v in res.get("Vulnerabilities", []) or []:
            findings.append(
                {
                    "severity": v.get("Severity", ""),
                    "rule": v.get("VulnerabilityID", ""),
                    "file": res.get("Target", ""),
                    "line": v.get("PkgName", "") + " " + (v.get("InstalledVersion") or ""),
                    "message": (v.get("Title") or v.get("Description") or "")[:200],
                }
            )
    return {"tool": "Trivy", "available": True, "source": str(path), "findings": findings}


def parse_zap() -> dict[str, Any]:
    path = _find("zap-report.json")
    if not path:
        return {"tool": "OWASP ZAP", "available": False, "findings": []}
    data = _read_json(path) or {}
    findings = []
    for site in data.get("site", []):
        for alert in site.get("alerts", []):
            risk = alert.get("riskdesc", "")
            sev = risk.split(" ")[0].upper() if risk else ""
            findings.append(
                {
                    "severity": sev,
                    "rule": alert.get("pluginid", ""),
                    "file": site.get("@host", "") + site.get("@port", ""),
                    "line": alert.get("count", ""),
                    "message": alert.get("name", ""),
                }
            )
    return {"tool": "OWASP ZAP", "available": True, "source": str(path), "findings": findings}


def _count_by_severity(findings: list[dict[str, Any]]) -> dict[str, int]:
    out: dict[str, int] = {}
    for f in findings:
        sev = (f.get("severity") or "UNKNOWN").upper()
        out[sev] = out.get(sev, 0) + 1
    return out


TEMPLATE = """<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="utf-8">
<title>Lab09 DevSecOps — Unified Report</title>
<style>
body { font-family: -apple-system, Segoe UI, Helvetica, Arial, sans-serif; margin: 24px; color: #1f2937; }
h1, h2 { color: #111827; }
.summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 12px; margin-bottom: 24px; }
.card { padding: 12px 16px; border: 1px solid #e5e7eb; border-radius: 8px; background: #fafafa; }
.card .num { font-size: 28px; font-weight: 600; }
.tool { margin-top: 32px; padding: 12px 16px; border-left: 4px solid #2563eb; background: #f9fafb; }
.tool.unavailable { border-left-color: #9ca3af; opacity: 0.7; }
.badges { display: flex; flex-wrap: wrap; gap: 6px; margin: 8px 0; }
.badge { padding: 2px 8px; border-radius: 12px; font-size: 12px; }
.b-critical { background: #fee2e2; color: #991b1b; }
.b-high     { background: #fed7aa; color: #9a3412; }
.b-medium   { background: #fef3c7; color: #92400e; }
.b-low      { background: #d1fae5; color: #065f46; }
.b-info     { background: #e0e7ff; color: #3730a3; }
.b-warning  { background: #fef3c7; color: #92400e; }
.b-error    { background: #fee2e2; color: #991b1b; }
.b-unknown  { background: #e5e7eb; color: #374151; }
table { width: 100%; border-collapse: collapse; margin-top: 8px; font-size: 13px; }
th, td { padding: 6px 10px; border-bottom: 1px solid #e5e7eb; text-align: left; vertical-align: top; }
th { background: #f3f4f6; }
td.sev-CRITICAL, td.sev-ERROR { color: #991b1b; font-weight: 600; }
td.sev-HIGH { color: #9a3412; font-weight: 600; }
td.sev-MEDIUM, td.sev-WARNING { color: #92400e; }
.empty { color: #6b7280; font-style: italic; }
footer { margin-top: 40px; padding-top: 12px; border-top: 1px solid #e5e7eb; color: #6b7280; font-size: 12px; }
</style>
</head>
<body>
<h1>Lab09 — DevSecOps Pipeline Unified Report</h1>
<p>Сгенерировано {{ generated_at }} (run {{ run_id }})</p>

<div class="summary">
{% for t in tools %}
  <div class="card">
    <div>{{ t.tool }}</div>
    <div class="num">{{ t.findings|length }}</div>
    <div class="badges">
      {% for sev, n in t.counts.items() %}
        <span class="badge b-{{ sev|lower }}">{{ sev }}: {{ n }}</span>
      {% endfor %}
    </div>
    {% if not t.available %}<div class="empty">отчёт не найден</div>{% endif %}
  </div>
{% endfor %}
</div>

{% for t in tools %}
<div class="tool {% if not t.available %}unavailable{% endif %}">
  <h2>{{ t.tool }}</h2>
  {% if t.source %}<small>источник: {{ t.source }}</small>{% endif %}
  {% if t.findings %}
    <table>
      <thead><tr><th>Severity</th><th>Rule / CVE</th><th>File / Package</th><th>Line / Version</th><th>Message</th></tr></thead>
      <tbody>
        {% for f in t.findings %}
        <tr>
          <td class="sev-{{ f.severity }}">{{ f.severity }}</td>
          <td>{{ f.rule }}</td>
          <td>{{ f.file }}</td>
          <td>{{ f.line }}</td>
          <td>{{ f.message }}</td>
        </tr>
        {% endfor %}
      </tbody>
    </table>
  {% elif t.available %}
    <p class="empty">находок не обнаружено</p>
  {% else %}
    <p class="empty">отчёт инструмента не найден в артефактах</p>
  {% endif %}
</div>
{% endfor %}

<footer>
  Lab09 DevSecOps Pipeline · Drenajnayavoda/course_labs · ⓒ {{ year }}
</footer>
</body>
</html>
"""


def main() -> int:
    tools = [
        parse_semgrep(),
        parse_checkov(),
        parse_dependency_check(),
        parse_trivy(),
        parse_zap(),
    ]

    total = 0
    for t in tools:
        t["counts"] = _count_by_severity(t["findings"])
        total += len(t["findings"])
        print(
            f"[merge] {t['tool']}: available={t['available']}, "
            f"findings={len(t['findings'])}, by-severity={t['counts']}"
        )

    OUTPUT_HTML.parent.mkdir(parents=True, exist_ok=True)
    html = Template(TEMPLATE).render(
        tools=tools,
        generated_at=dt.datetime.utcnow().strftime("%Y-%m-%d %H:%M UTC"),
        run_id=os.environ.get("GITHUB_RUN_ID", "local"),
        year=dt.date.today().year,
    )
    OUTPUT_HTML.write_text(html, encoding="utf-8")
    print(f"[merge] wrote {OUTPUT_HTML} (total findings: {total})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
