# Apache + Tor Hidden Service with Docker

A complete guide to running an Apache web server as a Tor hidden service (.onion domain) using Docker. This setup allows you to host a website accessible only via Tor, with easy cleanup once you're done.

---

## Prerequisites

- Docker installed
- Docker Compose installed
- [Tor Browser](https://www.torproject.org/download/) (for testing)

---

## Setup Instructions

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

### Step 3: Create index.html

```bash
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Onion Server</title></head>
<body>
<h1>Hello from .onion!</h1>
<p>This is hosted via Tor hidden service</p>
</body>
</html>
EOF
```

### Step 4: Create Torrc Configuration

The `torrc` file configures Tor's hidden service:

```bash
cat > torrc << 'EOF'
SocksPort 0
ControlPort 9051
CookieAuthentication 1
HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort 80 apache:80
Log notice file /var/log/tor/notices.log
EOF
```

**Config Explanation:**
- `SocksPort 0` — Disable SOCKS proxy (not needed)
- `HiddenServiceDir` — Where Tor stores the hidden service keys
- `HiddenServicePort 80 apache:80` — Expose port 80 (HTTP) to Apache container
- `Log notice file` — Log output to file

### Step 5: Create docker-compose.yml

```bash
cat > docker-compose.yml << 'EOF'
version: '3'
services:
  apache:
    build: .
    container_name: apache-server
    ports:
      - "8080:80"
    networks:
      - tornet

  tor:
    image: torproject/tor:latest
    container_name: tor-hidden-service
    volumes:
      - ./torrc:/etc/tor/torrc
      - tor-data:/var/lib/tor
    networks:
      - tornet
    depends_on:
      - apache

networks:
  tornet:

volumes:
  tor-data:
EOF
```

**Configuration Details:**
- `apache` service: Builds from local Dockerfile, maps port 8080 locally
- `tor` service: Uses official Tor image, mounts torrc config and persistent volume
- `tornet`: Private network for container communication
- `tor-data`: Named volume to persist Tor keys (essential for stable .onion address)

---

## Starting the Services

```bash
docker-compose up -d
```

**Output:**
```
Creating network "apache-tor_tornet" with driver "bridge"
Creating volume "apache-tor_tor-data" with default driver
Building apache
...
Creating apache-server
Creating tor-hidden-service
```

---

## Get Your .onion Address

```bash
docker exec tor-hidden-service cat /var/lib/tor/hidden_service/hostname
```

Output example:
```
abcd1234efgh5678ijkl9999nnnn5555.onion
```

⚠️ **Keep this address private!** It's your hidden service's unique identifier.

---

## Accessing Your Server

### Option 1: Via Tor Browser (Recommended)

1. Download [Tor Browser](https://www.torproject.org/download/)
2. Open Tor Browser
3. Navigate to: `http://YOUR_ONION_ADDRESS.onion`

### Option 2: Via Torsocks (Command Line)

```bash
torsocks curl http://YOUR_ONION_ADDRESS.onion
```

Requires `torsocks` package:
```bash
# Arch
sudo pacman -S torsocks

# Ubuntu/Debian
sudo apt install torsocks

# Fedora
sudo dnf install torsocks
```

### Option 3: Local HTTP Access (No Tor)

Test locally without Tor:
```bash
curl http://localhost:8080
```

Or open browser to `http://localhost:8080`

---

## Customization

### Mount Custom Apache Configuration

Create your own `httpd.conf` and update `docker-compose.yml`:

```yaml
apache:
  volumes:
    - ./httpd.conf:/usr/local/apache2/conf/httpd.conf
```

Then restart:
```bash
docker-compose down && docker-compose up -d
```

### Add HTTPS to .onion

Update `torrc`:
```
HiddenServicePort 443 apache:443
```

### Custom Local Port

Map to a different port:
```yaml
apache:
  ports:
    - "3000:80"  # Access via http://localhost:3000
```

### Serve Multiple Sites

Update Dockerfile:
```dockerfile
FROM httpd:latest
COPY site1/ /usr/local/apache2/htdocs/site1/
COPY site2/ /usr/local/apache2/htdocs/site2/
```

Access via:
- `http://YOUR_ONION.onion/site1/`
- `http://YOUR_ONION.onion/site2/`

---

## Stopping & Cleanup

### Pause Services (Keep Data)

```bash
docker-compose down
```

Container data is preserved in the `tor-data` volume. Your .onion address remains stable.

### Stop & Remove Everything

```bash
docker-compose down -v  # -v removes volumes
```

⚠️ This deletes the `tor-data` volume, so you'll get a **new .onion address** next time.

### Complete Cleanup

```bash
cd ..
rm -rf ~/apache-tor
```

---

## Useful Commands

| Command | Purpose |
|---------|---------|
| `docker-compose logs tor` | View Tor container logs |
| `docker-compose logs apache` | View Apache container logs |
| `docker-compose logs -f` | Follow logs in real-time |
| `docker-compose ps` | List running containers |
| `docker exec apache-server ls /usr/local/apache2/htdocs/` | List Apache web root |
| `docker exec tor-hidden-service cat /var/lib/tor/hidden_service/hostname` | Get .onion address |
| `docker-compose restart tor` | Restart Tor container |
| `docker-compose up -d --build` | Rebuild and restart |

---

## Troubleshooting

### Port Already in Use

```bash
# Find what's using port 8080
sudo lsof -i :8080

# Kill the process
kill -9 <PID>
```

### Tor Won't Start

Check logs:
```bash
docker-compose logs tor
```

Common issues:
- Port 9051 already in use
- `/var/lib/tor` permissions issue
- Invalid torrc syntax

### Apache Returns 404

Verify files exist in container:
```bash
docker exec apache-server ls /usr/local/apache2/htdocs/
```

### Can't Access .onion Address

1. **Wait 30-60 seconds** after startup — Tor needs time to bootstrap and generate keys
2. **Verify Tor Browser is connected** — Check connection status
3. **Check hostname exists:**
   ```bash
   docker exec tor-hidden-service cat /var/lib/tor/hidden_service/hostname
   ```
4. **View Tor logs:**
   ```bash
   docker-compose logs tor | tail -20
   ```

### Connection Refused Locally

```bash
# Verify Apache is running
docker ps | grep apache

# Test on localhost
curl -v http://localhost:8080
```

---

## Security Considerations

### ✅ Good Practices

- Use the `tornet` bridge network (not host network)
- Don't map Tor ports to localhost (keep internal)
- Use `tor-data` volume for persistent, secure keys
- Enable `CookieAuthentication` in torrc
- Run containers with minimal privileges
- Use `.onion` addresses only when appropriate

### ⚠️ Important Notes

- **Your .onion address is unique and semi-permanent** — the same address persists as long as `tor-data` volume exists
- **Tor hidden services are designed for anonymity**, but content visibility depends on who knows the address
- **Don't confuse anonymity with privacy** — your hosting provider can see traffic
- **Content indexed nowhere** — .onion sites don't appear in search engines
- **Keep the address private** if you want genuine anonymity

---

## Advanced: Persistent .onion Address

By default, the `tor-data` volume is managed by Docker. To use a specific directory:

```yaml
volumes:
  tor-data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/user/my-tor-data
```

Or bind-mount directly:
```yaml
tor:
  volumes:
    - ./my-tor-data:/var/lib/tor
```

This lets you backup and restore your exact .onion address.

---

## References

- [Tor Project Documentation](https://www.torproject.org/docs/)
- [Apache Docker Image](https://hub.docker.com/_/httpd)
- [Tor Docker Image](https://hub.docker.com/r/torproject/tor)
- [Tor Manual](https://2019.www.torproject.org/docs/tor-manual.html.en)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
