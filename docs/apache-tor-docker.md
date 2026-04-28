<!-- 
    WIKI GUIDE: apache-tor-docker.md
    This guide shows how to set up an anonymous website hosted on Tor 
    using Docker containers for maximum isolation and privacy.
    Adapt to your content and security requirements.
-->

# Hosting an Anonymous Website on Tor with Docker

Want a website that only works through Tor and can't be traced back to you? This guide walks you through setting it up using Docker—the containerized approach keeps everything isolated and easy to manage. We'll assume you're new to this, so we'll explain each step clearly.

---

## 🤔 Why Would I Do This?

- **Complete anonymity** - Your real IP address is completely hidden
- **Censorship resistance** - Your site can't be taken down by ISPs
- **Privacy protection** - Visitors can't be tracked
- **Freedom of speech** - Host controversial content safely
- **Testing** - Learn about privacy technologies

---

## 🧠 What's Actually Happening

Three main pieces work together here:

1. **Docker** creates isolated containers (think of them as mini-computers inside your computer)
2. **Tor** hides your location by routing traffic through multiple computers worldwide
3. **Apache** is the web server that actually serves your website files

So visitors connect through Tor → reach your Tor container → which talks to your Apache container → which sends them your website. Nobody sees your real IP.

---

## ✅ What You Need

- Linux (any distro: Ubuntu, Debian, Arch, Fedora)
- A terminal
- About an hour
- 2GB of free disk space

---

## 🚀 1. Install Docker

The installation varies by distro:

### Ubuntu or Debian

```bash
sudo apt update
sudo apt install docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
```

### Arch Linux

```bash
sudo pacman -S docker docker-compose
sudo systemctl start docker
sudo systemctl enable docker
```

### Fedora

```bash
sudo dnf install docker docker-compose
sudo systemctl start docker
sudo systemctl enable docker
```

### Other Distros

Visit docker.com for their installation guide.

After installing, let Docker run without sudo:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Test it works:

```bash
docker run hello-world
```

If you see a "hello" message, you're good!

---

## 🗂️ 2. Create Your Project Structure

Create a folder to organize everything:

```bash
mkdir -p ~/my-onion-site
cd ~/my-onion-site
mkdir -p tor/keys apache/html apache/config logs
```

Your folder now looks like:

```
my-onion-site/
├── tor/
│   └── keys/          (your .onion address will be here)
├── apache/
│   ├── html/          (your website files)
│   └── config/        (Apache settings)
└── logs/              (error logs)
```

---

## 📄 3. Create Your Website

Create a simple HTML file:

```bash
nano apache/html/index.html
```

Paste this:

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hidden Site</title>
    <style>
        body {
            background-color: #000;
            color: #0f0;
            font-family: monospace;
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
        }
        h1 {
            text-align: center;
        }
    </style>
</head>
<body>
    <h1>Welcome</h1>
    <p>If you can see this, you're using Tor Browser and your connection is completely hidden.</p>
    <p>Your real location is protected.</p>
</body>
</html>
```

Save with Ctrl+X, then Y, then Enter.

---

## 🔐 4. Create Apache Security Configuration

Create a config file with security rules:

```bash
nano apache/config/custom.conf
```

Paste this:

```apache
ServerTokens ProductOnly
ServerSignature Off

<DirectoryMatch "/\.">
    Require all denied
</DirectoryMatch>

Header set X-Content-Type-Options "nosniff"
Header set X-Frame-Options "DENY"
Header set Referrer-Policy "no-referrer"

<Directory /usr/local/apache2/htdocs>
    Options -Indexes
</Directory>
```

This is just security boilerplate. Save it.

---

## 🐳 5. Create the Dockerfile

This tells Docker how to build the Apache container:

```bash
nano Dockerfile
```

Paste this:

```dockerfile
FROM httpd:2.4-alpine

COPY apache/html/ /usr/local/apache2/htdocs/
COPY apache/config/custom.conf /usr/local/apache2/conf.d/

RUN sed -i 's/^#LoadModule headers_module/LoadModule headers_module/' \
    /usr/local/apache2/conf/httpd.conf && \
    sed -i 's/^#LoadModule rewrite_module/LoadModule rewrite_module/' \
    /usr/local/apache2/conf/httpd.conf

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

CMD ["httpd-foreground"]
```

Save it.

---

## ⚙️ 6. Configure Tor

Tor needs its config file:

```bash
nano tor/torrc
```

Paste this:

```conf
SocksPort 0
ControlPort 9051
CookieAuthentication 1

HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort 80 apache:80
HiddenServiceVersion 3

Log notice file /var/log/tor/notices.log
```

Key lines explained:
- `HiddenServicePort` tells Tor to listen on port 80 and forward to your Apache container
- `HiddenServiceVersion 3` uses modern, secure Tor addresses

---

## 🎯 7. Create docker-compose.yml

This file orchestrates both containers:

```bash
nano docker-compose.yml
```

Paste this:

```yaml
version: '3.8'

