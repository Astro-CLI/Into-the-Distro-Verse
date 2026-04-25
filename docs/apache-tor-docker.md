# Apache + Tor Hidden Service with Docker

A complete guide to running an Apache web server as a Tor hidden service (.onion domain) using Docker. This setup allows you to host a website accessible only via Tor, with complete anonymity, easy management, and instant cleanup. Perfect for whistleblowers, privacy advocates, activists, and anyone who wants to share information without revealing their identity or location.

---

## 📋 Table of Contents

- Prerequisites & Installation
- Understanding Tor & .onion Domains
- Setup Instructions
- Starting the Services
- Accessing Your Server
- Customization Options
- Security Considerations
- Troubleshooting
- References

---

## Prerequisites & Installation

### What You'll Need

This guide requires Docker, Docker Compose, and optionally Tor Browser for testing. Let's install each component:

---

## 🐳 Docker Installation

Docker containerizes your entire application, making it portable and easy to manage.

### On Arch Linux

```bash
# Install Docker
sudo pacman -S docker

# Start and enable Docker daemon
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to docker group (avoid sudo for every command)
sudo usermod -aG docker $USER

# Log out and back in, then verify
docker --version
```

### On Fedora

```bash
# Install Docker
sudo dnf install docker

# Start and enable
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER

# Verify
docker --version
```

### On Ubuntu/Debian

```bash
# Update package list
sudo apt update

# Install dependencies
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start and enable
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER

# Verify
docker --version
```

**Important:** After adding your user to the docker group, log out and log back in for the changes to take effect.

---

## 🐳 Docker Compose Installation

Docker Compose allows you to define multi-container applications in a single YAML file.

### On Arch Linux

```bash
sudo pacman -S docker-compose
docker-compose --version
```

### On Fedora

```bash
sudo dnf install docker-compose
docker-compose --version
```

### On Ubuntu/Debian

```bash
# Download latest version
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make executable
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker-compose --version
```

---

## 🔒 Tor Browser Installation

Tor Browser allows you to securely access your hidden service and browse the Tor network.

### On Arch Linux (AUR)

```bash
# Using yay or paru
paru -S tor-browser

# Or install manually
sudo pacman -S tor
```

### On Fedora

```bash
sudo dnf install tor-browser
```

### On Ubuntu/Debian

```bash
# Install Tor Browser Launcher (recommended)
sudo apt install torbrowser-launcher

# Then run it
torbrowser-launcher
```

### Manual Installation (All Linux)

