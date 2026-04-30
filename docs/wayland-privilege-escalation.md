<!-- 
    WIKI GUIDE: wayland-privilege-escalation.md
    Solutions for running GUI applications with elevated privileges on Wayland.
    Covers group-based elevation, pkexec with environment variables, and wrapper scripts.
-->

### Running GUI Apps as Root on Wayland

Running graphical applications with elevated privileges on Wayland is trickier than X11 because `pkexec` strips environment variables for security. This guide shows three solutions, from simplest to most flexible.

---

## 🤔 Why This is Complicated

**X11 was simple:** Just pass the `DISPLAY` variable, done.

**Wayland needs more:**
- `WAYLAND_DISPLAY` — Which Wayland socket to use
- `XDG_RUNTIME_DIR` — Where runtime files live
- Theme/config variables — So the app looks right
- Root HOME doesn't have your configs

When `pkexec` runs a command, it deliberately strips these variables for security—so your GUI can't connect.

---

## ✅ Solution 1: Group-Based Elevation (Recommended)

**Best for:** Apps designed with privilege separation (Wireshark, packet capture tools).

**How it works:** The GUI runs as your user; only the privileged tool runs elevated.

### Example: Wireshark

```bash
### Add your user to wireshark group
sudo usermod -a -G wireshark $USER

### Make dumpcap (the capture tool) run with group privileges
sudo chmod g+s /usr/bin/dumpcap
sudo chmod g+x /usr/bin/dumpcap

### Log out and back in, or:
newgrp wireshark
```

Then just run it normally:

```bash
wireshark
```

No `sudo` or `pkexec` needed!

### Why This Is Best

✅ Minimal privilege elevation (principle of least privilege)
✅ No environment variable exposure
✅ Standard Linux practice
✅ Theme and configs work perfectly
✅ No wrapper scripts needed

### Disadvantages

❌ Requires logout/relogin to activate group membership
❌ Not all apps support this approach
❌ Tool/binary must be designed for it

---

## ⚡ Solution 2: Direct pkexec with Environment Variables

**Best for:** Quick one-off commands or minimal setup.

**How it works:** Pass Wayland variables directly to `pkexec`.

### Basic Usage

```bash
### Edit a system file with theme intact
pkexec env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR QT_STYLE_OVERRIDE=breeze QT_QPA_PLATFORMTHEME=kde kate /etc/fstab
```

Long? Yes. But it works immediately.

### Make an Alias

For Bash/Zsh (add to ~/.bashrc or ~/.zshrc):

```bash
alias pkexec-gui='pkexec env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR QT_STYLE_OVERRIDE=breeze QT_QPA_PLATFORMTHEME=kde'
```

For Fish (add to ~/.config/fish/config.fish):

```fish
alias pkexec-gui 'pkexec env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR QT_STYLE_OVERRIDE=breeze QT_QPA_PLATFORMTHEME=kde'
```

Then use it simply:

```bash
pkexec-gui kate /etc/fstab
```

### Advantages

✅ Minimal setup (just an alias)
✅ Transparent what variables are being passed
✅ Works immediately
✅ Good for occasional commands

### Disadvantages

❌ Runs entire application as root (less secure than group approach)
❌ Long command line (fixed by alias)

---

## 🔧 Solution 3: Wayland-Aware pkexec Wrapper

**Best for:** Frequently used privileged apps, cleaner workflow.

**How it works:** Create a reusable wrapper script that preserves Wayland environment variables.

### Create the Wrapper

Create `/usr/local/bin/run-as-root`:

```bash
#!/bin/bash
export WAYLAND_DISPLAY=$WAYLAND_DISPLAY
export XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR
export QT_STYLE_OVERRIDE=breeze
export QT_QPA_PLATFORMTHEME=kde
exec "$@"
```

Install it:

```bash
sudo bash << 'INSTALL_SCRIPT'
cat > /usr/local/bin/run-as-root << 'WRAPPER'
#!/bin/bash
export WAYLAND_DISPLAY=$WAYLAND_DISPLAY
export XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR
export QT_STYLE_OVERRIDE=breeze
export QT_QPA_PLATFORMTHEME=kde
exec "$@"
WRAPPER
chmod +x /usr/local/bin/run-as-root
INSTALL_SCRIPT
```

### Add an Alias

Bash/Zsh (~/.bashrc or ~/.zshrc):

```bash
alias pkrun='pkexec /usr/local/bin/run-as-root'
```

Fish (~/.config/fish/config.fish):

```fish
alias pkrun 'pkexec /usr/local/bin/run-as-root'
```

### Usage

```bash
### Edit system file with theme
pkrun kate /etc/fstab

### Or without alias:
pkexec /usr/local/bin/run-as-root kate /etc/fstab
```

### Advantages

✅ Works for any GUI app
✅ Wayland display and theme preserved
✅ Reusable for multiple applications
✅ Cleaner than long command lines

### Disadvantages

❌ Runs entire application as root (less secure)
❌ Requires creating wrapper script
❌ Should only be used when necessary

---

## 📊 Comparison

| Aspect | Group-Based | Direct env | Wrapper |
|--------|-------------|-----------|---------|
| Setup Time | 2 minutes + logout | 30 seconds | 2 minutes |
| Security | Best | Good | Good |
| Ease of Use | Simple | Good | Very Simple |
| Reusability | Limited | Good | Excellent |
| Theme Support | Perfect | Perfect | Perfect |

---

## 🎯 Recommendations

**For Wireshark / Capture tools:**
Use group-based elevation (Solution 1)

**For occasional commands:**
Use direct env with alias (Solution 2)

**For regular admin tools:**
Use wrapper script (Solution 3)

---

## ⚠️ Why kdesu Doesn't Work

KDE's `kdesu` tool is designed for X11 and relies on PAM configuration. On modern systems it often fails silently or refuses to authenticate.

**Not recommended** for Wayland. Use the solutions above instead.

---

## 🔒 Best Practices

1. **Always prefer group-based elevation** when the tool supports it
2. **Avoid running entire GUIs as root** when alternatives exist
3. **Use pkexec wrapper only as a last resort** for admin tools
4. **Document why elevation is needed** for each tool
5. **Test after logout/relogin** when using group-based approaches

---

## 🎯 Why Would I Do This?

- **Edit system files** - Configs, firewall rules, etc.
- **Install packages** - When GUI installers need root
- **Debug network issues** - Capture packets with Wireshark
- **System administration** - Manage users, mounts, etc.
- **Security tools** - Run security scanners

---

## 🔗 Related Guides

- 📖 **[Security Hardening](security.md)** - Complete system security
- 📖 **[Arch Linux Guide](arch.md)** - Package management
- 📖 **[Fedora Guide](fedora.md)** - Fedora-specific tools
