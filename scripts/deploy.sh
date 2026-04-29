#!/bin/bash
set -e

APP_DIR="/opt/bmi-app"
JAR_NAME="bmi-calculator-1.0.0.jar"
PID_FILE="$APP_DIR/app.pid"

echo ">>> Stopping existing app (if running)..."
if [ -f "$PID_FILE" ]; then
  kill "$(cat $PID_FILE)" 2>/dev/null || true
  rm -f "$PID_FILE"
  sleep 2
fi

echo ">>> Starting $JAR_NAME..."
nohup java -jar "$APP_DIR/$JAR_NAME" \
  --server.port=8080 \
  > "$APP_DIR/app.log" 2>&1 &

echo $! > "$PID_FILE"
echo ">>> App started with PID $(cat $PID_FILE)"
echo ">>> Logs: $APP_DIR/app.log"
