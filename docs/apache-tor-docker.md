<!-- 
    WIKI GUIDE: distroverse--docs--apache-tor-docker.md
    This is an advanced, deep-dive guide into hosting anonymous services.
    It covers the architecture, security, and interaction of Docker, Tor, and Apache.
    Updated with comprehensive step-by-step instructions and practical examples.
-->

# Apache + Tor Hidden Service: The Complete Production Guide

A comprehensive guide for running an Apache web server as a **Tor Hidden Service (v3)** using **Docker**. This covers not just the "how," but the technical "why" behind every component, plus practical troubleshooting and security hardening.

---

## 📑 Table of Contents

1. [🏗️ Architecture Overview](#-architecture-overview)
2. [🐳 Docker Fundamentals](#-docker-fundamentals)
3. [🧅 Tor Deep Dive](#-tor-deep-dive)
4. [🦅 Apache Configuration](#-apache-configuration)
5. [🛠️ Step-by-Step Implementation](#-step-by-step-implementation)
6. [🔐 Security Hardening](#-security-hardening)
7. [📈 Monitoring & Troubleshooting](#-monitoring--troubleshooting)
8. [🚀 Advanced Topics](#-advanced-topics)

---

## 🏗️ Architecture Overview

### The Big Picture

When a user connects to your `.onion` address via Tor Browser, they don't connect to you directly. Instead:

```
[User's Tor Browser] 
      ↓ (3-hop circuit)
[Tor Entry → Middle → Guard Nodes]
      ↓ (Rendezvous Point)
[Your Tor Container (Gateway)]
      ↓ (Docker Internal Bridge)
[Apache Container (Content Server)]
```

**Key Principle:** The Apache server **never touches the public internet**. It only communicates with the Tor container over a private Docker bridge network.

### Why This Architecture?

1. **Isolation:** If Apache is exploited, the attacker is trapped in a container with no internet access
2. **Anonymity:** Your real IP is never exposed; all traffic routes through Tor
3. **Separation of Concerns:** The Tor gateway and web server are independent services
4. **Scalability:** You can add multiple web server instances behind the Tor gateway

---

## 🐳 Docker Fundamentals

### What is Docker?

Docker uses **OS-level virtualization** (not hypervisor-based) to run isolated applications. Unlike VMs, containers share the host's kernel but run in isolated user spaces.

### Key Concepts

#### Images vs. Containers
- **Image:** A read-only template (blueprint) containing all dependencies
- **Container:** A running instance of an image with read-write layer on top
- **Registry:** Repository of images (Docker Hub, Quay.io, etc.)

**Example:**
```bash
# Pull an image from Docker Hub
docker pull httpd:2.4-alpine

# Run it as a container
docker run -d --name web httpd:2.4-alpine

# List running containers
docker ps
```

#### Linux Namespaces (Isolation)

Docker uses Linux kernel namespaces to isolate processes:

- **Network Namespace (net):** Isolated network stack
  - Own `eth0`, routing tables, firewall rules
  - Invisible to external network scanners
  - Can't see host's open ports

- **Mount Namespace (mnt):** Isolated filesystem
  - Container has its own root (`/`)
  - Can't access host's `/etc/shadow` or sensitive files
  - Files mapped via `volumes` in docker-compose

- **PID Namespace (pid):** Isolated process tree
  - Processes think they're PID 1 (init)
  - Can't see host's other processes
  - `docker exec` lets you run commands inside

- **IPC Namespace (ipc):** Isolated inter-process communication
  - Prevents access to host's shared memory
  - Stops process signaling between host and container

- **UTS Namespace (uts):** Isolated hostname/domain
  - Container has its own hostname
  - Example: `apache-server` vs `my-laptop`

#### Control Groups (cgroups)

Limit resource usage:
```bash
# Prevent Apache from using more than 512MB RAM
# Or more than 50% CPU

docker run -d --memory=512m --cpus=0.5 httpd:2.4-alpine
```

### Docker Networking Modes

For this guide, we use **Bridge Networking**:

```
┌─────────────────────────────────────────┐
│         Host (Your Server)              │
│  ┌──────────────────────────────────┐   │
│  │  Docker Virtual Bridge (172.18.0.0/16) │
│  │                                  │   │
│  │  ┌─────────────────────────────┐ │   │
│  │  │  Tor Container              │ │   │
│  │  │  IP: 172.18.0.2             │ │   │
│  │  └─────────────────────────────┘ │   │
│  │                                  │   │
│  │  ┌─────────────────────────────┐ │   │
│  │  │  Apache Container           │ │   │
│  │  │  IP: 172.18.0.3             │ │   │
│  │  └─────────────────────────────┘ │   │
│  └──────────────────────────────────┘   │
│           ↑                              │
│    (Only exposed via Tor)                │
└─────────────────────────────────────────┘
```

**Benefits:**
- Containers can reach each other by hostname (DNS)
- Both containers invisible to clearnet
- Uses `iptables` for internal NAT
- Completely separate from host's network

### Docker Storage

Each container gets a read-write layer on top of the read-only image:

```
Read-Only Image Layers (from Dockerfile)
  └─ base OS (Alpine)
  └─ Apache packages
  └─ Config files

Read-Write Container Layer (active at runtime)
  └─ New files created during runtime
  └─ Modified files
  └─ Deleted files (marked as deleted, not actually removed)
```

**Volume Mapping:**
- `volumes:` in docker-compose maps persistent directories
- Without volumes, data is lost when container stops
- Essential for Tor's private key storage (`.onion` address)

---

## 🧅 Tor Deep Dive

### How Tor Provides Anonymity

Tor uses **onion routing** (multi-layered encryption):

**For Regular Tor Users (Exit Traffic):**
```
Client's Browser
  ↓ (Encrypted to Guard, Guard knows client IP)
Guard Node (Entry Node)
  ↓ (Encrypted to Middle, Middle sees neither end)
Middle Relay
  ↓ (Encrypted to Exit, Exit knows destination but not source)
Exit Node
  ↓ (Unencrypted)
Regular Website
```

**For Hidden Services (No Exit):**
```
Your Server (Tor Container)
  ↓ (Encrypted, builds 3-hop circuit outbound)
Guard → Middle → Rendezvous Point
  
User (Tor Browser)
  ↓ (Encrypted, builds 3-hop circuit inbound)
Guard → Middle → Rendezvous Point
  
[Both meet at Rendezvous Point anonymously]
```

### Tor Hidden Services (v3)

**v3 Addresses (56 characters):**
```
thisisyouronionaddressv3example7xq4fx2zfuzed5oxc.onion
```

This address is **self-authenticating**:
- Contains a SHA3 hash of your Ed25519 public key
- No Certificate Authority needed
- Cannot be forged without the private key
- Automatically verified by Tor Browser

**The v3 Registration Process:**

1. **Introduction Points Selection**
   - Your Tor daemon picks 3 random relays
   - Tells them "I'm an intro point for this service"
   - Gives them your public key

2. **Descriptor Creation**
   - Create a "Service Descriptor" containing:
     - List of Introduction Points
     - Your public key
     - Current timestamp
   - Sign it with your private key

3. **Directory Upload**
   - Upload descriptor to **Hidden Service Directories (HSDir)**
   - Multiple HSDir relays store copies redundantly
   - Encrypted so HSDir operators can't see the content

4. **User Discovery**
   - User gets your `.onion` address (from website, QR code, etc.)
   - Queries HSDir network for your descriptor
   - Downloads the descriptor with your Intro Points

5. **Rendezvous Connection**
   - User picks a random relay as **Rendezvous Point**
   - Sends intro message to one of your Intro Points
   - Your Tor container connects to the same Rendezvous Point
   - Both parties authenticate and exchange encryption keys
   - Connection established!

### Ed25519 Cryptography

v3 uses **Ed25519** (Curve25519 derivatives):

- **Advantages over RSA:**
  - Much smaller key size (32 bytes vs. 256+ for RSA-2048)
  - Faster verification
  - Resistant to timing attacks
  - No random number generation (deterministic)

- **Key Files:**
  - `hs_ed25519_secret_key` - Your private key (KEEP SECURE!)
  - `hs_ed25519_public_key` - Derived public key
  - `hostname` - Your `.onion` address

**Critical:** If you lose the private key, you lose your address forever.

---

## 🦅 Apache Configuration

### Why Apache for Tor?

- **Configurability:** Extensive `.htaccess` and module support
- **Performance:** Event MPM handles concurrent connections efficiently
- **Maturity:** 25+ years of battle-tested reliability
- **Security:** Strong track record with rapid patch cycles

### Multi-Processing Modules (MPM)

Apache can handle requests with different models:

**Event MPM (Recommended for Tor):**
```apache
<IfModule mpm_event_module>
    StartServers             2
    MinSpareServers          2
    MaxSpareServers          5
    MaxRequestWorkers        150
    MaxConnectionsPerChild   0
</IfModule>
```

**Why Event?**
- Single dedicated thread handles new connections
- Other threads handle long-running requests
- One slow Tor user won't block others
- Better for high-latency, unpredictable traffic

### Security Hardening Configuration

```apache
# 1. Hide Server Information
ServerTokens ProductOnly
ServerSignature Off

# 2. Deny Access to Sensitive Files
<DirectoryMatch "/\.(?!well-known)">
    Require all denied
</DirectoryMatch>

# 3. Restrict File Uploads
<Directory /var/www>
    <FilesMatch "\.(php|phtml|php3|php4|php5|phtml|phps|pht|phar|phpt|pgif|shtml|htaccess|phtml|php7)$">
        Require all denied
    </FilesMatch>
</Directory>

# 4. Disable Directory Listing
<Directory /var/www/html>
    Options -Indexes
    Options -FollowSymLinks
</Directory>

# 5. Prevent Code Execution
<LocationMatch "^/upload">
    php_flag engine off
    AddType text/plain .php
</LocationMatch>

# 6. Add Security Headers
Header set X-Content-Type-Options "nosniff"
Header set X-Frame-Options "DENY"
Header set X-XSS-Protection "1; mode=block"
Header set Referrer-Policy "no-referrer"
```

### Resource Limits (Prevent DoS)

```apache
# Prevent buffer overflow attacks
LimitRequestBody 1048576         # 1MB max per request
LimitRequestFields 50             # Max 50 headers per request
LimitRequestFieldSize 8190        # Max 8KB per header

# Prevent Slowloris DDoS
TimeOut 30
KeepAliveTimeout 10
MaxKeepAliveRequests 100

# Connection limits
MaxClients 200
```

---

## 🛠️ Step-by-Step Implementation

### Prerequisites

1. **Docker & Docker Compose installed:**
   ```bash
   # Verify installation
   docker --version
   docker-compose --version
   ```

2. **Sufficient disk space:**
   - At least 2GB free for images and containers

3. **Basic understanding of:**
   - Linux commands and shell
   - YAML syntax
   - Network fundamentals

### Step 1: Create Project Structure

```bash
# Create dedicated directory
mkdir -p ~/tor-service && cd ~/tor-service

# Create subdirectories
mkdir -p tor/keys             # Tor private keys (.onion identity)
mkdir -p apache/conf          # Apache configuration overrides
mkdir -p apache/htdocs        # Website content
mkdir -p logs                 # Docker container logs

# Directory structure:
# tor-service/
# ├── docker-compose.yml      # Orchestration
# ├── Dockerfile              # Apache image definition
# ├── tor/
# │   ├── keys/               # .onion address storage (PERSISTENT!)
# │   └── torrc               # Tor configuration
# ├── apache/
# │   ├── conf/               # Apache config overrides
# │   └── htdocs/             # Website files
# └── logs/                   # Container logs
```

### Step 2: Create Apache Dockerfile

Create `~/tor-service/Dockerfile`:

```dockerfile
FROM httpd:2.4-alpine

# Update packages
RUN apk update && apk add --no-cache \
    curl \
    ca-certificates \
    openssl

# Create necessary directories
RUN mkdir -p /usr/local/apache2/logs && \
    mkdir -p /usr/local/apache2/conf.d

# Remove default index
RUN rm -f /usr/local/apache2/htdocs/index.html

# Copy website content
COPY ./apache/htdocs/ /usr/local/apache2/htdocs/

# Copy custom Apache config
COPY ./apache/conf/httpd-custom.conf /usr/local/apache2/conf.d/custom.conf

# Security: Remove documentation and CGI examples
RUN rm -rf /usr/local/apache2/cgi-bin/* && \
    rm -rf /usr/local/apache2/error/* && \
    rm -rf /usr/local/apache2/icons/*

# Enable required modules
RUN sed -i 's/^#LoadModule headers_module/LoadModule headers_module/' \
    /usr/local/apache2/conf/httpd.conf && \
    sed -i 's/^#LoadModule rewrite_module/LoadModule rewrite_module/' \
    /usr/local/apache2/conf/httpd.conf

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Default command
CMD ["httpd-foreground"]
```

### Step 3: Create Apache Configuration Override

Create `~/tor-service/apache/conf/httpd-custom.conf`:

```apache
# Security Headers
Header set X-Content-Type-Options "nosniff"
Header set X-Frame-Options "DENY"
Header set X-XSS-Protection "1; mode=block"
Header set Referrer-Policy "no-referrer"

# Hide server info
ServerTokens ProductOnly
ServerSignature Off

# Deny access to hidden files
<DirectoryMatch "/\.">
    Require all denied
</DirectoryMatch>

# Disable directory listing
<Directory /usr/local/apache2/htdocs>
    Options -Indexes
    Options -FollowSymLinks
</Directory>

# Resource limits
LimitRequestBody 1048576
LimitRequestFields 50

# Performance
KeepAliveTimeout 10
MaxKeepAliveRequests 100
TimeOut 30
```

### Step 4: Create Tor Configuration

Create `~/tor-service/tor/torrc`:

```conf
# Tor configuration for hidden service

# Disable SOCKS (we don't need it for inbound services)
SocksPort 0

# Enable control port for monitoring (internal only)
ControlPort 9051
CookieAuthentication 1

# Hidden Service Configuration
HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort 80 apache:80
HiddenServiceVersion 3

# Logging (helpful for debugging)
Log notice file /var/log/tor/notices.log

# Performance tuning
NumEntryGuards 3
NumDirectoryGuards 3

# Safety: Disable IPv6 relay (optional, for extra caution)
# IPv6Traffic NoPrefer
```

### Step 5: Create Docker Compose

Create `~/tor-service/docker-compose.yml`:

```yaml
version: '3.8'

services:
  # Tor Hidden Service Gateway
  tor:
    image: goldy/tor-hidden-service:latest
    container_name: tor-gateway
    restart: always
    
    # Environment configuration
    environment:
      # Service mapping (format: ServiceName:Port)
      - SERVICES=apache:80
      
    # Mount volumes for persistent storage
    volumes:
      # Persistent .onion address identity
      - ./tor/keys:/var/lib/tor/hidden_service/
      
      # Custom Tor configuration
      - ./tor/torrc:/etc/tor/torrc:ro
      
      # Logs for monitoring
      - ./logs/tor:/var/log/tor:rw
    
    # Network configuration
    networks:
      - onion_net
    
    # Resource limits
    # (prevents Tor from consuming all resources)
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
    
    # Wait for Apache to be ready
    depends_on:
      apache:
        condition: service_healthy

  # Apache Web Server
  apache:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: apache-server
    restart: unless-stopped
    
    # CRITICAL: No 'ports' mapping!
    # Apache only communicates via Docker bridge
    # This keeps it completely off the clearnet
    
    # Mount volumes
    volumes:
      # Read-write logs
      - ./logs/apache:/usr/local/apache2/logs:rw
      
      # Optional: Hot-reload website content
      - ./apache/htdocs:/usr/local/apache2/htdocs:ro
    
    # Network configuration (on isolated bridge)
    networks:
      - onion_net
    
    # Resource limits
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 1G
        reservations:
          cpus: '1'
          memory: 512M
    
    # Health check
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 10s

# Custom bridge network (isolated, no clearnet access)
networks:
  onion_net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.18.0.0/16
          gateway: 172.18.0.1
    driver_opts:
      # Ensure this network is completely internal
      com.docker.network.bridge.enable_ip_masquerade: "true"

# Named volumes for persistence
volumes:
  tor_keys:
  apache_logs:
```

### Step 6: Create Sample Website

Create `~/tor-service/apache/htdocs/index.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Anonymous Service</title>
    <style>
        body {
            font-family: monospace;
            background: #000;
            color: #0f0;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        h1 {
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🧅 Hidden Service Online</h1>
        <p>This site is only accessible via Tor.</p>
        <p>You are using Tor. Your IP address is hidden.</p>
    </div>
</body>
</html>
```

### Step 7: Start the Services

```bash
cd ~/tor-service

# Build and start containers
docker-compose up -d

# View startup logs
docker-compose logs -f

# Wait for Tor to bootstrap (check for "Bootstrapped 100%")
docker-compose logs tor | grep "Bootstrapped"
```

### Step 8: Retrieve Your .onion Address

```bash
# The .onion address is generated on first run
cat ~/tor-service/tor/keys/hostname

# Output looks like:
# thisisyouronionaddressv3example7xq4fx2zfuzed5oxc.onion
```

**Save this address immediately!** Share it securely with intended users.

### Step 9: Access Your Service

1. **Download Tor Browser** from [torproject.org](https://www.torproject.org)
2. **Open Tor Browser**
3. **Navigate to your `.onion` address**
4. **You should see your website!**

---

## 🔐 Security Hardening

### 1. Metadata Removal

Before uploading any files, strip metadata:

```bash
# Install exiftool
sudo pacman -S perl-image-exiftool  # Arch
sudo apt install libimage-exiftool-perl  # Debian

# Remove ALL metadata from images
exiftool -all= ~/my-photo.jpg

# Verify metadata is removed
exiftool ~/my-photo.jpg | head -5
```

### 2. Rootless Docker (Advanced)

By default, Docker daemon runs as root. Configure rootless mode:

```bash
# Install rootless setup script
curl https://get.docker.com/rootless | bash

# Start rootless daemon
systemctl --user enable --now docker.service

# Verify
docker run --rm alpine whoami  # Should output: root (inside container), but daemon runs as your user
```

### 3. Network Isolation

Verify the network is truly internal:

```bash
# List networks
docker network ls

# Inspect our network
docker network inspect tor-service_onion_net

# Check for "Internal: false" in output
# If you see "Internal: false", add it to docker-compose.yml:
# networks:
#   onion_net:
#     internal: true
```

### 4. Disable Server-Side Scripting

**Remove support for PHP, Python, Node.js unless absolutely necessary:**

```apache
# In httpd-custom.conf
<FilesMatch "\.(php|phtml|php3|php4|php5|phtml|phps|pht|phar|phpt|shtml|cgi|pl|py|pyc)$">
    Require all denied
</FilesMatch>
```

**Why?**
- 99% of de-anonymization attacks exploit code execution
- PHP/Python can accidentally log visitor data
- Environment variables might leak

### 5. Backups & Key Management

```bash
# CRITICAL: Backup your .onion private key
cp ~/tor-service/tor/keys/hs_ed25519_secret_key ~/hs_ed25519_secret_key.backup

# Store securely (offline, encrypted USB, etc.)
# If you lose this, your .onion address is gone forever

# To restore from backup:
cp ~/hs_ed25519_secret_key.backup ~/tor-service/tor/keys/hs_ed25519_secret_key
docker-compose restart tor
```

### 6. Content Verification

```bash
# Create a hash of your website content
sha256sum ~/tor-service/apache/htdocs/index.html > index.html.sha256

# Users can verify:
sha256sum -c index.html.sha256
```

---

## 📈 Monitoring & Troubleshooting

### View Logs

```bash
# All logs
docker-compose logs

# Specific service
docker-compose logs tor
docker-compose logs apache

# Follow in real-time
docker-compose logs -f

# Last 50 lines
docker-compose logs --tail=50

# Since specific time
docker-compose logs --since 2024-01-01
```

### Common Issues & Solutions

#### Issue: "Can't connect to .onion address"

**Checklist:**
1. **Wait 60 seconds** - Tor needs time to build circuits
2. **Check Tor status:**
   ```bash
   docker-compose logs tor | grep "Bootstrapped"
   # Should show "Bootstrapped 100%"
   ```

3. **Test internal connectivity:**
   ```bash
   docker-compose exec tor ping apache
   # Should show: 64 bytes from apache (172.18.0.3): seq=0 ttl=64 time=0.xxx ms
   ```

4. **Check Apache is running:**
   ```bash
   docker-compose exec apache curl http://localhost/
   # Should return your HTML
   ```

5. **Verify Tor service file exists:**
   ```bash
   ls -la ~/tor-service/tor/keys/
   # Should show: hostname, hs_ed25519_public_key, hs_ed25519_secret_key
   ```

#### Issue: "504 Bad Gateway"

The Tor container can't reach Apache. Run:

```bash
# Check if Apache is responding
docker-compose exec tor curl http://apache:80/

# If timeout, check if containers are on same network
docker network inspect tor-service_onion_net | grep -A 5 "Containers"

# Check Apache health
docker-compose exec apache ps aux | grep apache

# Restart services in order
docker-compose restart apache
sleep 5
docker-compose restart tor
```

#### Issue: ".onion address changed"

If your address changed, you probably deleted the volume:

```bash
# Check volume
docker volume ls | grep tor

# To prevent: Never run 'docker-compose down -v'
# Always use: 'docker-compose down'
```

#### Issue: High Memory Usage

Tor can use significant memory during peak traffic:

```bash
# Check resource usage
docker stats tor apache

# Reduce Tor memory footprint
# Edit ~/tor-service/tor/torrc and add:
# MaxMemInQueues 256 MB
```

### Monitoring Commands

```bash
# Check container status
docker-compose ps

# View resource usage
docker stats

# Inspect Tor circuit information
docker-compose exec tor cat /var/log/tor/notices.log | tail -20

# Test performance
docker-compose exec tor curl -w "Time: %{time_total}s\n" http://apache:80/

# Check disk usage
du -sh ~/tor-service/

# Verify network isolation
docker-compose exec apache curl http://example.com/
# Should timeout (no external internet)
```

---

## 🚀 Advanced Topics

### Multiple Services Behind Tor

To host multiple services (.onion address shared):

```yaml
# In docker-compose.yml
services:
  tor:
    environment:
      - SERVICES=apache:80,api:8080,chat:9000
  
  # Add your other services...
```

### Using Own Tor Image

Instead of pre-built image, build your own:

```dockerfile
# Dockerfile.tor
FROM alpine:latest

RUN apk update && apk add --no-cache tor

COPY torrc /etc/tor/torrc

EXPOSE 9050 9051

CMD ["tor", "-f", "/etc/tor/torrc"]
```

Then update docker-compose.yml:

```yaml
services:
  tor:
    build:
      context: .
      dockerfile: Dockerfile.tor
```

### Load Balancing

For high-traffic services, use multiple Apache containers:

```yaml
services:
  tor:
    # ... existing config
  
  apache-1:
    build: .
    networks:
      - onion_net
    # ... health checks
  
  apache-2:
    build: .
    networks:
      - onion_net
    # ... health checks
  
  load-balancer:
    image: nginx:alpine
    networks:
      - onion_net
    # Configure nginx to round-robin to apache-1 and apache-2
```

### SSL/TLS (Onion Sites Don't Need It)

Standard HTTPS is **unnecessary** for onion sites because:
- Tor already provides encryption (layer 3)
- Adding HTTPS creates redundant encryption
- Most onion sites serve plain HTTP

However, if you want certificate pinning:

```bash
# Generate self-signed certificate
openssl req -x509 -newkey rsa:4096 -nodes \
  -out cert.pem -keyout key.pem -days 365
```

### Performance Tuning

```apache
# In httpd-custom.conf

# Enable caching headers for static content
<FilesMatch "\\.(jpg|jpeg|png|gif|ico|css|js)$">
    Header set Cache-Control "max-age=86400, public"
</FilesMatch>

# Gzip compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript
</IfModule>

# Connection tuning
KeepAliveTimeout 5
MaxKeepAliveRequests 200
TimeOut 60
```

### Monitoring with Prometheus

For advanced monitoring (optional):

```bash
# Export Tor statistics
docker-compose exec tor monitor
# Parse via prometheus_client
```

---

## 📚 Important Tips

### Before Going Live

- ✅ **Test everything locally first** with Tor Browser
- ✅ **Backup your private key** multiple times
- ✅ **Remove all metadata** from files
- ✅ **Verify links are relative** (no absolute URLs to your real domain)
- ✅ **Enable HTTPS** if handling sensitive data (even though Tor encrypts)
- ✅ **Set up logging** for debugging but don't log user IPs
- ✅ **Monitor for updates** to Docker images

### Persistence

```bash
# IMPORTANT: These commands affect your .onion address

# Safe (keeps .onion):
docker-compose down        # Stops containers, keeps volumes

# DANGEROUS (regenerates .onion):
docker-compose down -v     # Deletes everything including volumes!
docker volume rm tor-service_tor_keys

# Only use down -v if you want a NEW .onion address
```

### Access Logs

By default, Tor hides visitor information. However, access logs are still created:

```bash
# Check Apache access logs (no IP addresses, just generic "hidden")
tail -f ~/tor-service/logs/apache/access_log
```

### Keep Images Updated

```bash
# Pull latest versions
docker-compose pull

# Rebuild Apache image
docker-compose build --no-cache apache

# Restart services
docker-compose up -d
```

---

## 📖 Additional Resources

- **Tor Project:** [torproject.org](https://www.torproject.org)
- **Tor Hidden Services Documentation:** [trac.torproject.org/projects/tor/wiki/doc/HiddenServices](https://trac.torproject.org/projects/tor/wiki/doc/HiddenServices)
- **Docker Documentation:** [docs.docker.com](https://docs.docker.com)
- **Apache Security Guide:** [httpd.apache.org/security](https://httpd.apache.org/security)
- **Onion Share** (simpler alternative): [onionshare.org](https://onionshare.org)

---

**Pro Tip:** Keep your service simple, static, and boring. The less complexity, the fewer attack vectors. A simple HTML site is infinitely more secure than a dynamic WordPress installation.
