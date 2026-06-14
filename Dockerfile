FROM tailscale/tailscale:latest

# Install HAProxy
RUN apk add --no-cache haproxy

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]