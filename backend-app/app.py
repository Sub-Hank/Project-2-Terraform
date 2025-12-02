from flask import Flask, jsonify
import os
import psycopg2

app = Flask(__name__)

def check_db():
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST", "tf_postgres"),
            user=os.getenv("DB_USER", "appuser"),
            password=os.getenv("DB_PASSWORD", ""),
            dbname=os.getenv("DB_NAME", "appdb"),
            connect_timeout=2
        )
        conn.close()
        return True
    except:
        return False

@app.route("/")
def index():
    return jsonify({"status": "ok", "db": check_db()})

@app.route("/health")
def health():
    if check_db():
        return "OK", 200
    return "DB_NOT_READY", 500

@app.route("/dbtest")
def db_test():
    if check_db():
        return jsonify({"db": True, "message": "Database is reachable"})
    else:
        return jsonify({"db": False, "message": "Database not reachable"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
