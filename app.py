from flask import Flask, render_template, jsonify
import psutil
import shutil
import os
import datetime

app = Flask(__name__)

@app.route("/")
def dashboard():
    return render_template("dashboard.html")

@app.route("/api/stats")
def stats():
    disk = shutil.disk_usage("/")

    files = []
    for f in os.listdir("."):
        try:
            files.append({
                "name": f,
                "size": os.path.getsize(f)
            })
        except:
            pass

    return jsonify({
        "cpu": psutil.cpu_percent(interval=0.1),
        "ram": psutil.virtual_memory().percent,
        "ram_used": round(psutil.virtual_memory().used / 1024**3, 2),
        "ram_total": round(psutil.virtual_memory().total / 1024**3, 2),
        "disk_percent": round((disk.used / disk.total) * 100, 1),
        "disk_total": round(disk.total / 1024**3, 2),
        "disk_used": round(disk.used / 1024**3, 2),
        "uptime": int(datetime.datetime.now().timestamp()),
        "time": str(datetime.datetime.now()),
        "files": files[:50]
    })

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
