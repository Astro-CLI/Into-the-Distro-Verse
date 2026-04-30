<!-- 
    WIKI GUIDE: tor-hidden-service-arch.md
    Guide for hosting a Tor hidden service directly on Arch Linux using Nginx.
    No Docker required - native installation for maximum performance.
-->

### Hosting a Private Website on Tor: Native Arch Edition

Want to host a website that only works through Tor without using Docker? This native approach is simpler and faster. Your .onion address stays completely anonymous, and visitors can't see your real IP.

---

## 🤔 Why This Over Docker?

- **Simpler** - No Docker complexity, just Arch packages
- **Faster** - Direct native execution, no container overhead
- **Less isolated** - If that's what you prefer for simplicity

**Trade-off:** Less isolation than Docker, so security depends on Nginx hardening.

---

## ✅ What You Need

- Arch Linux
- Terminal access and sudo
- About 15 minutes
- Your website files (HTML/CSS)

---

## 🚀 1. Update Your System

```bash
sudo pacman -Syu
```

---

## 📦 2. Install Packages

```bash
sudo pacman -S tor nginx curl
```

Confirm with `Y`.

---

## 📁 3. Prepare Your Website

Create the web root:

```bash
sudo mkdir -p /srv/http
```

Copy your website files:

```bash
### From a local folder
sudo cp -r ~/my-website/* /srv/http/

### Or from GitHub
sudo cp -r /home/astro/Documents/GitHub/Into-the-Distro-Verse/website/* /srv/http/
```

Set correct ownership:

```bash
sudo chown -R http:http /srv/http
sudo chmod -R 755 /srv/http
```

---

## ⚙️ 4. Configure Nginx

Edit the Nginx config:

```bash
sudo nano /etc/nginx/nginx.conf
```

Find or create the `server {` block with these settings:

```nginx
http {
    # ... existing config ...
    
    server {
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name _;
        
        root /srv/http;
        index index.html;
        
        # Security headers
        add_header X-Content-Type-Options "nosniff";
        add_header X-Frame-Options "DENY";
        add_header Referrer-Policy "no-referrer";
        
        # Hide server version
        server_tokens off;
        
        # Deny access to dotfiles
        location ~ /\. {
            deny all;
        }
        
        # Serve files
        location / {
            try_files $uri $uri/ =404;
        }
    }
}
```

Save with Ctrl+X, Y, Enter.

---

## 🔧 5. Configure Tor

Edit the Tor config:

```bash
sudo nano /etc/tor/torrc
```

Find or add these lines:

```conf
HiddenServiceDir /var/lib/tor/hidden_service/
HiddenServicePort 80 127.0.0.1:80
HiddenServiceVersion 3
```

This tells Tor to:
- Store your .onion address in `/var/lib/tor/hidden_service/`
- Listen on port 80 and forward to localhost:80 (where Nginx runs)
- Use the modern v3 onion addresses

---

## ▶️ 6. Start Services

Enable and start Nginx:

```bash
sudo systemctl enable --now nginx
```

Enable and start Tor:

```bash
sudo systemctl enable --now tor
```

Check Tor is running:

```bash
sudo systemctl status tor
```

---

## 🧅 7. Get Your .onion Address

When Tor starts for the first time, it generates your unique address:

```bash
sudo cat /var/lib/tor/hidden_service/hostname
```

You'll see something like:

```
thisisyouronionaddressv3example7xq4fx2zfuzed5oxc.onion
```

Save this! This is your website's URL.

---

## 🌐 8. Access Your Site

1. Download Tor Browser from torproject.org
2. Open it and let it connect
3. In the address bar, paste your .onion address:
   ```
   http://thisisyouronionaddressv3example7xq4fx2zfuzed5oxc.onion/
   ```

You should see your website! Your location is completely hidden.

---

## 🛠️ Troubleshooting

### Can't access the .onion address

Wait 60 seconds - Tor takes time.

Check if Tor bootstrapped:

```bash
sudo journalctl -u tor -n 20 | grep -i "bootstrap"
```

Should say "Bootstrapped 100%".

### Page shows 404 or "Access Denied"

Check Nginx is running:

```bash
sudo systemctl status nginx
sudo curl http://localhost/
```

Check permissions:

```bash
sudo ls -la /srv/http/
```

Should show `http:http` ownership.

### Want to update your website

Just edit the HTML:

```bash
sudo nano /srv/http/index.html
```

Save it. It updates automatically—no restart needed!

### Want to stop hosting temporarily

```bash
sudo systemctl stop nginx
```

Your .onion address stays the same. Later:

```bash
sudo systemctl start nginx
```

### Want a brand new .onion address

```bash
sudo systemctl stop tor
sudo rm -rf /var/lib/tor/hidden_service/
sudo systemctl start tor
sleep 10
sudo cat /var/lib/tor/hidden_service/hostname
```

Warning: You can't get your old address back!

---

## 📋 Common Commands

```bash
### Check Nginx
sudo systemctl status nginx
sudo systemctl restart nginx

### Check Tor
sudo systemctl status tor
sudo systemctl restart tor

### View your address
sudo cat /var/lib/tor/hidden_service/hostname

### View Tor logs
sudo journalctl -u tor -f

### Check if it's working
sudo curl http://localhost/
```

---

## 🔒 Security Tips

### Don't Leak Your Real IP

- Don't upload files with GPS data (use `exiftool -all= photo.jpg`)
- Don't link to your public website or real email
- Don't use PHP/Python/Node.js (just HTML/CSS = safer)

### Backup Your Address

Your .onion private key is at `/var/lib/tor/hidden_service/hs_ed25519_secret_key`. Back it up:

```bash
sudo cp /var/lib/tor/hidden_service/hs_ed25519_secret_key ~/backup-onion-key.txt
sudo chown $USER:$USER ~/backup-onion-key.txt
```

Store it somewhere safe, ideally offline.

### Protect Sensitive Files

```bash
### Don't track access logs (less evidence)
### Already done - Tor hides visitor IPs

### Keep web root minimal
### Less code = fewer vulnerabilities
```

---

## ➕ Adding More Pages

Create a new HTML file:

```bash
sudo nano /srv/http/about.html
```

Then link to it from index.html:

```html
<a href="about.html">About</a>
```

---

## 🎯 Why Would I Do This?

- **Complete anonymity** - Your real identity is protected
- **Censorship-resistant** - Can't be shut down by ISPs
- **Privacy protection** - Visitors aren't tracked
- **Whistleblowing** - Safe channel for sensitive information
- **Learning** - Understand how privacy tech works

---

## 🔗 Related Guides

- 📖 **[Docker Tor Setup](apache-tor-docker.md)** - More isolated container version
- 📖 **[Security Hardening](security.md)** - Additional security layers
- 📖 **[Arch Linux Guide](arch.md)** - System package management
