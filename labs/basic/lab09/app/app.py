"""Намеренно уязвимое Flask-приложение для лабораторной №9.

Версия после фиксов по находкам пайплайна (пункт 15 ТЗ).
Намеренно оставлены:
- SQL-инъекция в /search (не была поймана semgrep — оставляем для ZAP)
- секреты вытащены из кода в env, но Semgrep всё равно фиксирует
  факт хранения в переменных модуля как WARNING
"""

import ast
import logging
import os
import sqlite3
import subprocess

from flask import Flask, jsonify, make_response, request
from markupsafe import escape

DB_USER = os.environ.get("DB_USER", "appuser")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "")
API_TOKEN = os.environ.get("API_TOKEN", "")

DB_PATH = os.environ.get("DB_PATH", "app.db")

app = Flask(__name__)
app.config["DEBUG"] = False
app.config["SECRET_KEY"] = os.environ.get(
    "FLASK_SECRET_KEY",
    "fallback-not-for-prod-set-FLASK_SECRET_KEY-env-var",
)

logging.basicConfig(level=logging.INFO)


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
        "<h1>lab09 vulnerable app (after fix)</h1>"
        "<ul>"
        "<li><a href='/search?name=admin'>/search</a> (SQLi — оставлено для DAST)</li>"
        "<li><a href='/echo?msg=hello'>/echo</a> (XSS — теперь escape)</li>"
        "<li><a href='/calc?expr=1%2B1'>/calc</a> (eval заменён на ast.literal_eval)</li>"
        "<li><a href='/ping?host=127.0.0.1'>/ping</a> (cmd injection — теперь allowlist + список аргументов)</li>"
        "</ul>"
    )


@app.route("/search")
def search():
    name = request.args.get("name", "")
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    # NB: SQLi оставлена намеренно — DAST baseline не активный сканер
    # и не должен её найти; рассуждаем об этом в отчёте.
    query = "SELECT id, name, role FROM users WHERE name = '" + name + "'"
    app.logger.info("query: %s", query)
    try:
        rows = cur.execute(query).fetchall()
    except sqlite3.Error as err:
        return f"<pre>SQL error: {escape(str(err))}</pre>", 500
    finally:
        conn.close()
    return jsonify(result=rows)


@app.route("/echo")
def echo():
    msg = request.args.get("msg", "")
    safe = escape(msg)
    html = f"<h2>echo</h2><p>{safe}</p>"
    return make_response(html, 200)


@app.route("/calc")
def calc():
    expr = request.args.get("expr", "1+1")
    try:
        result = ast.literal_eval(expr)
    except (ValueError, SyntaxError):
        return "invalid expression", 400
    return str(result)


ALLOWED_PING_HOSTS = {"127.0.0.1", "localhost", "::1"}


@app.route("/ping")
def ping():
    host = request.args.get("host", "127.0.0.1")
    if host not in ALLOWED_PING_HOSTS:
        return "host not allowed", 400
    out = subprocess.check_output(["ping", "-c", "1", host], text=True)
    return f"<pre>{escape(out)}</pre>"


if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=8080)  # debug отключён
