#!/bin/sh
set -e

# Required: UUID (VLESS user id). Optional: WS_PATH (default /ws), PORT (default 3000).
if [ -z "$UUID" ]; then
  echo "ERROR: UUID environment variable is not set" >&2
  exit 1
fi
WS_PATH="${WS_PATH:-/ws}"
PORT="${PORT:-3000}"

mkdir -p /usr/local/etc/xray
cat > /usr/local/etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [ { "id": "${UUID}", "flow": "" } ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": { "path": "${WS_PATH}" }
      }
    }
  ],
  "outbounds": [
    { "protocol": "freedom", "tag": "direct" },
    { "protocol": "blackhole", "tag": "block" }
  ]
}
EOF

exec /usr/local/bin/xray run -config /usr/local/etc/xray/config.json
