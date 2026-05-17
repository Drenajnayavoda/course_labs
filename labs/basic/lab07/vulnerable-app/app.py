from flask import Flask, request, make_response, jsonify, escape, abort
import sqlite3
import os
import subprocess
import logging
import ast
import operator

app = Flask(__name__)

app.config["DEBUG"] = False

DB_PATH = os.environ.get("DB_PATH", "app.db")

logging.basicConfig(level=logging.INFO)


def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


@app.route("/")
def index():
    return "Vulnerable lab07 app v1.0 (hardened)"


@app.route("/user")
def get_user():
    username = request.args.get("name", "")
    conn = get_db()
    cur = conn.cursor()
    cur.execute("SELECT id, name, email FROM users WHERE name = ?", (username,))
    rows = [dict(row) for row in cur.fetchall()]
    conn.close()
    return jsonify(result=rows)


@app.route("/search")
def search():
    q = request.args.get("q", "")
    safe_q = escape(q)
    html = f"<h1>Results for: {safe_q}</h1>"
    return make_response(html, 200)


ALLOWED_PING_HOSTS = {"127.0.0.1", "localhost", "::1"}


@app.route("/ping")
def ping():
    host = request.args.get("host", "127.0.0.1")
    if host not in ALLOWED_PING_HOSTS:
        abort(400, "Host not allowed")
    res = subprocess.run(["ping", "-c", "1", host], capture_output=True, text=True)
    return make_response(res.stdout or res.stderr, 200)


@app.route("/backup")
def backup():
    return "Backup endpoint disabled for security reasons", 403


ALLOWED_READ_DIR = os.path.abspath(os.environ.get("ALLOWED_READ_DIR", "/app/data"))


@app.route("/read")
def read_file():
    path = request.args.get("path", "")
    try:
        abs_path = os.path.abspath(path)
        if not abs_path.startswith(ALLOWED_READ_DIR):
            return "Access denied", 403
        with open(abs_path, "r", encoding="utf-8") as f:
            data = f.read()
        return make_response(f"<pre>{escape(data)}</pre>", 200)
    except FileNotFoundError:
        return "Not found", 404
    except Exception:
        app.logger.exception("Read error")
        return "Internal error", 500


@app.route("/load", methods=["POST"])
def load():
    try:
        obj = request.get_json(force=True)
        return jsonify(loaded=obj)
    except Exception:
        return "Invalid JSON", 400


ALLOWED_OPERATORS = {
    ast.Add: operator.add,
    ast.Sub: operator.sub,
    ast.Mult: operator.mul,
    ast.Div: operator.truediv,
    ast.Pow: operator.pow,
    ast.USub: operator.neg,
    ast.UAdd: operator.pos,
}


def safe_eval_expr(expr: str):
    """
    Parse expression with ast and evaluate only allowed nodes.
    """
    node = ast.parse(expr, mode="eval")

    def _eval(n):
        if isinstance(n, ast.Expression):
            return _eval(n.body)
        if isinstance(n, ast.BinOp):
            left = _eval(n.left)
            right = _eval(n.right)
            op = type(n.op)
            if op in ALLOWED_OPERATORS:
                return ALLOWED_OPERATORS[op](left, right)
            raise ValueError("Operator not allowed")
        if isinstance(n, ast.UnaryOp):
            operand = _eval(n.operand)
            op = type(n.op)
            if op in ALLOWED_OPERATORS:
                return ALLOWED_OPERATORS[op](operand)
            raise ValueError("Unary op not allowed")
        if isinstance(n, ast.Num):
            return n.n
        if isinstance(n, ast.Constant) and isinstance(n.value, (int, float)):
            return n.value
        raise ValueError("Expression contains disallowed node")

    return _eval(node)


@app.route("/calc")
def calc():
    expr = request.args.get("expr", "1+1")
    try:
        result = safe_eval_expr(expr)
        return str(result)
    except Exception:
        return "Invalid expression", 400


@app.route("/debug")
def debug():
    return jsonify(status="ok")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
