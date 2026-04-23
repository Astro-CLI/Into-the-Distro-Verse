# Wayland GUI Privilege Escalation

Running GUI applications as root on Wayland systems requires special handling because `pkexec` (and similar tools) deliberately strip environment variables for security. This guide covers the problem and two recommended solutions.

---

## The Problem

On Wayland, `pkexec application` fails with GUI errors:
```
** could not connect to display
** Couldn't run dumpcap in child process: Permission denied
```

### Why X11 Approach Doesn't Work

**On X11:** Only `DISPLAY` variable needed (e.g., `:0`)

**On Wayland:** Multiple environment variables required:
- `WAYLAND_DISPLAY` — Wayland socket name (e.g., `wayland-0`)
- `XDG_RUNTIME_DIR` — User runtime directory (e.g., `/run/user/1000`)

When `pkexec` elevates privileges, it strips these variables for security, so the root process can't connect to your Wayland compositor. Additionally:
- Root `HOME` is `/root`, not your user home
- Qt/KDE apps can't find user config/theme files
- Result: White theme, no display connection

---

## Solution 1: Group-Based Elevation (Recommended)

**Best for:** Apps that support setgid/group-based permissions (Wireshark, packet capture tools, etc.)

**How it works:** The GUI app runs as your user; only the privileged tool (e.g., `dumpcap`) runs elevated.

### Setup (Wireshark Example)

```bash
# Add your user to the wireshark group
sudo usermod -a -G wireshark $USER

# Make dumpcap executable by the group
sudo chmod g+x /usr/bin/dumpcap

# Set the setgid bit so dumpcap runs as the wireshark group
sudo chmod g+s /usr/bin/dumpcap
```

Then **log out and back in**, or use:
```bash
newgrp wireshark
```

### Usage
```bash
wireshark
# No sudo/pkexec needed — runs as your user with capture privileges
```

### Advantages
- ✅ Minimal privilege elevation (principle of least privilege)
- ✅ No environment variable exposure
- ✅ Standard Linux practice
- ✅ Theme and configs work perfectly
- ✅ No wrapper scripts needed

### Disadvantages
- ❌ Requires logout/relogin to activate group membership
- ❌ Not all apps have setgid support
- ❌ Tool/binary must be designed for this

---

## Solution 2: Direct pkexec with Environment Variables

**Best for:** Quick one-off commands or minimal setup

**How it works:** Pass Wayland variables directly to `pkexec` via `env`.

### Usage

```bash
# Edit system file with theme intact
pkexec env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR QT_STYLE_OVERRIDE=breeze QT_QPA_PLATFORMTHEME=kde kate /etc/fstab

# Or any other app
pkexec env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR kate /etc/fstab
```

### Add an Alias (Optional)

```bash
# For Fish shell (~/.config/fish/config.fish)
alias pkexec-gui='pkexec env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR QT_STYLE_OVERRIDE=breeze QT_QPA_PLATFORMTHEME=kde'

# For Bash/Zsh (~/.bashrc or ~/.zshrc)
alias pkexec-gui='pkexec env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR QT_STYLE_OVERRIDE=breeze QT_QPA_PLATFORMTHEME=kde'
```

Then use:
```bash
pkexec-gui kate /etc/fstab
```

### Advantages
- ✅ Minimal setup (no wrapper script needed)
- ✅ Transparent what variables are being passed
- ✅ Works immediately
- ✅ Good for one-off commands

### Disadvantages
- ❌ Long command line (but fixable with alias)
- ❌ Runs entire application as root

---

## Solution 3: Wayland-Aware pkexec Wrapper

**Best for:** Frequently used privileged apps, cleaner workflow

**How it works:** Create a reusable wrapper script that preserves Wayland environment variables before `pkexec` escalates.

### Setup

Create `/usr/local/bin/run-as-root`:

```bash
sudo bash << 'SCRIPT'
cat > /usr/local/bin/run-as-root << 'EOF'
#!/bin/bash
export WAYLAND_DISPLAY=$WAYLAND_DISPLAY
export XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR
export QT_STYLE_OVERRIDE=breeze
export QT_QPA_PLATFORMTHEME=kde
exec "$@"
EOF
chmod +x /usr/local/bin/run-as-root
SCRIPT
```

Or manually with nano/vim:
```bash
sudo nano /usr/local/bin/run-as-root
# Paste the content above
# Save & exit
sudo chmod +x /usr/local/bin/run-as-root
```

Then add an alias to your shell config (`~/.config/fish/config.fish`, `~/.bashrc`, etc.):
```bash
alias pkrun='pkexec /usr/local/bin/run-as-root'
```

### Usage

```bash
# Edit system file with theme intact
pkrun kate /etc/fstab

# Or without alias:
pkexec /usr/local/bin/run-as-root kate /etc/fstab
```

### Advantages
- ✅ Works for any GUI app
- ✅ Wayland display and theme preserved
- ✅ Reusable for multiple applications
- ✅ Cleaner than long command lines

### Disadvantages
- ❌ Runs entire application as root (less secure than group approach)
- ❌ Requires creating wrapper script
- ❌ Should only be used when necessary

---

## Comparison: Direct vs Wrapper Approach

| Aspect | Direct (`env`) | Wrapper Script |
|--------|----------------|----------------|
| Setup Time | 30 seconds (alias only) | 2 minutes |
| Command Length | Long (but alias hides it) | Short & clean |
| Reusability | Good with alias | Better for frequent use |
| Transparency | See variables in command | Hidden in wrapper |
| Best For | One-off commands | Regular workflows |

**Recommendation:** 
- Use **direct `env`** for occasional root GUI access
- Use **wrapper script** if you frequently need privileged GUI apps
- Both are equally secure in terms of what's exposed

---

## Why kdesu Doesn't Work

KDE's `kdesu` is designed for X11 and reads PAM/sudoers configuration rather than system groups. On modern systems with custom user setups (especially without a root password), it often fails silently or refuses to authenticate.

**Not recommended** for Wayland systems.

---

## Best Practices

1. **Always prefer group-based elevation** when the tool supports it
2. **Avoid running entire GUIs as root** when alternatives exist
3. **Use pkexec wrapper only as a last resort** for admin tools
4. **Document why elevation is needed** for each tool in your setup
5. **Test after logout/relogin** when using group-based approaches

---

## References

- [Wayland Documentation](https://wayland.freedesktop.org/)
- [PolicyKit/pkexec](https://www.freedesktop.org/wiki/Software/polkit/)
- [Arch Wiki: Wireshark](https://wiki.archlinux.org/title/Wireshark)
- [Qt Platform Plugins](https://doc.qt.io/qt-6/qpa.html)
