# Fedora Linux: The Modern Desktop Guide

This guide is for those using or transitioning to Fedora. While Fedora is known for being "First," it requires a few post-install steps to reach the same level of software availability and performance as an Arch/AUR setup.

---

## 🚀 1. DNF Optimization (Speed up updates)
By default, DNF can be slow. Add these tweaks to `/etc/dnf/dnf.conf` to enable parallel downloads and faster mirror selection:

```bash
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
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

### Flatpak & Flathub (The Software Goldmine)
Fedora comes with its own Flatpak repository (fedora), which is smaller and more curated. To get access to thousands of community apps (like Spotify, Discord, or Steam), you should enable the full **Flathub** repository.

**1. Enable the Full Flathub Repo:**
Fedora often includes a "filtered" version of Flathub by default. To get the full version:
```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

**2. Why use Flathub over Fedora's repo?**
-   **Updates:** Flathub apps usually update faster.
-   **Selection:** Flathub contains proprietary apps (Discord, Zoom) that Fedora's FOSS-focused repo does not.
-   **Isolation:** Flatpaks are sandboxed, making them a great choice for apps you don't fully trust with your system files.

**3. Manage Repositories:**
```bash
# See which repos are enabled
flatpak remotes

# To remove the default Fedora repo if you only want Flathub
# (Warning: This will uninstall Fedora-provided Flatpaks)
# flatpak remote-delete fedora
```

### Flatpak Permissions & Flatseal
Flatpaks are sandboxed, meaning they can't access your files or hardware unless you let them. Sometimes an app (like a Code Editor or Game) needs extra permissions to work.

**Option A: Flatseal (The GUI Way)**
The easiest way to manage permissions. It's a "settings" app for all your other Flatpaks.
```bash
flatpak install flathub com.github.tchx84.Flatseal
```

**Option B: The CLI Way (Overriding)**
You can do everything Flatseal does from the terminal using the `override` command.

*   **Allow access to a folder:**
    ```bash
    # Grant VS Codium access to a specific folder
    flatpak override com.vscodium.codium --filesystem=/path/to/my/projects
    ```
*   **Allow access to all your files (Danger!):**
    ```bash
    flatpak override com.example.App --filesystem=home
    ```
*   **Allow access to USB devices:**
    ```bash
    flatpak override com.example.App --device=all
    ```
*   **Reset all overrides to default:**
    ```bash
    flatpak override com.example.App --reset
    ```
*   **Show current overrides:**
    ```bash
    flatpak override com.example.App --show
    ```

---

## 🎬 3. Multimedia Codecs
Fedora needs these to play H.264, MP3s, and other patented formats correctly:

```bash
sudo dnf groupupdate core
sudo dnf groupinstall "Multimedia" "Sound and Video"
```

---

## 🛡️ 4. System Maintenance

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

## 🔒 5. SELinux vs. AppArmor
Fedora uses **SELinux** by default. Unlike Arch (where AppArmor is optional), SELinux is baked into the system. **Do not disable it.** If you have permission issues, use `restorecon` to fix file labeling:
```bash
sudo restorecon -Rv /home/user/my_folder
```
