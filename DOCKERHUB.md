```bash
docker pull rahadyanrizqy/tailproxy:latest
```

## Quick Reference

* Maintained by: Rahadyan Rizqy
* Source: [tailproxy](https://github.com/RahadyanRizqy/tailproxy)
* Based on: [tailscale/tailscale](https://hub.docker.com/r/tailscale/tailscale)
* Additional component: HAProxy
* Supported architectures: amd64, arm64

## Supported Tags

* `latest` - Latest stable release

## What is TailProxy?

TailProxy is a lightweight container that extends the official Tailscale image with HAProxy.

It allows a Linux host to act as a Tailscale-enabled pseudo-node, providing access to devices and services that cannot run Tailscale directly.

Typical use cases include:

* MikroTik routers
* NAS devices
* IP cameras
* Legacy appliances
* Internal web applications
* SSH services
* Custom TCP services

## How to Use This Image

### Multiple Targets

```bash
docker run -d \
  --name tailproxy \
  --network host \
  --cap-add=NET_ADMIN \
  --cap-add=NET_RAW \
  -e TS_AUTHKEY=tskey-xxxxxxxx \
  -e IP_PORTS=192.168.1.1:80,192.168.1.1:443,192.168.1.1:8291 \
  rahadyanrizqy/tailproxy:latest
```

### Single Host, Multiple Ports

```bash
docker run -d \
  --name tailproxy \
  --network host \
  --cap-add=NET_ADMIN \
  --cap-add=NET_RAW \
  -e TS_AUTHKEY=tskey-xxxxxxxx \
  -e TARGET_IP=192.168.1.1 \
  -e TARGET_PORTS=80,443,8291 \
  rahadyanrizqy/tailproxy:latest
```

## Parameters

### Tailscale

All environment variables supported by the upstream Tailscale container image remain available.

### TailProxy

| Variable     | Description                   |
| ------------ | ----------------------------- |
| IP_PORTS     | Comma-separated IP:PORT pairs |
| TARGET_IP    | Backend target IP             |
| TARGET_PORTS | Comma-separated port list     |

## Frequently Asked Questions

### Why use TailProxy?

Not every device can run Tailscale. TailProxy allows a Linux host to securely expose those devices through a single Tailnet node.

### Does TailProxy support reverse proxy?

Yes. TailProxy supports both reverse proxy and TCP forwarding through HAProxy.

### Is this compatible with Docker and Podman?

Yes.

### Does this replace Tailscale?

No. TailProxy extends the official Tailscale container image and relies on Tailscale for network connectivity.
