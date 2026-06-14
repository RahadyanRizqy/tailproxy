# TailProxy
<p align="center">
    <img src="https://raw.githubusercontent.com/RahadyanRizqy/tailproxy/refs/heads/main/assets/tailproxy_banner.png" width="75%" alt="TailProxy" align="center">
</p>
TailProxy is a lightweight container built on top of the official Tailscale container image and enhanced with HAProxy.

It allows you to access devices and services that cannot run Tailscale themselves by turning a Linux host into a Tailscale-enabled pseudo-node. TailProxy can also be used as a reverse proxy for self-hosted applications and internal web services.

Instead of installing Tailscale on every device, TailProxy securely forwards traffic from your Tailnet to backend services on your local network, making them accessible through a single Tailscale node.

---

## ✨ Why TailProxy?

In many homelab and self-hosted environments, deploying Tailscale on every device is impractical or impossible.

TailProxy acts as a **Pseudo-Node**, representing one or more backend services behind a single Tailscale endpoint.

```text
              🌐 Tailnet
                   │
                   ▼
            🐳 TailProxy
                   │
      ┌────────────┼────────────┐
      ▼            ▼            ▼
   🌍 Web       🔒 HTTPS    📡 MikroTik
    :80          :443         :8291

      Devices without Tailscale
```

This enables secure access to internal resources without:

* ❌ Port forwarding
* ❌ Public IP exposure
* ❌ Installing Tailscale on every host
* ❌ Manual HAProxy configuration

---

## 🚀 Features

* 🔗 Based on the official `tailscale/tailscale` image
* 📡 Access devices that cannot run Tailscale
* 🔀 Multiple services behind a single Tailnet node
* 🐳 Docker and Podman compatible
* 🏗️ Supports amd64 and arm64

---

## ⚡ Quick Start

### Multiple IP:PORT Targets

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

### Single Target IP, Multiple Ports

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

Both formats produce the same forwarding behavior.

---

## 📝 Environment Variables

### Tailscale Variables

All standard variables from the upstream `tailscale/tailscale` image are supported.

### TailProxy Variables

| Variable       | Description                           |
| -------------- | ------------------------------------- |
| `IP_PORTS`     | Comma-separated list of IP:PORT pairs |
| `TARGET_IP`    | Backend target IP                     |
| `TARGET_PORTS` | Comma-separated list of ports         |

---

## 📖 Example

Expose a MikroTik router through a single TailProxy node:

```bash
TARGET_IP=192.168.1.1
TARGET_PORTS=80,443,8291
```

Generated forwarding:

```text
80    → 192.168.1.1:80
443   → 192.168.1.1:443
8291  → 192.168.1.1:8291
```

---

## 🎯 Use Cases

* 🏠 Homelabs
* 🌐 Self-hosted applications
* 📡 Router management (MikroTik, OpenWrt, etc.)
* 💾 NAS access
* 📊 Internal dashboards
* 🔧 Remote administration
* 🖥️ Legacy devices without Tailscale support
* 🔀 Service aggregation behind a single Tailnet node

---

## 🔧 Upstream Components

TailProxy extends the official Tailscale container by integrating:

* 🔗 Tailscale
* ⚡ HAProxy

---

## 📜 License

GNU Affero General Public License v3