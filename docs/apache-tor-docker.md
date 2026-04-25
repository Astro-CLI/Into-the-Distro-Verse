# Running a Secret Website with Docker & Tor: A Beginner's Guide

Hey! So you want to create a website that only people with Tor Browser can access? A site that's completely hidden and anonymous? This guide will walk you through it step by step. Don't worry if you don't know what Docker or Tor is yet – we'll explain everything in simple terms!

---

## 📑 Quick Navigation

- [What is This?](#what-is-this)
- [Before You Start](#before-you-start)
- [Installing Docker](#installing-docker)
- [Setting Everything Up](#setting-everything-up)
- [Creating Your Website](#creating-your-website)
- [Starting Your Hidden Service](#starting-your-hidden-service)
- [Common Problems & Fixes](#common-problems--fixes)

---

## What is This?

Imagine you want a website that:
- **Only works on Tor Browser** (so it's private)
- **Nobody can see your real location** (totally anonymous)
- **Gets a weird address** like `thisisyourwebsiteaddress7xq4fx2zfuzed5oxc.onion`

That's what we're building today! Here's how it works:

1. **Docker** = Think of it like a box on your computer. Inside that box, you run a web server and Tor separately. If someone breaks into the web server, they can't escape the box and mess with your computer.

2. **Tor** = This software hides who you are by bouncing your connection around the world multiple times before reaching the website.

3. **Apache** = This is the actual web server that serves your website (what shows the HTML files).

So the flow looks like:
```
Your visitor (using Tor Browser)
     → connects to Tor
     → gets bounced around the internet
     → finds your .onion address
     → Docker's Tor container accepts the connection
     → Docker's Apache container shows your website
```

---

## Before You Start

You'll need:
- A computer running Linux (any distro - Arch, Ubuntu, Fedora, Debian, etc.)
- About 1 hour and coffee ☕
- Ability to type commands in the terminal
- At least 2GB of free disk space

**Note:** This guide works on ANY Linux distro. If a command doesn't work, let me know which one you're using!

---

## Installing Docker

Docker is the magic tool that creates isolated environments for your services.

### Step 1: Install Docker

**On Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install docker.io docker-compose
```

**On Arch:**
```bash
sudo pacman -S docker docker-compose
```

**On Fedora:**
```bash
sudo dnf install docker docker-compose
```

**On any other distro**, visit [docker.com/get-started](https://docker.com/get-started) and follow their guide.

### Step 2: Start Docker

Docker is like an app - you need to turn it on:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

This tells Docker to automatically start when your computer boots up.

### Step 3: Let Your User Run Docker

By default, you need `sudo` to use Docker. Let's fix that:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Now close your terminal and open a new one. Test it works:

```bash
docker run hello-world
```

If you see "Hello from Docker!" you're good to go! 🎉

---

## Setting Everything Up

Now let's create folders and files for your hidden website.

### Step 1: Make a Folder for Your Project

```bash
mkdir -p ~/my-onion-site
cd ~/my-onion-site
```

This creates a folder called `my-onion-site` in your home directory and puts you inside it.

### Step 2: Create the Folder Structure

```bash
mkdir -p tor/keys
mkdir -p apache/html
mkdir -p apache/config
mkdir -p logs
```

Now your folder looks like this:
```
my-onion-site/
├── tor/
│   └── keys/          (this is where your .onion address will be saved!)
├── apache/
│   ├── html/          (your website files go here)
│   └── config/        (settings for Apache)
└── logs/              (where errors get written)
```

---

## Creating Your Website

### Step 1: Create the Main Website File

Create a file called `index.html` in the `apache/html/` folder. Open your text editor:

```bash
nano apache/html/index.html
```

Then copy and paste this:

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Secret Website</title>
    <style>
        body {
            background-color: #000;
            color: #00ff00;
            font-family: monospace;
            padding: 20px;
        }
        h1 {
            text-align: center;
        }
    </style>
</head>
<body>
    <h1>🧅 Welcome to My Hidden Website!</h1>
    <p>If you can see this, you're using Tor Browser.</p>
    <p>Your real location is hidden.</p>
    <p>You are totally anonymous right now.</p>
</body>
</html>
```

Save it by pressing `Ctrl + X`, then `Y`, then `Enter`.

### Step 2: Create Apache's Settings File

Apache needs some safety rules. Open your editor:

```bash
nano apache/config/custom.conf
```

Copy and paste this:

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

Save it (Ctrl + X, Y, Enter).

### Step 3: Create the Dockerfile

This tells Docker how to create the Apache container. Open your editor:

```bash
nano Dockerfile
```

Copy and paste this:

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

### Step 4: Create the Tor Settings File

Tor needs configuration. Open your editor:

```bash
nano tor/torrc
```

Copy and paste this:

```conf
SocksPort 0
ControlPort 9051
CookieAuthentication 1

HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort 80 apache:80
HiddenServiceVersion 3

Log notice file /var/log/tor/notices.log
```

Save it.

### Step 5: Create the docker-compose.yml File

This is the master file that brings it all together:

```bash
nano docker-compose.yml
```

Copy and paste this:

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

Save it. Done with file creation!

---

## Starting Your Hidden Service

Make sure you're in your project folder:

```bash
cd ~/my-onion-site
```

### Step 1: Build and Start Everything

```bash
docker-compose up -d
```

This starts both the Tor container and Apache container in the background.

### Step 2: Watch Tor Start

```bash
docker-compose logs -f tor
```

Wait until you see "Bootstrapped 100%" - this usually takes 30-60 seconds.

Press `Ctrl + C` to stop watching.

### Step 3: Get Your .onion Address

```bash
cat tor/keys/hostname
```

You'll see something like:
```
thisisyouronionaddressv3example7xq4fx2zfuzed5oxc.onion
```

**Save this! This is your website's address.**

---

## Access Your Website

### Step 1: Download Tor Browser

Visit [torproject.org/download](https://www.torproject.org/download) and download Tor Browser.

### Step 2: Run Tor Browser

Extract it and run it. Wait 1-2 minutes for it to connect to Tor.

### Step 3: Visit Your Site

In the address bar, paste your .onion address:
```
http://thisisyouronionaddressv3example7xq4fx2zfuzed5oxc.onion/
```

**You should see your website!** 🎉

---

## Common Problems & Fixes

### "Can't connect to my .onion address"

First, wait 60 seconds. Tor takes time to build circuits.

Check if Tor is ready:
```bash
docker-compose logs tor | grep "Bootstrapped"
```

If you see "Bootstrapped 100%", it's ready.

Check if Apache is working:
```bash
docker-compose logs apache
```

If there are errors, restart everything:
```bash
docker-compose down
docker-compose up -d
```

### "504 Bad Gateway"

Try this:
```bash
docker-compose exec tor ping apache
```

If that fails, restart:
```bash
docker-compose restart
```

### "Port already in use"

Stop any other containers:
```bash
docker stop $(docker ps -q)
```

Then start again:
```bash
docker-compose up -d
```

### "Want to update my website"

Just edit your HTML file:
```bash
nano apache/html/index.html
```

Save and it updates automatically! You don't need to restart anything.

### "Want to start over"

To stop but keep your .onion address:
```bash
docker-compose down
```

To delete everything and start fresh (new .onion address):
```bash
docker-compose down -v
```

---

## Common Commands

```bash
# Start your site
docker-compose up -d

# Stop your site (keeps your .onion address)
docker-compose down

# View what's happening
docker-compose logs -f

# Check if everything is running
docker-compose ps

# Get your .onion address
cat tor/keys/hostname

# Check Tor is bootstrapped
docker-compose logs tor | grep "Bootstrapped"

# Stop watching logs
Ctrl + C

# Edit your website
nano apache/html/index.html
```

---

## Keep Your Website Safe

### 1. Don't Upload Photos with Location Data

Photos sometimes have GPS coordinates hidden inside them! Before uploading, strip them:

```bash
# Install exiftool first:
# Ubuntu/Debian:
sudo apt install exiftool

# Arch:
sudo pacman -S perl-image-exiftool

# Then use it:
exiftool -all= your-photo.jpg
```

### 2. Keep URLs Simple

Don't link to your real website or real email address.

### 3. Keep Your Website Simple

- Use only HTML (no PHP, Python, or Node.js)
- No database needed
- No user logins
- Simple = safe

### 4. Backup Your .onion Address

The file `tor/keys/hs_ed25519_secret_key` is your secret key. Never lose it!

```bash
# Make a backup
cp tor/keys/hs_ed25519_secret_key ~/my-backup-key.txt

# Store it somewhere safe!
```

---

## Add More Pages to Your Website

You can add as many pages as you want. Just create new HTML files:

```bash
nano apache/html/about.html
```

Paste this:

```html
<!DOCTYPE html>
<html>
<head>
    <title>About Me</title>
</head>
<body>
    <h1>About This Site</h1>
    <p>This is my secret website!</p>
    <a href="index.html">Go back home</a>
</body>
</html>
```

Then link to it from your index.html by adding:
```html
<a href="about.html">Read about me</a>
```

---

## Check Your Visitor Stats

See who's visiting your site (without storing their IP address):

```bash
tail -f logs/apache/access_log
```

Press `Ctrl + C` to stop watching.

---

## Stop Your Website Temporarily

```bash
docker-compose stop
```

### Start It Again

```bash
docker-compose start
```

---

## What Happens When Someone Visits?

1. They open Tor Browser
2. They type your .onion address
3. Tor bounces their connection through 3 random computers around the world
4. Connection arrives at your Tor container (their location is hidden)
5. Tor talks to Apache
6. Apache sends your website
7. They see it!
8. Nobody can trace it back to you! 🎉

---

## Questions?

- Docker help: [docker.com/docs](https://docker.com/docs)
- Tor questions: [torproject.org/docs](https://torproject.org/docs)
- Apache help: [httpd.apache.org/docs](https://httpd.apache.org/docs)

---

## Quick Summary

You now have:
✅ A hidden website  
✅ Total anonymity  
✅ A cool .onion address  
✅ A way to share information safely  

Have fun and be safe! 🚀

**Pro Tip:** The first time takes 1 hour. By the third time, you'll do it in 10 minutes!