services:
  tor:
    image: goldy/tor-hidden-service:latest
    container_name: tor-gateway
    restart: always
    
    environment:
      - SERVICES=apache:80
    
    volumes:
      - ./tor/keys:/var/lib/tor/hidden_service/
      - ./tor/torrc:/etc/tor/torrc:ro
      - ./logs/tor:/var/log/tor:rw
    
    networks:
      - hidden_net
    
    depends_on:
      - apache

  apache:
    build: .
    container_name: apache-server
    restart: unless-stopped
    
    volumes:
      - ./logs/apache:/usr/local/apache2/logs:rw
    
    networks:
      - hidden_net
    
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 10s

networks:
  hidden_net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.18.0.0/16
```

Save it. That's all the files!

---

## ▶️ 8. Start Your Site

Make sure you're in the project folder:

```bash
cd ~/my-onion-site
```

Start both containers:

```bash
docker-compose up -d
```

The `-d` means run in the background.

Watch Tor start up:

```bash
docker-compose logs -f tor
```

Wait for "Bootstrapped 100%". This takes 30-60 seconds. When you see it, press Ctrl+C.

---

## 🧅 9. Get Your .onion Address

When Tor starts, it generates your unique .onion address:

```bash
cat tor/keys/hostname
```

You'll see something like:

```
thisisyouronionaddressv3example7xq4fx2zfuzed5oxc.onion
```

Save this! This is your website's URL. Don't lose it.

---

## 🌐 10. Access Your Site

Download Tor Browser from torproject.org if you don't have it.

Open Tor Browser and wait for it to connect (takes a minute or two).

In the address bar, paste your .onion address:

```
http://thisisyouronionaddressv3example7xq4fx2zfuzed5oxc.onion/
```

You should see your website. Your location is hidden. Perfect!

---

## 🐛 Troubleshooting

### Can't connect to the .onion address

First, wait 60 seconds—Tor needs time.

Check if Tor is ready:

```bash
docker-compose logs tor | grep "Bootstrapped"
```

If it says 100%, Tor is ready.

Check if Apache is running:

```bash
docker-compose logs apache
```

If there are errors, restart everything:

```bash
docker-compose down
docker-compose up -d
```

### 504 Bad Gateway

Tor can't reach Apache. Try restarting:

```bash
docker-compose restart
```

### Want to update your website

Just edit your HTML file:

```bash
nano apache/html/index.html
```

Save it. It updates automatically—no restart needed.

### Want to stop but keep your .onion address

```bash
docker-compose down
```

Your address stays the same.

### Want a brand new .onion address

```bash
docker-compose down -v
```

Only do this if you really want a new address. You can't get the old one back.

---

## 📋 Common Commands

```bash
# Start your site
docker-compose up -d

# Stop your site (keeps your address)
docker-compose down

# See what's happening
docker-compose logs -f

# Check if everything is running
docker-compose ps

# Get your .onion address
cat tor/keys/hostname
```

---

## 🔒 Security Tips

### Metadata is Dangerous

Don't upload photos with GPS data. Strip it first:

```bash
# Install exiftool
sudo apt install exiftool          # Debian/Ubuntu
sudo pacman -S perl-image-exiftool  # Arch

# Strip all metadata
exiftool -all= your-photo.jpg
```

### Other Safety Rules

- Don't link to your real website or real email
- Don't use PHP, Python, or Node.js unless necessary—just HTML and CSS. Simpler = safer.
- Keep your Tor private key safe (it's in `tor/keys/hs_ed25519_secret_key`)
- Back it up somewhere offline:

```bash
cp tor/keys/hs_ed25519_secret_key ~/backup-key.txt
```

---

## ➕ Adding More Pages

Create another HTML file:

```bash
nano apache/html/about.html
```

Paste:

```html
<!DOCTYPE html>
<html>
<head>
    <title>About</title>
</head>
<body>
    <h1>About This Site</h1>
    <p>This is my about page.</p>
    <a href="index.html">Back to home</a>
</body>
</html>
```

Link from your index:

```html
<a href="about.html">About</a>
```

---

## 📊 View Your Visitor Stats

See who's visiting (without storing their IP):

```bash
tail -f logs/apache/access_log
```

Press Ctrl+C to stop.

---

## 🎯 Why Would I Use This?

- **Publish anonymously** - No one knows who you are
- **Bypass censorship** - Tor can't be blocked by most governments
- **Privacy testing** - Learn how privacy actually works
- **Secret projects** - Host sensitive content safely
- **Whistleblowing** - Protect sources and journalists

---

## 🔗 Related Guides

- 📖 **[Tor Hidden Service (Native)](tor-hidden-service-arch.md)** - Running Tor without Docker
- 📖 **[Security Hardening](security.md)** - Complete security setup
- 📖 **[Arch Linux Guide](arch.md)** - System package management
