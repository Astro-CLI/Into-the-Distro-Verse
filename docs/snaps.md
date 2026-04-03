# Snap: The Universal App Store (Canonical) 📦

Snap is a software packaging and deployment system developed by Canonical. Like Flatpak, it is designed to be universal across distributions, but it also handles CLI tools and system services particularly well.

---

## 🤔 Why Snap?

1.  **Direct from Developers:** Many major apps (like VS Code, Spotify, and Slack) are officially maintained as Snaps by their developers.
2.  **Classic Confinement:** Unlike Flatpak, Snaps can have "classic" confinement, giving them full access to your system—useful for compilers and deep system tools.
3.  **Automatic Updates:** Snaps update automatically in the background by default.
4.  **Rollbacks:** You can easily revert to a previous version of a Snap if an update breaks something.

---

## 🚀 1. Installation

Snap requires a background service called `snapd` to be running.

### On Arch Linux
```bash
# 1. Install from the AUR
paru -S snapd

# 2. Enable the socket (handles the daemon automatically)
sudo systemctl enable --now snapd.socket

# 3. Enable classic snap support (symlink)
sudo ln -s /var/lib/snapd/snap /snap
```
*Note: You may need to restart your session for the binary paths to be updated.*

### On Fedora
```bash
sudo dnf install snapd
sudo ln -s /var/lib/snapd/snap /snap
```

---

## 📦 2. Basic Commands

| Task | Command |
| :--- | :--- |
| **Search** | `snap find app_name` |
| **Install** | `sudo snap install app_id` |
| **Install Classic** | `sudo snap install app_id --classic` |
| **List Installed** | `snap list` |
| **Update All** | `sudo snap refresh` |
| **Revert Update** | `sudo snap revert app_id` |
| **Uninstall** | `sudo snap remove app_id` |

---

## 🔒 3. Confinement Levels

-   **Strict:** The default. The app is sandboxed and cannot access your files without specific "interfaces" (connections).
-   **Classic:** The app has full access to your system (like a standard `.deb` or `.rpm`). Required for tools like VS Code or compilers.
-   **Devmode:** For developers. The app has full access but logs what it *would* have been blocked from doing.

---

## 🧹 4. Maintenance

Snaps keep old versions of packages on your disk by default, which can take up significant space.

**To limit the number of old versions kept (e.g., to 2):**
```bash
sudo snap set system refresh.retain=2
```

---

## ⚖️ Snap vs. Flatpak

| Feature | Snap | Flatpak |
| :--- | :--- | :--- |
| **Creator** | Canonical (Ubuntu) | Community (Freedesktop) |
| **Best For** | CLI tools, Servers, Proprietary Apps | Desktop Apps, GUI-heavy tools |
| **Backend** | Proprietary (Snap Store) | Open Source (Flathub, etc.) |
| **Mounting** | Uses Loop Devices (visible in `lsblk`) | Does not use Loop Devices |

---

## 🔗 Related Guides
*   📖 **[Flatpak Guide](flatpak.md)** - The community-driven alternative to Snap.
*   📖 **[Nix Guide](nix.md)** - Universal and functional package management.
*   📖 **[Homebrew Guide](homebrew.md)** - CLI-focused package manager for Linux.
