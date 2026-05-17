"""Намеренно уязвимое Flask-приложение для лабораторной №9.

Назначение: продемонстрировать срабатывания SAST (Semgrep), DAST (OWASP ZAP)
и сравнить с поведением SCA (Dependency-Check) на старых зависимостях.

ВНИМАНИЕ: код содержит специально оставленные уязвимости (SQLi, hardcoded
secrets, eval, debug). Не использовать в production.
"""

import logging
import os
import sqlite3
import subprocess

from flask import Flask, jsonify, make_response, request

DB_USER = "appuser"
DB_PASSWORD = "P@ssw0rd_super_secret_123"
API_TOKEN = "lab09-fake-token-not-a-real-secret-placeholder"

DB_PATH = os.environ.get("DB_PATH", "app.db")

app = Flask(__name__)
app.config["DEBUG"] = True
app.config["SECRET_KEY"] = "hardcoded-flask-key-do-not-use-in-prod"

logging.basicConfig(level=logging.DEBUG)


def init_db() -> None:
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute(
        "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT, role TEXT)"
    )
    cur.execute("DELETE FROM users")
    cur.executemany(
        "INSERT INTO users (name, role) VALUES (?, ?)",
        [("admin", "admin"), ("alice", "user"), ("bob", "user")],
    )
    conn.commit()
    conn.close()


@app.route("/")
def index() -> str:
    return (
        "<h1>lab09 vulnerable app</h1>"
        "<ul>"
        "<li><a href='/search?name=admin'>/search</a> (SQLi)</li>"
        "<li><a href='/echo?msg=hello'>/echo</a> (XSS)</li>"
        "<li><a href='/calc?expr=1%2B1'>/calc</a> (eval)</li>"
        "<li><a href='/ping?host=127.0.0.1'>/ping</a> (cmd injection)</li>"
        "<li><a href='/debug'>/debug</a> (info disclosure)</li>"
        "</ul>"
    )


@app.route("/search")
def search():
    name = request.args.get("name", "")
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    query = "SELECT id, name, role FROM users WHERE name = '" + name + "'"
    app.logger.info("DEBUG SQL: %s | token=%s", query, API_TOKEN)
    try:
        rows = cur.execute(query).fetchall()
    except sqlite3.Error as err:
        return f"<pre>SQL error: {err}\nquery: {query}</pre>", 500
    finally:
        conn.close()
    return jsonify(result=rows)


@app.route("/echo")
def echo():
    msg = request.args.get("msg", "")
    html = f"<h2>echo</h2><p>{msg}</p>"
    return make_response(html, 200)


@app.route("/calc")
def calc():
    expr = request.args.get("expr", "1+1")
    result = eval(expr)  # noqa: S307 — namerenno
    return str(result)


@app.route("/ping")
def ping():
    host = request.args.get("host", "127.0.0.1")
    out = subprocess.check_output(f"ping -c 1 {host}", shell=True, text=True)
    return f"<pre>{out}</pre>"


@app.route("/debug")
def debug():
    return jsonify(
        env=dict(os.environ),
        headers=dict(request.headers),
        db_user=DB_USER,
        db_password=DB_PASSWORD,
        api_token=API_TOKEN,
    )


if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=8080, debug=True)
