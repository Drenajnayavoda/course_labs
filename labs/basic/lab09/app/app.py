import logging
import os
import sqlite3
import subprocess

from flask import Flask, make_response, request
from markupsafe import escape

app = Flask(__name__)

app.config["DEBUG"] = False

DB_USER = os.environ.get("DB_USER", "app")
DB_PASSWORD = os.environ.get("DB_PASSWORD")
DB_PATH = os.environ.get("DB_PATH", "app.db")

logging.basicConfig(level=logging.INFO)


def get_db():
    conn = sqlite3.connect(DB_PATH)
    return conn


@app.route("/")
def index():
    return "Application is running"


@app.route("/user")
def get_user():
    username = request.args.get("name", "")
    conn = get_db()
    cur = conn.cursor()
    rows = cur.execute(
        "SELECT id, name, email FROM users WHERE name = ?", (username,)
    ).fetchall()
    conn.close()
    return {"result": rows}


@app.route("/search")
def search():
    q = request.args.get("q", "")
    safe_q = escape(q)
    html = f"<h1>Results for: {safe_q}</h1>"
    return make_response(html, 200)


@app.route("/ping")
def ping():
    import ipaddress

    host = request.args.get("host", "127.0.0.1")
    try:
        ipaddress.ip_address(host)
        result = subprocess.run(
            ["ping", "-c", "1", host], capture_output=True, text=True, timeout=5
        )
        return f"Pinged {escape(host)}: {result.returncode}"
    except (ValueError, subprocess.TimeoutExpired) as e:
        return f"Invalid host or timeout: {escape(str(e))}", 400


@app.route("/backup")
def backup():
    target_key = request.args.get("target", "default")
    allowed_targets = {
        "default": "/tmp/backup.sql",  # nosec B108
        "nightly": "/tmp/backup-nightly.sql",  # nosec B108
    }
    if target_key not in allowed_targets:
        return "Invalid target. Allowed: " + ", ".join(allowed_targets.keys()), 400
    target = allowed_targets[target_key]
    subprocess.run(["pg_dump", "mydb", "-f", target], check=False)
    return f"Backup to {escape(target)} started"


@app.route("/read")
def read_file():
    import pathlib

    allowed_files = {"config": "/app/config.yaml", "readme": "/app/README.md"}
    file_key = request.args.get("file", "")
    if not file_key or file_key not in allowed_files:
        return "Invalid file parameter. Allowed: " + ", ".join(
            allowed_files.keys()
        ), 400
    try:
        file_path = pathlib.Path(allowed_files[file_key])
        if not file_path.exists():
            return "File not found", 404
        data = file_path.read_text(encoding="utf-8")
        return f"<pre>{escape(data)}</pre>"
    except Exception as e:
        return str(e), 500


@app.route("/load")
def load():
    import json

    data = request.args.get("data", "")
    if not data:
        return "Data parameter required", 400
    try:
        obj = json.loads(data)
        return f"Loaded object: {escape(str(obj))}"
    except json.JSONDecodeError as e:
        return f"Invalid JSON: {escape(str(e))}", 400


@app.route("/calc")
def calc():
    a = request.args.get("a", "0")
    b = request.args.get("b", "0")
    op = request.args.get("op", "add")

    try:
        num_a = float(a)
        num_b = float(b)

        operations = {
            "add": lambda x, y: x + y,
            "sub": lambda x, y: x - y,
            "mul": lambda x, y: x * y,
            "div": lambda x, y: x / y if y != 0 else None,
        }

        if op not in operations:
            return "Invalid operation. Allowed: add, sub, mul, div", 400

        result = operations[op](num_a, num_b)
        if result is None:
            return "Division by zero", 400
        return str(result)
    except (ValueError, TypeError) as e:
        return f"Invalid numbers: {escape(str(e))}", 400


@app.after_request
def set_security_headers(response):
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["Content-Security-Policy"] = "default-src 'self'"
    response.headers["Permissions-Policy"] = "geolocation=(), microphone=(), camera=()"
    response.headers["Cross-Origin-Opener-Policy"] = "same-origin"
    response.headers["Cross-Origin-Embedder-Policy"] = "require-corp"
    response.headers["Cross-Origin-Resource-Policy"] = "same-origin"
    response.headers["Server"] = "WebServer"
    return response


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)  # nosec B104
