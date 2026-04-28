# Fedora Linux: The Modern Desktop Guide

This guide is for those using or transitioning to Fedora. While Fedora is known for being "First," it requires a few post-install steps to reach the same level of software availability and performance as an Arch/AUR setup.

---

## 🚀 1. DNF Optimization (Speed up updates)
By default, DNF can be slow. Add these tweaks to `/etc/dnf/dnf.conf` to enable parallel downloads and faster mirror selection:

**Enable colored output:**
```bash
echo "Color=1" | sudo tee -a /etc/dnf/dnf.conf
```

**Enable parallel downloads (10 at a time):**
```bash
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
```

**Enable fastest mirror selection:**
```bash
echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
```

Or manually edit `/etc/dnf/dnf.conf` and add each on separate lines:
```text
Color=1
max_parallel_downloads=10
fastestmirror=True
```

---

## 📦 2. Software Repositories

### RPM Fusion (The Essential "AUR-Lite")
Fedora only ships FOSS software. **RPM Fusion** provides the proprietary codecs, NVIDIA drivers, and software that Fedora can't include.

```bash
# Enable Free and Non-Free repositories
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

### COPR (Fedora's AUR)
**COPR** (Community Projects) is the Fedora equivalent of the AUR. It allows developers to host their own repositories.

*   **To search for a repo:** Visit [copr.fedorainfracloud.org](https://copr.fedorainfracloud.org/)
*   **To enable a repo:**
    ```bash
    sudo dnf copr enable author/projectname
    ```
*   **Example (LazyGit):**
    ```bash
    sudo dnf copr enable atim/lazygit
    sudo dnf install lazygit
    ```

### Flatpak & Flathub
Fedora is a first-class citizen for Flatpaks. For a comprehensive guide on enabling the full Flathub repository, managing permissions with Flatseal, and CLI overrides, see the universal guide:

*   📖 **[docs/flatpak.md](flatpak.md)**

---

## 🎬 3. Multimedia Codecs
Fedora needs these to play H.264, MP3s, and other patented formats correctly:

```bash
sudo dnf groupupdate core
sudo dnf groupinstall "Multimedia" "Sound and Video"
```

### Wayland Screen Sharing Support

**Essential for Wayland users:** Enables screen sharing in Discord, OBS, Zoom, Chromium, and other applications on Wayland desktops.

```bash
# Install Xwayland Video Bridge
sudo dnf install xwaylandvideobridge
```

💡 *If not found, check if it's available from COPR or Flathub as an alternative.*

---

## 🛡️ 4. Snapshots & Maintenance

Fedora uses BTRFS by default, making snapshots an incredibly powerful tool for system stability. For a guide on setting up **Snapper**, **TimeShift**, and BTRFS maintenance, see the universal guide:

*   📖 **[docs/snapshots.md](snapshots.md)**

---

## 🧼 5. System Maintenance

### Package Management Cheat Sheet
| Task | Command |
| :--- | :--- |
| **Update System** | `sudo dnf upgrade --refresh` |
| **Install Package** | `sudo dnf install package_name` |
| **Remove Package** | `sudo dnf remove package_name` |
| **Search** | `dnf search query` |
| **List Installed** | `dnf list --installed` |
| **Clean Cache** | `sudo dnf clean all` |

### Version Upgrades
Fedora releases a new version every 6 months. To upgrade to a new release:
```bash
sudo dnf install dnf-plugin-system-upgrade
sudo dnf system-upgrade download --releasever=41  # Replace with target version
sudo dnf system-upgrade reboot
```

---

## 🔒 6. SELinux vs. AppArmor
Fedora uses **SELinux** by default. Unlike Arch (where AppArmor is optional), SELinux is baked into the system. **Do not disable it.** If you have permission issues, use `restorecon` to fix file labeling:
```bash
sudo restorecon -Rv /home/user/my_folder
```

---

## 🔗 Related Guides
*   📖 **[Arch Linux Guide](arch.md)** - Rolling-release setup and AUR management.
*   📖 **[Debian Guide](debian.md)** - Stable-release management and external repos.
*   📖 **[Nix Guide](nix.md)** - Using the universal Nix package manager on Fedora.
*   📖 **[Security Guide](security.md)** - Hardening your Fedora system.
