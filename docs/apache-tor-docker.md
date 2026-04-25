# How to Set Up a Hidden Website with Docker and Tor

So you want to host a website that only works on Tor Browser and nobody can trace back to you. This guide walks you through it. I'm going to assume you've never done this before, so we'll go step by step.

---

## What You're Actually Doing

Three things are happening here:

1. Docker creates isolated containers on your computer. Think of it like running separate mini-computers inside your main computer. If someone breaks into one, they can't mess with the others.

2. Tor is software that hides your location by routing traffic through multiple computers around the world. When someone visits your site, their connection bounces around and they never see your real IP.

3. Apache is a web server. It's what actually shows people your website files.

So basically: your visitor connects through Tor, reaches your Tor container, which talks to your Apache container, which serves your HTML files.

---

## What You Need

- Linux (any distro: Ubuntu, Debian, Arch, Fedora, whatever)
- A terminal (you'll be typing commands)
- About an hour
- 2GB of free disk space

If you don't have Linux, this won't work. But if you're reading this, you probably already know that.

---

## Installing Docker

First we need Docker. The commands are different depending on which Linux distro you're using.

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

Go to docker.com and follow their installation guide.

After installing, let Docker run without sudo:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Test it works:

```bash
docker run hello-world
```

If you see a message saying hello, you're good.

---

## Set Up Your Project

Create a folder for everything and make the subdirectories:

```bash
mkdir -p ~/my-onion-site
cd ~/my-onion-site
mkdir -p tor/keys apache/html apache/config logs
```

Now you have a structure like this:

```
my-onion-site/
├── tor/
│   └── keys/          (your .onion address will be here)
├── apache/
│   ├── html/          (your website files)
│   └── config/        (Apache settings)
└── logs/              (where errors get written)
```

---

## Create Your Website

Open a text editor and create your first HTML file:

```bash
nano apache/html/index.html
```

Paste this in:

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

Save it: Ctrl+X, then Y, then Enter.

---

## Create Apache Settings

Create another file for Apache configuration:

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

These are just safety rules. Save it the same way.

---

## Create the Dockerfile

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

## Create Tor Configuration

Tor needs its own config file:

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

Save it. The key lines are:
- HiddenServicePort tells Tor to listen on port 80 and forward to your Apache container
- HiddenServiceVersion 3 means use the newer, more secure Tor addresses

---

## Create docker-compose.yml

This is the file that orchestrates everything. It tells Docker to run both Tor and Apache and connect them:

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

Save it. That's all the files.

---

## Start Everything

Make sure you're in your project folder:

```bash
cd ~/my-onion-site
```

Start both containers:

```bash
docker-compose up -d
```

The -d means run in the background.

Watch Tor start up:

```bash
docker-compose logs -f tor
```

Wait until you see "Bootstrapped 100%". This takes 30-60 seconds. When you see it, press Ctrl+C to stop watching.

---

## Get Your .onion Address

When Tor starts for the first time, it generates your .onion address and saves it:

```bash
cat tor/keys/hostname
```

You'll see something like:

```
thisisyouronionaddressv3example7xq4fx2zfuzed5oxc.onion
```

Save this. This is your website's URL. Don't lose it.

---

## Access Your Site

Download Tor Browser from torproject.org if you don't have it already.

Open Tor Browser and wait for it to connect (takes a minute or two).

In the address bar, paste your .onion address:

```
http://thisisyouronionaddressv3example7xq4fx2zfuzed5oxc.onion/
```

You should see your website. Your location is hidden. You're totally anonymous. That's it.

---

## Common Problems

### Can't connect to my .onion address

First, wait 60 seconds. Tor takes time.

Check if Tor is bootstrapped:

```bash
docker-compose logs tor | grep "Bootstrapped"
```

If it says 100%, then Tor is ready.

Check if Apache is running:

```bash
docker-compose logs apache
```

If there are errors, restart:

```bash
docker-compose down
docker-compose up -d
```

### 504 Bad Gateway

Tor can't reach Apache. Try restarting:

```bash
docker-compose restart
```

### I want to update my website

Just edit your HTML file:

```bash
nano apache/html/index.html
```

Save it. It updates automatically. You don't need to restart anything.

### I want to stop my site but keep the .onion address

```bash
docker-compose down
```

The .onion address stays the same.

### I want to completely start over and get a new .onion address

```bash
docker-compose down -v
```

Only do this if you actually want a new address. You can't get the old one back.

---

## Basic Commands You'll Use

Start your site:
```bash
docker-compose up -d
```

Stop your site (keeps your .onion address):
```bash
docker-compose down
```

See what's happening:
```bash
docker-compose logs -f
```

Check if everything is running:
```bash
docker-compose ps
```

Get your .onion address:
```bash
cat tor/keys/hostname
```

---

## Keep It Safe

Don't upload photos that have GPS data in them. Strip the metadata first:

```bash
# Install exiftool
sudo apt install exiftool          # Debian/Ubuntu
sudo pacman -S perl-image-exiftool  # Arch

# Strip all metadata from a photo
exiftool -all= your-photo.jpg
```

Don't link to your real website or real email address.

Don't use PHP, Python, or Node.js unless you really have to. Just HTML and CSS. The simpler, the safer.

Keep your .onion private key safe. It's in tor/keys/hs_ed25519_secret_key. If you lose it, you lose your address forever. Maybe copy it somewhere safe:

```bash
cp tor/keys/hs_ed25519_secret_key ~/backup-key.txt
```

Store it somewhere offline.

---

## Adding More Pages

Create another HTML file:

```bash
nano apache/html/about.html
```

Paste this:

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

Link to it from your index.html:

```html
<a href="about.html">About</a>
```

---

## Check Your Visitor Stats

See who's visiting (without storing their IP):

```bash
tail -f logs/apache/access_log
```

Press Ctrl+C to stop.

---

## What's Actually Happening

When someone visits:

1. They open Tor Browser
2. They type your .onion address
3. Tor bounces their connection through 3 random computers around the world
4. Their traffic arrives at your Tor container
5. Your Tor container talks to your Apache container
6. Apache sends your website files
7. They see it
8. Nobody can trace it back to you

---

## Distro Notes

Most of the guide is the same on any distro. The only thing that changes is the package manager:

Ubuntu/Debian: apt or apt-get
Arch: pacman
Fedora/CentOS: dnf or yum
Others: usually apt or dnf, check their docs

If a command doesn't work on your distro, Google the error. You'll find an answer.

---

## Need Help

If something breaks:

1. Read the error message carefully
2. Google the error
3. Check docker-compose logs -f to see what's actually happening
4. Restart everything
5. Wait 60 seconds before trying again

If it's really broken, start over. The nice thing about Docker is you can just delete everything and try again. Your .onion address is saved in tor/keys/, so if you keep that folder, you keep your address.

---

## One More Thing

The first time you do this, it takes about an hour. The second time, 20 minutes. By the third time, 5 minutes. It gets easier.

The website is now live and completely anonymous. Be safe and be smart about what you put on it.
