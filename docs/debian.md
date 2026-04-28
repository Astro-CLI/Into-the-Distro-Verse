# Debian: The Stable Foundation 🌀

Debian is the "Universal Operating System" that serves as the base for Ubuntu, Kali, and many others. While it prizes stability, you may sometimes need newer or more specialized packages.

---

## 🚀 0. APT Optimization (Speed up updates)

Optimize APT for faster updates and colored output:

**Enable colored output:**
```bash
echo "Apt::Color \"1\";" | sudo tee -a /etc/apt/apt.conf.d/99custom-options
```

**Assume yes to all prompts (be careful with this one):**
```bash
echo "APT::Get::Assume-Yes \"true\";" | sudo tee -a /etc/apt/apt.conf.d/99custom-options
```

Or manually edit `/etc/apt/apt.conf.d/99custom-options` and add each on separate lines:
```text
Apt::Color "1";
APT::Get::Assume-Yes "true";
```

---

## 🚀 1. Basic Repository Management

Standard repositories are defined in `/etc/apt/sources.list`.

### Adding a Standard Repository
To add a new source manually:
```bash
echo "deb http://deb.debian.org/debian bookworm-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
sudo apt update
```

### Backports (The "Safe" Way to get newer apps)
If you need a newer kernel or app version on Debian Stable, always check **Backports** first before adding external distros.
```bash
sudo apt install -t bookworm-backports package_name
```

---

## 🏗️ 2. Adding External Repositories (Ubuntu & Kali)

⚠️ **WARNING: THE "FRANKENDEBIAN" RISK**
Adding repositories from different distributions (like Ubuntu or Kali) into a standard Debian system is dangerous. It can cause dependency conflicts that make your system un-updatable. **Proceed with caution.**

### Adding Ubuntu Repositories
You might want this for specific PPAs or newer libraries.
1.  **Add the repository:**
    ```bash
    echo "deb http://archive.ubuntu.com/ubuntu/ noble main universe" | sudo tee /etc/apt/sources.list.d/ubuntu.list
    ```
2.  **Add the GPG Key:** (You must find the specific key for the repo you are adding).

### Adding Kali Linux Repositories
Useful if you want access to Kali's massive suite of security tools without a full Kali install.
1.  **Add the Kali repo:**
    ```bash
    echo "deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" | sudo tee /etc/apt/sources.list.d/kali.list
    ```
2.  **Import the Kali GPG key:**
    ```bash
    wget -q -O - https://archive.kali.org/archive-key.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kali-archive-keyring.gpg
    ```

---

## ⚖️ 3. Safe Management: APT Pinning

To prevent Ubuntu or Kali from accidentally overwriting your core Debian system files, you should use **APT Pinning**. This tells Debian to only use the external repo for specific packages you ask for.

1.  Create a pin file: `sudo nano /etc/apt/preferences.d/external-repo`
2.  Add this configuration:
    ```text
    Package: *
    Pin: release o=Kali
    Pin-Priority: 100

    Package: *
    Pin: release o=Ubuntu
    Pin-Priority: 100
    ```
    *A priority of 100 ensures Debian will always prefer its own packages unless you manually force the install from the external repo.*

---

## 🎬 4. Multimedia & Wayland Utilities

### Wayland Screen Sharing Support

**Essential for Wayland users:** Enables screen sharing in Discord, OBS, Zoom, Chromium, and other applications on Wayland desktops.

```bash
# Install Xwayland Video Bridge
sudo apt install xwaylandvideobridge

# If not available in main repos, try from backports:
# sudo apt -t bookworm-backports install xwaylandvideobridge
```

💡 *Ubuntu users may find this in the main repositories. Debian users might need backports or external PPAs.*

---

## 🛠️ 5. Essential Commands

| Task | Command |
| :--- | :--- |
| **Update Lists** | `sudo apt update` |
| **Upgrade System** | `sudo apt upgrade` |
| **Install from Specific Repo** | `sudo apt install -t kali-rolling package_name` |
| **Fix Broken Deps** | `sudo apt install -f` |
| **Clean Cache** | `sudo apt clean` |

---

## 🔗 Related Guides
*   📖 **[Arch Linux Guide](arch.md)** - Rolling-release setup and AUR management.
*   📖 **[Fedora Guide](fedora.md)** - Setup and optimizations for Fedora Workstation.
*   📖 **[Security Guide](security.md)** - Hardening your Debian system.
