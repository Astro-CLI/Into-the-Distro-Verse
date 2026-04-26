# Running a Tor Hidden Service on Arch Linux with Nginx

So you want to host a website as a Tor hidden service directly on Arch Linux without Docker. This guide walks through exactly what we did to make it work.

---

## What This Does

You'll have:
- A website running on Nginx (native Arch package)
- A .onion address that only works with Tor Browser
- Complete anonymity - nobody can see your real IP
- No Docker involved - just Arch Linux packages

This is simpler than Docker but less isolated. If Nginx gets compromised, someone could potentially access your system. For most use cases though, this is fine.

---

## Before You Start

You need:
- Arch Linux (with pacman)
- Terminal access
- Root/sudo privileges
- Website files (we'll use a local GitHub repo as an example)
- About 15 minutes

---

## Step 1: Update Your System

First update everything:

```bash
sudo pacman -Syu
```

Wait for it to finish.

---

## Step 2: Install Required Packages

Install Tor, Nginx, and curl:

```bash
sudo pacman -S tor nginx curl
```

Press Y when it asks to confirm.

---

## Step 3: Prepare Your Website Files

Create the web root directory:

```bash
sudo mkdir -p /srv/http
```

Copy your website files. If you're using a GitHub repo:

```bash
sudo cp -r /home/astro/Documents/GitHub/Into-the-Distro-Verse/website/* /srv/http/
```

Or if you have HTML files elsewhere, copy those instead.

Set correct permissions:

```bash
sudo chown -R http:http /srv/http
sudo chmod -R 755 /srv/http
```

---

## Step 4: Configure Nginx

Open the Nginx config:

```bash
sudo nano /etc/nginx/nginx.conf
```

Look for the `http {` block. Inside it, find the `server {` block (or create one if it doesn't exist). Replace or update it to look like this:

```nginx
http {
    include mime.types;
    default_type application/octet-stream;

    sendfile on;
    keepalive_timeout 65;
    gzip on;

    server {
        listen 80 default_server;
        listen [::]:80 default_server;
        
        server_name _;
        
        root /srv/http;
        index index.html;
        
        location / {
            try_files $uri $uri/ =404;
        }
    }
}
```

The key parts:
- `listen 80` - listens on port 80
- `root /srv/http` - serves files from here
- `include mime.types` - makes CSS and JS load properly

Save it: Ctrl+X, Y, Enter.

Start Nginx:

```bash
sudo systemctl enable --now nginx
```

Test it works:

```bash
curl -I http://localhost/
```

You should see: `HTTP/1.1 200 OK`

If you get an error about port 80 already in use, check if Docker is running:

```bash
docker ps
```

If containers are running:

```bash
docker-compose down
```

Then try Nginx again.

---

## Step 5: Configure Tor

Open the Tor config:

```bash
sudo nano /etc/tor/torrc
```

Scroll down and find the section with comments about hidden services. Look for lines that might say `# HiddenServiceDir` or similar.

Add these lines (order matters - HiddenServiceDir must come before HiddenServicePort):

```conf
HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort 80 127.0.0.1:80
```

Just paste them in. They can go anywhere after the main config but before the end of the file.

Save it: Ctrl+X, Y, Enter.

Restart Tor:

```bash
sudo systemctl restart tor
```

---

## Step 6: Get Your .onion Address

Wait 3-5 seconds for Tor to start up, then:

```bash
sudo cat /var/lib/tor/hidden_service/hostname
```

You'll see something like:

```
cgo7r2ivdj7rbg2gqc5hn2d7pdnp2yhsjtywage5dvsitjxwb7eiakyd.onion
```

Save this. This is your website's address.

---

## Step 7: Test It Works Locally

Make sure everything is responding:

```bash
curl -I http://localhost/
```

Should show `200 OK`.

Check Tor is running:

```bash
sudo systemctl status tor
```

Should say "active (running)".

Check Nginx:

```bash
sudo systemctl status nginx
```

Should also say "active (running)".

---

## Step 8: Access in Tor Browser

Download Tor Browser from torproject.org if you don't have it.

Open Tor Browser and wait for it to connect (takes a minute).

In the address bar, paste your .onion address:

```
http://cgo7r2ivdj7rbg2gqc5hn2d7pdnp2yhsjtywage5dvsitjxwb7eiakyd.onion
```

You should see your website.

---

## Step 9: Create a Short URL (Optional)

You can create a short link that redirects to your .onion address. This makes it easier to share.

Using is.gd:

```bash
curl -s --data-urlencode "url=http://cgo7r2ivdj7rbg2gqc5hn2d7pdnp2yhsjtywage5dvsitjxwb7eiakyd.onion" "https://is.gd/create.php?format=simple" | tr -d '\n' && echo
```

Replace the .onion address with yours.

You'll get something like:

```
https://is.gd/EkazLS
```

Anyone can click this link (in Tor Browser) and it redirects to your hidden site.

---

## CSS and JavaScript Not Loading?

If your website displays but styling is broken, check Tor Browser's security level.

Click the shield icon in the top right.

Make sure it's set to "Standard" (not "Safest").

"Safest" blocks scripts and makes websites look broken. "Standard" is fine for most sites.

---

## Common Issues

### Nginx shows "Connection refused"

Nginx might not have started. Try:

```bash
sudo systemctl start nginx
```

If it fails, check the error:

```bash
sudo nginx -t
```

This will show what's wrong with the config.

### Tor shows error about port

Make sure port 80 is free:

```bash
sudo lsof -i :80
```

If something else is using it, kill it or change the port in Nginx config.

### Can't connect to .onion address from Tor Browser

Wait 30 seconds. Tor needs time to build circuits.

Check Tor logs:

```bash
sudo tail -f /var/log/tor/log
```

Look for "Bootstrapped 100%". When you see it, your hidden service is ready.

### The page loads but looks broken

Make sure Tor Browser security is on "Standard" (not "Safest").

Check that files were copied:

```bash
ls -la /srv/http/
```

Should show your HTML, CSS, JS files.

### Port already in use

If you see "Address already in use", something else is running on port 80.

Check what:

```bash
sudo lsof -i :80
```

Stop it or reconfigure Nginx to use a different port (8080 instead of 80).

---

## Common Commands

Start your hidden service:

```bash
sudo systemctl start tor
sudo systemctl start nginx
```

Stop it:

```bash
sudo systemctl stop tor
sudo systemctl stop nginx
```

Restart it:

```bash
sudo systemctl restart tor
sudo systemctl restart nginx
```

See logs:

```bash
sudo journalctl -u tor -f
sudo journalctl -u nginx -f
```

Get your .onion address again:

```bash
sudo cat /var/lib/tor/hidden_service/hostname
```

---

## Keeping Your Site Safe

Don't upload files with metadata (like photos with location data):

```bash
sudo pacman -S exiftool
exiftool -all= your-photo.jpg
```

Don't link to your real website or real email.

Don't use fancy JavaScript - keep it simple.

Backup your private key so you keep the same .onion address forever:

```bash
sudo cp /var/lib/tor/hidden_service/hs_ed25519_secret_key ~/backup-onion-key.txt
```

Keep this file safe. If you lose it, you lose that .onion address forever.

---

## Updating Your Website

Edit files directly in /srv/http:

```bash
sudo nano /srv/http/index.html
```

Changes are live immediately. No restart needed.

If you're copying files from GitHub:

```bash
sudo cp -r /path/to/repo/website/* /srv/http/
sudo chown -R http:http /srv/http
```

Then refresh in Tor Browser.

---

## Adding More Pages

Create a new HTML file:

```bash
sudo nano /srv/http/about.html
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
    <p>This is my hidden website.</p>
    <a href="index.html">Back home</a>
</body>
</html>
```

Save it. Link to it from index.html:

```html
<a href="about.html">About</a>
```

---

## Difference from Docker Version

Docker version (apache-tor-docker.md):
- More isolated (if Nginx breaks, system is safer)
- More setup steps
- Better for production

Native version (this guide):
- Simpler, faster
- Fewer moving parts
- Better for learning
- Slightly less isolated (Nginx has more access to system)

For a personal site or learning, native is fine. For something critical, use Docker.

---

## Key Files and Locations

- Nginx config: `/etc/nginx/nginx.conf`
- Website files: `/srv/http/`
- Tor config: `/etc/tor/torrc`
- Tor hidden service: `/var/lib/tor/hidden_service/`
- Tor logs: `/var/log/tor/log`
- Private key (backup this): `/var/lib/tor/hidden_service/hs_ed25519_secret_key`

---

## What's Actually Happening

1. Someone opens Tor Browser
2. They type your .onion address
3. Tor connects through multiple relays
4. Connection reaches your computer's Tor daemon
5. Your Tor daemon forwards to localhost:80
6. Nginx listens on localhost:80
7. Nginx serves your files
8. Your visitor sees the website
9. Their connection is completely anonymous

Nobody can see your real IP. Nobody can trace it back to you.

---

## Still Having Problems?

Check all three things are running:

```bash
sudo systemctl status tor
sudo systemctl status nginx
curl -I http://localhost/
```

All should show OK.

Check Nginx config has no errors:

```bash
sudo nginx -t
```

Check Tor logs:

```bash
sudo tail -20 /var/log/tor/log
```

Look for errors.

Check permissions on files:

```bash
ls -la /srv/http/
```

Should show `http http` as owner (not root).

If Tor says "Already in use", the service might already be running:

```bash
sudo systemctl is-active tor
```

If yes, restart it:

```bash
sudo systemctl restart tor
```

---

## One More Thing

The first time is confusing. The second time is straightforward. By the third time, you can do it in 5 minutes.

You now have a completely anonymous website that only Tor users can access. Your location is hidden. Your identity is hidden.

Be smart about what you host on it.
