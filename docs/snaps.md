<!-- 
    WIKI GUIDE: snaps.md
    Guide to Snap package management - Canonical's universal app distribution format.
    Covers installation, usage, permissions, and comparison with alternatives.
-->

### Snap: Universal Apps Made Easy

Snaps are self-contained application packages that work on any Linux distribution. Unlike traditional packages, snaps bundle their own dependencies, so the same snap runs identically on Arch, Fedora, Ubuntu, or anything else. This guide shows you how to install and manage them.

---

## 🤔 Why Use Snaps?

- **Universal compatibility** - Same app works on any Linux distro
- **Direct from developers** - VS Code, Spotify, Slack maintain official snaps
- **Automatic updates** - Stay current without thinking about it
- **Easy rollbacks** - Revert to a previous version if something breaks
- **Sandboxed security** - Apps run in isolated environments

---

## 🚀 1. Installation

### On Arch Linux

```bash
### Install snapd from AUR
paru -S snapd

### Enable the socket (handles the daemon automatically)
sudo systemctl enable --now snapd.socket

### Enable classic snap support
sudo ln -s /var/lib/snapd/snap /snap
```

Note: You may need to restart your session for the paths to update.

### On Fedora

```bash
sudo dnf install snapd
sudo ln -s /var/lib/snapd/snap /snap
```

---

## 📦 2. Basic Commands

| Task | Command |
|------|---------|
| Search for an app | `snap find app_name` |
| Install an app | `sudo snap install app_id` |
| Install (no sandbox) | `sudo snap install app_id --classic` |
| List installed | `snap list` |
| Update all | `sudo snap refresh` |
| Revert app update | `sudo snap revert app_id` |
| Uninstall | `sudo snap remove app_id` |

### Examples

```bash
### Install VS Code
sudo snap install code --classic

### Install Spotify
sudo snap install spotify

### See all your installed snaps
snap list

### Update everything
sudo snap refresh
```

---

## 🔐 3. Understanding Snap Confinement

Snaps run with different levels of isolation:

### Strict Confinement (Default)

The app is sandboxed and can't access files or system resources without explicit permission (interfaces).

```bash
### Example: Firefox with strict confinement
sudo snap install firefox
```

### Classic Confinement

The app has full system access (like traditional packages). Needed for compilers, IDEs, and deep system tools.

```bash
### Example: VS Code needs full access
sudo snap install code --classic
```

### Devmode (Developers Only)

The app can see what it would be blocked from doing (for debugging).

```bash
sudo snap install app_id --devmode
```

---

## 🧹 4. Storage Maintenance

Snaps keep old versions for rollbacks, which can waste disk space over time.

Limit how many old versions to keep:

```bash
### Keep only 2 old versions of each snap
sudo snap set system refresh.retain=2
```

---

## ⚖️ 5. Snap vs. Flatpak vs. Others

| Feature | Snap | Flatpak | Nix |
|---------|------|---------|-----|
| Creator | Canonical | Community | Community |
| Best For | CLI tools, proprietary apps | Desktop GUIs | Development |
| Updates | Automatic | Manual | Manual |
| Storage | Uses loop devices | Direct | Functional |
| Sandbox | Strong | Strong | Very strong |

**Choose Snap if:**
- You want automatic updates
- You're on Ubuntu (native support)
- You need cutting-edge CLI tools

**Choose Flatpak if:**
- You prefer desktop apps
- You want more control over updates
- You like open-source tools

---

## 🎯 Why Would I Use This?

- **Same app everywhere** - Install once, works on any distro
- **Always up-to-date** - Get the latest version automatically
- **No dependency conflicts** - Apps bring their own libraries
- **Easy management** - Simple commands for install/remove/update
- **Rollback easily** - Previous version always available

---

## 🔗 Related Guides

- 📖 **[Flatpak Guide](flatpak.md)** - Canonical's competitor, great for desktop apps
- 📖 **[Nix Guide](nix.md)** - Functional package management
- 📖 **[Homebrew Guide](homebrew.md)** - CLI-focused universal packages
- 📖 **[Arch Linux Guide](arch.md)** - Native package management
