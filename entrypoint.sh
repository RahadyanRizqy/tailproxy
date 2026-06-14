#!/bin/sh
set -e

HAPROXY_CFG=/etc/haproxy/haproxy.cfg

generate_haproxy_config() {
    if [ -n "$TARGET_IP" ] && [ -n "$TARGET_PORTS" ]; then
        IP_PORTS=$(echo "$TARGET_PORTS" | tr ',' '\n' | while read -r PORT; do
            echo -n "${TARGET_IP}:${PORT},"
        done | sed 's/,$//')
    fi

    if [ -z "$IP_PORTS" ]; then
        echo "[tailproxy] WARNING: IP_PORTS atau TARGET_IP/TARGET_PORTS tidak di-set, HAProxy tidak dijalankan."
        return 1
    fi

    mkdir -p /etc/haproxy

    cat > "$HAPROXY_CFG" <<EOF
global
    log stdout format raw local0
    maxconn 4096
    daemon

defaults
    log     global
    mode    tcp
    option  tcplog
    timeout connect 5s
    timeout client  30s
    timeout server  30s

EOF

    echo "$IP_PORTS" | tr ',' '\n' | while read -r ENTRY; do
        TARGET_HOST="${ENTRY%:*}"
        TARGET_PORT="${ENTRY##*:}"

        cat >> "$HAPROXY_CFG" <<EOF
frontend ft_${TARGET_PORT}
    bind *:${TARGET_PORT}
    default_backend bk_${TARGET_PORT}

backend bk_${TARGET_PORT}
    server target_${TARGET_PORT} ${TARGET_HOST}:${TARGET_PORT} check

EOF
        echo "[tailproxy] Forwarding *:${TARGET_PORT} → ${TARGET_HOST}:${TARGET_PORT}"
    done

    echo "[tailproxy] haproxy.cfg generated at $HAPROXY_CFG"
    return 0
}

if generate_haproxy_config; then
    haproxy -f "$HAPROXY_CFG" -D
    echo "[tailproxy] HAProxy started"
fi

exec /usr/local/bin/containerboot "$@"