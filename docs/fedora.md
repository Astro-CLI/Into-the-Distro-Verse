<!-- 
    WIKI GUIDE: fedora.md
    This file contains comprehensive setup and optimization procedures for Fedora Workstation.
    Adapt these configurations to your specific hardware and workflow requirements.
-->

# Fedora Workstation: Enterprise-Grade Desktop Computing

Fedora occupies a distinctive position in the Linux ecosystem as a contemporary, innovation-focused distribution backed by substantial corporate resources. While Fedora's philosophy emphasizes cutting-edge software stacks, achieving feature parity with community-driven distributions requires deliberate post-installation configuration. This guide addresses those essential gaps.

---

## 🚀 1. Package Manager Optimization

DNF, Fedora's package manager, requires tuning to achieve competitive performance with rolling-release counterparts. These optimizations address network efficiency and output clarity:

**Enable colored terminal output:**
```bash
echo "Color=1" | sudo tee -a /etc/dnf/dnf.conf
```

Improves terminal readability through syntax highlighting of package information.

**Activate parallel downloads:**
```bash
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
```

Leverages concurrent HTTP connections to dramatically reduce aggregate package installation time.

**Enable intelligent mirror selection:**
```bash
echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
```

Automatically identifies the geographically and performance-optimized mirror for your location.

For manual configuration, edit `/etc/dnf/dnf.conf` and add these options as separate lines:

```text
Color=1
max_parallel_downloads=10
fastestmirror=True
```

---

## 📦 2. Repository Architecture

### RPM Fusion: Extended Software Coverage

Fedora's distribution model prioritizes Free and Open Source software exclusively. This philosophical stance, while commendable, creates immediate gaps in multimedia support and proprietary drivers. RPM Fusion provides the necessary third-party repositories:

```bash
# Install both free and non-free repository definitions
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

This grants access to H.264 codecs, proprietary NVIDIA drivers, and numerous production-oriented software packages.

### COPR: Community-Maintained Software Collections

COPR (Community Projects) functions as Fedora's equivalent to the Arch User Repository, enabling individual developers and teams to maintain software outside the official distribution:

**Repository discovery:** Visit [copr.fedorainfracloud.org](https://copr.fedorainfracloud.org/)

**Repository activation syntax:**
```bash
sudo dnf copr enable author/projectname
```

**Practical example—installing LazyGit from community repositories:**
```bash
sudo dnf copr enable atim/lazygit
sudo dnf install lazygit
```

### Flatpak Integration

Fedora provides exceptional support for containerized application deployment via Flatpak. For comprehensive configuration and permission management strategies:

📖 **[docs/flatpak.md](flatpak.md)**

---

## 🎬 3. Multimedia Codec Infrastructure

Fedora requires explicit codec installation to support proprietary audio and video formats. This involves both system-level library installation and format-specific support:

```bash
sudo dnf groupupdate core
sudo dnf groupinstall "Multimedia" "Sound and Video"
```

### Wayland Display Protocol Support

Contemporary display servers require middleware for screen capture functionality. Xwayland Video Bridge provides the necessary translation layer:

```bash
sudo dnf install xwaylandvideobridge
```

If this package is unavailable in standard repositories, investigate COPR alternatives or Flathub distribution channels.

---

## 🛡️ 4. Filesystem Snapshots & Recovery

Fedora's default BTRFS filesystem configuration enables sophisticated snapshot capabilities for rapid system recovery. For detailed implementation of Snapper, TimeShift, and recovery procedures:

📖 **[docs/snapshots.md](snapshots.md)**

---

## 🧼 5. System Administration

### Essential DNF Operations

| Operation | Command |
| :--- | :--- |
| **System upgrade** | `sudo dnf upgrade --refresh` |
| **Package installation** | `sudo dnf install package_name` |
| **Package removal** | `sudo dnf remove package_name` |
| **Package search** | `dnf search keyword` |
| **Installed packages listing** | `dnf list --installed` |
| **Cache cleanup** | `sudo dnf clean all` |

### Release Cycle Management

Fedora maintains a predictable six-month release schedule. Transitioning to newer releases is streamlined:

```bash
sudo dnf install dnf-plugin-system-upgrade
sudo dnf system-upgrade download --releasever=41  # Specify target version
sudo dnf system-upgrade reboot
```

---

## 🔒 6. Mandatory Access Control: SELinux

Fedora enforces SELinux by default—a policy-based security framework fundamentally distinct from optional AppArmor implementations found in other distributions. Rather than disabling SELinux, address underlying permission issues through proper context restoration:

```bash
sudo restorecon -Rv /home/user/my_folder
```

This corrects SELinux security contexts for filesystem hierarchies, resolving permission-related errors without compromising system security.

---

## 🔗 Related Documentation

- 📖 **[Arch Linux Guide](arch.md)** — Rolling-release distribution and AUR ecosystem
- 📖 **[Debian Linux Guide](debian.md)** — Stable-release philosophy and external repository management
- 📖 **[Nix Package Manager](nix.md)** — Declarative package management across distributions
- 📖 **[System Security Hardening](security.md)** — Comprehensive Fedora security optimization