Download from [torproject.org/download](https://www.torproject.org/download/):
1. Download the Linux bundle
2. Extract: `tar -xf tor-browser-linux64-*.tar.xz`
3. Run: `./tor-browser_*/Browser/start-tor-browser.desktop`

---

## 🌐 Understanding Tor & .onion Domains

### What is Tor?

**Tor** (The Onion Router) is free software that enables anonymous communication by:
- Routing internet traffic through multiple volunteer-operated nodes
- Encrypting data in multiple layers (like an onion)
- Obscuring your IP address and location
- Making it difficult to trace activity back to you

### What is a Hidden Service (.onion)?

A **hidden service** (or onion service) is:
- A website accessible only through Tor
- Identified by a `.onion` address (e.g., `abcd1234efgh5678.onion`)
- Automatically encrypted (no HTTPS needed)
- Provides anonymity for both publisher and visitor
- Cannot be accessed via regular browsers

### .onion Address Format

```
abcd1234efgh5678ijkl9999nnnn5555.onion
├─────────────────────────────────┘
    56-character onion address
    (v3 addresses, 56 chars)

Previously v2: 16-character addresses (deprecated)
```

### Why Use Docker for Tor Hidden Services?

- **Easy cleanup** — Delete containers and volumes, everything is gone
- **Portability** — Same setup works on any Linux system
- **Isolation** — Tor and Apache run in separate, isolated environments
- **Persistence** — Docker volumes keep your .onion address stable
- **Simple management** — One command to start/stop everything

---

## Prerequisites

---

## 🎯 Use Cases for Tor Hidden Services

### ✅ Legitimate Use Cases

- **Whistleblowing platforms** — Share sensitive information safely (like WikiLeaks)
- **Privacy-focused forums** — Host discussions without tracking
- **Censorship circumvention** — Access information in restricted regions
- **Anonymous publishing** — Share news from dangerous areas
- **Secure communication** — Host messaging or collaboration tools
- **Research & activism** — Organizations that need anonymity for safety
- **Secure documentation** — Store sensitive research or files
- **Testing & development** — Secure staging environment

### ⚠️ Note on Responsibilities

Tor hidden services are powerful tools for privacy and freedom of speech. Use them responsibly:
- Don't host illegal content
- Respect laws and ethics
- Remember anonymity ≠ immunity
- Tor enables privacy, not lawlessness

---

## 🔐 Understanding Security & Anonymity

### Anonymity ≠ Privacy

| Aspect | Meaning |
|--------|---------|
| **Anonymity** | Others don't know WHO you are |
| **Privacy** | Your data isn't intercepted or visible |
| **Encryption** | Data is scrambled in transit |
| **Tor provides** | Anonymity + some privacy |
| **HTTPS adds** | Additional encryption layer |
| **ISP sees** | "Traffic to Tor entry node" (not your destination) |
| **Tor exit node sees** | HTTP traffic (if not HTTPS) |
| **Destination sees** | Tor exit node IP, not yours |

### Threat Model Considerations

**Tor protects you from:**
- Your ISP seeing what sites you visit
- Websites seeing your real IP address
- Network observers tracking your location
- Correlation attacks on your browsing

**Tor does NOT protect you from:**
- Malware on your computer
- Visiting sites that identify you
- JavaScript vulnerabilities
- Government-level adversaries (maybe)
- Your hosting provider knowing you run a hidden service

---

## 🚀 Setup Instructions

### Step 1: Create Working Directory

```bash
mkdir -p ~/apache-tor && cd ~/apache-tor
```

### Step 2: Create Dockerfile

```bash
cat > Dockerfile << 'EOF'
FROM httpd:latest
COPY index.html /usr/local/apache2/htdocs/
EOF
```

**Explanation:**
- `FROM httpd:latest` — Start with official Apache image
- `COPY index.html` — Add your website to Apache's web root

### Step 3: Create index.html

```bash
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Onion Server</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 40px; background: #222; color: #fff; }
    h1 { color: #9933ff; }
    .info { background: #333; padding: 20px; border-radius: 5px; }
  </style>
</head>
<body>
  <h1>🧅 Hello from .onion!</h1>
  <div class="info">
    <p>This website is hosted via Tor hidden service.</p>
    <p>You are accessing this through the Tor network.</p>
    <p><strong>Your IP address is hidden.</strong></p>
  </div>
</body>
</html>
EOF
```

### Step 4: Create Torrc Configuration

The `torrc` file configures Tor's hidden service behavior:

```bash
cat > torrc << 'EOF'
# Disable SOCKS proxy (not needed for this setup)
SocksPort 0

# Enable control port for monitoring (optional)
ControlPort 9051
CookieAuthentication 1

# Hidden service configuration
HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort 80 apache:80
HiddenServiceVersion 3

# Logging
Log notice file /var/log/tor/notices.log
EOF
```

**Configuration Explanation:**

| Setting | Purpose |
|---------|---------|
| `SocksPort 0` | Disable SOCKS proxy (not needed for hidden services) |
| `ControlPort 9051` | Enable control port for monitoring |
| `CookieAuthentication 1` | Protect control port with authentication |
| `HiddenServiceDir` | Where Tor stores hidden service keys (IMPORTANT) |
| `HiddenServicePort 80 apache:80` | Map port 80 on .onion to Apache's port 80 |
| `HiddenServiceVersion 3` | Use v3 addresses (56 characters, more secure) |
| `Log notice file` | Log important events to file |

**Security Note:** The `HiddenServiceDir` contains your `.onion` address private key. Protect it like your password!

### Step 5: Create docker-compose.yml

```bash
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  apache:
    build: .
    container_name: apache-server
    restart: unless-stopped
    ports:
      - "8080:80"
    networks:
      - tornet
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80/"]
      interval: 30s
      timeout: 5s
      retries: 3

  tor:
    image: torproject/tor:latest
    container_name: tor-hidden-service
    restart: unless-stopped
    volumes:
      - ./torrc:/etc/tor/torrc
      - tor-data:/var/lib/tor
    networks:
      - tornet
    depends_on:
      - apache

networks:
  tornet:
    driver: bridge

volumes:
  tor-data:
EOF
```

**Configuration Details:**

| Setting | Purpose |
|---------|---------|
| `version: '3.8'` | Docker Compose file format |
| `build: .` | Build Apache from local Dockerfile |
| `restart: unless-stopped` | Auto-restart if container crashes |
| `ports: 8080:80` | Map port 8080 locally to port 80 in container |
| `networks: tornet` | Private Docker network for container communication |
| `volumes` | Mount torrc config and persistent Tor data |
| `depends_on: apache` | Start Apache before Tor |
| `healthcheck` | Automatically verify Apache is responding |

---

## 🚀 Starting the Services

### Launch Everything

```bash
docker-compose up -d
```

**Output:**
```
Creating network "apache-tor_tornet" with driver "bridge"
Creating volume "apache-tor_tor-data" with default driver
Building apache
...
Successfully built abc123def456
Creating apache-server
Creating tor-hidden-service
```

### Check Status

```bash
docker-compose ps
```

### View Logs

```bash
# All logs
docker-compose logs

# Tor logs only
docker-compose logs tor

# Apache logs only
docker-compose logs apache

# Follow logs in real-time
docker-compose logs -f tor
```

---

## 🔑 Get Your .onion Address

Your .onion address is generated automatically and stored persistently:

```bash
docker exec tor-hidden-service cat /var/lib/tor/hidden_service/hostname
```

**Output example:**
```
abcd1234efgh5678ijkl9999nnnn5555.onion
```

### Understanding Your .onion Address

- **56 characters** (v3 format, modern and secure)
- **Stable** — Same address every time you start (as long as tor-data volume exists)
- **Private** — Keep secret if you want real anonymity
- **Derived from** — Your public key using elliptic curve cryptography
- **Uniqueness** — Your address is unique; you can't choose it

### ⚠️ Important

Your .onion address is your hidden service's unique identifier and private key combined. If someone has access to your `tor-data` volume, they can impersonate your hidden service. **Treat it like a password.**

---

## 🌐 Accessing Your Server

### Option 1: Via Tor Browser (Recommended for Others)

Best way for people to access your hidden service:

1. **Download Tor Browser** from [torproject.org/download](https://www.torproject.org/download/)
2. **Install and launch** Tor Browser
3. **Wait for connection** — You'll see "Connected to Tor"
4. **Visit your address:**
   ```
   http://YOUR_ONION_ADDRESS.onion
   ```

### Option 2: Via Torsocks (Command Line)

For testing from command line:

```bash
# Install torsocks first
# Arch
sudo pacman -S torsocks

# Fedora
sudo dnf install torsocks

# Ubuntu/Debian
sudo apt install torsocks

# Then test your site
torsocks curl http://YOUR_ONION_ADDRESS.onion
```

### Option 3: Local Testing (No Tor Required)

Test locally without using Tor network:

```bash
# Via curl
curl http://localhost:8080

# Via browser
# Open http://localhost:8080
```

### Option 4: From Another Machine (Via SSH Tunnel)

```bash
# Forward port through SSH
ssh -L 8888:localhost:8080 user@remote-host

# Then visit locally
curl http://localhost:8888
```

---

## ⚙️ Customization Options

### Add More Web Files

Add CSS, JavaScript, images, etc.:

```bash
# Create files directory
mkdir -p files/css files/js files/images

# Add files
cp my-style.css files/css/
cp script.js files/js/
cp logo.png files/images/

# Update Dockerfile
cat > Dockerfile << 'EOF'
FROM httpd:latest
COPY index.html /usr/local/apache2/htdocs/
COPY files/ /usr/local/apache2/htdocs/
EOF

# Rebuild
docker-compose up -d --build
```

### Custom Apache Configuration

```bash
# Create custom Apache config
cat > httpd-custom.conf << 'EOF'
# Enable mod_rewrite
LoadModule rewrite_module modules/mod_rewrite.so

# Custom error pages
ErrorDocument 404 /404.html
ErrorDocument 500 /500.html

# Disable directory listing
Options -Indexes

# Enable GZIP compression
LoadModule deflate_module modules/mod_deflate.so
AddOutputFilterByType DEFLATE text/html text/plain text/xml
EOF

# Update docker-compose.yml to mount it:
# volumes:
#   - ./httpd-custom.conf:/usr/local/apache2/conf/conf.d/custom.conf
```

### Multiple Websites on One .onion

```dockerfile
FROM httpd:latest
COPY site1/ /usr/local/apache2/htdocs/site1/
COPY site2/ /usr/local/apache2/htdocs/site2/
COPY index-redirect.html /usr/local/apache2/htdocs/index.html
```

Access via:
- `http://YOUR_ONION.onion/site1/`
- `http://YOUR_ONION.onion/site2/`

### HTTPS on .onion

Even though .onion traffic is already encrypted, you can add HTTPS:

```bash
# Generate self-signed certificate
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes

# Update torrc
HiddenServicePort 443 apache:443

# Update docker-compose.yml ports
ports:
  - "8443:443"

# Enable mod_ssl in Dockerfile and httpd.conf
```

---

## Stopping & Cleanup

### Pause Services (Keep .onion Address)

```bash
docker-compose down
```

Everything is preserved. Your .onion address stays the same when you restart.

### Stop & Remove Everything

```bash
# Remove containers, networks, and volumes (DELETES .onion ADDRESS)
docker-compose down -v
```

⚠️ This **deletes** the `tor-data` volume, so you'll get a new .onion address next time.

### Complete Cleanup

```bash
cd ..
rm -rf ~/apache-tor
```

---

## 📊 Useful Docker Commands

| Command | Purpose |
|---------|---------|
| `docker-compose up -d` | Start containers in background |
| `docker-compose down` | Stop containers |
| `docker-compose down -v` | Stop and remove volumes |
| `docker-compose logs tor` | View Tor logs |
| `docker-compose logs -f` | Follow logs in real-time |
| `docker-compose ps` | List running containers |
| `docker-compose restart tor` | Restart just Tor |
| `docker-compose up -d --build` | Rebuild and start |
| `docker exec tor-hidden-service bash` | Shell into Tor container |
| `docker exec apache-server bash` | Shell into Apache container |

---

## 🐛 Troubleshooting

### Tor Won't Start

**Symptom:** `docker-compose logs tor` shows errors

**Solutions:**
```bash
# Check if ports are in use
sudo lsof -i :9051

# Check torrc syntax
docker exec tor-hidden-service tor --verify-config

# Check permissions on volume
ls -la tor-data/

# Rebuild from scratch
docker-compose down -v
docker-compose up -d
```

### Apache Returns 404

**Symptom:** "Not Found" error when accessing

**Solutions:**
```bash
# Verify files exist in container
docker exec apache-server ls /usr/local/apache2/htdocs/

# Check Apache error log
docker-compose logs apache

# Verify index.html is there
docker exec apache-server cat /usr/local/apache2/htdocs/index.html
```

### Can't Access .onion Address

**Symptoms:** Connection timeout or refused

**Troubleshooting:**
```bash
# 1. Wait 30-60 seconds for Tor to bootstrap
sleep 60

# 2. Verify hostname file exists
docker exec tor-hidden-service ls -la /var/lib/tor/hidden_service/

# 3. Check Apache is running
docker exec apache-server curl http://localhost:80/

# 4. View Tor logs for errors
docker-compose logs tor | tail -50

# 5. Verify network connectivity
docker exec tor ping apache  # Should respond
```

### Port Already in Use

**Error:** `Address already in use`

**Solution:**
```bash
# Find what's using port 8080
sudo lsof -i :8080

# Kill the process
kill -9 <PID>

# Or change to different port in docker-compose.yml
ports:
  - "9090:80"  # Use 9090 instead
```

### Hidden Service Dir Permissions

**Error:** Permission denied on /var/lib/tor

**Solution:**
```bash
# Fix permissions
sudo chown -R 999:999 tor-data/
sudo chmod -R 700 tor-data/

# Or let Docker manage it (remove bind mount)
```

---

## 🔐 Security Best Practices

### ✅ DO

- ✅ Use Docker networks (isolated, not host network)
- ✅ Keep `tor-data` volume secure and backed up
- ✅ Use `restart: unless-stopped` for reliability
- ✅ Run health checks on Apache
- ✅ Update Docker and Tor regularly
- ✅ Enable CookieAuthentication on control port
- ✅ Use HiddenServiceVersion 3 (not deprecated v2)
- ✅ Keep .onion address private if you want anonymity
- ✅ Use HTTPS if serving sensitive data
- ✅ Monitor logs for suspicious activity

### ❌ DON'T

- ❌ Map Tor ports to public IP
- ❌ Use host networking (breaks isolation)
- ❌ Share your .onion address widely if you want anonymity
- ❌ Host illegal content
- ❌ Run untrusted code in containers
- ❌ Ignore security updates
- ❌ Use weak passwords in torrc
- ❌ Mix Tor and non-Tor services carelessly
- ❌ Assume anonymity = impunity
- ❌ Leave tor-data unprotected

### Important Reminders

- **Tor is not perfect** — Advanced adversaries may be able to deanonymize you
- **This is not legal advice** — Check your local laws
- **Content is still your responsibility** — Anonymity doesn't shield from law
- **Logging matters** — Remove docker logs if privacy is critical
- **Multiple access methods** — Logging into your hidden service and clearnet simultaneously can deanonymize you

---

## References

- [Tor Project Documentation](https://www.torproject.org/docs/) — Official Tor guide
- [Tor Manual](https://2019.www.torproject.org/docs/tor-manual.html.en) — Detailed configuration reference
- [Apache Docker Image](https://hub.docker.com/_/httpd) — Official Apache container
- [Tor Docker Image](https://hub.docker.com/r/torproject/tor) — Official Tor container
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/) — Full compose syntax
- [Tor Hidden Service Protocol](https://www.torproject.org/docs/onion-services/) — How .onion works
- [EFF Security Self Defense](https://ssd.eff.org/) — Privacy and security guides
