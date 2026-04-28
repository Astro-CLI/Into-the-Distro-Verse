<!-- 
    WIKI GUIDE: arch.md
    This file contains comprehensive setup and maintenance procedures for Arch Linux.
    Feel free to adapt these configurations for your specific use case.
-->

# Arch Linux: A Pragmatic Rolling-Release Environment

Arch Linux represents a philosophy-driven distribution that prioritizes simplicity through user control rather than automation. This guide covers the essential optimizations, package management strategies, and maintenance routines that make Arch an efficient platform for experienced users.

---

## 🚀 1. Core System Optimization

### Pacman Configuration Enhancement

The default `pacman` configuration is functional but can be significantly improved for both performance and user experience. Edit `/etc/pacman.conf` to unlock these quality-of-life improvements:

**Colored package manager output:**
```text
Color
```
Enables syntax highlighting in pacman's terminal output, making information more scannable.

**Visual progress feedback:**
```text
ILoveCandy
```
Displays an animated Pac-Man character consuming pellets during package downloads—an elegant touch that provides real-time visual feedback during operations.

**Parallel download acceleration:**
```text
ParallelDownloads = 10
```
Instructs pacman to fetch up to 10 packages simultaneously from mirrors, significantly reducing installation time on modern connections.

### Mirror Selection with Reflector

Arch's package delivery depends on mirror infrastructure, which can vary in speed and synchronization status. The `reflector` utility automates the discovery and configuration of optimal mirrors:

```bash
sudo pacman -S reflector
# Identify the 10 fastest HTTPS-enabled mirrors in your region
sudo reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```

This approach ensures your system consistently pulls packages from reliable, geographically-optimized sources.

### AUR Access via Paru

The Arch User Repository (AUR) expands Arch's package ecosystem exponentially. Paru, a modern AUR helper written in Rust, provides a seamless interface to this community-maintained collection:

```bash
sudo pacman -S --needed base-devel git && \
git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si && cd .. && rm -rf paru
```

### Wayland Screen Sharing Infrastructure

Modern display protocols require explicit middleware for screen capture functionality. Xwayland Video Bridge bridges this gap for Wayland-based desktop environments:

```bash
# Install from the AUR
paru -S xwaylandvideobridge

# Alternatively, search for available versions
paru -Ss xwayland video bridge
```

This enables screen sharing across Discord, OBS, Zoom, Chromium, and similar applications on Wayland desktops.

---

## 🛡️ 2. System Resilience & Recovery

### Snapshot-Based System Protection

Arch benefits significantly from snapshot infrastructure for rapid recovery scenarios. BTRFS snapshots provide atomic system state preservation. For comprehensive implementation details covering TimeShift, Snapper, and bootloader integration:

📖 **[docs/snapshots.md](snapshots.md)**

---

## 📦 3. Package Inventory Management

Arch provides multiple package restoration mechanisms documented in dedicated inventory files:

| Inventory | Purpose |
| :--- | :--- |
| **`arch_pkglist.txt`** | Official repository packages. |
| **`arch_aur_list.txt`** | AUR-sourced packages via `paru`. |

### System Restoration Procedure

```bash
# Restore official packages
sudo pacman -S --needed - < packages/arch_pkglist.txt

# Restore AUR packages
paru -S --needed - < packages/arch_aur_list.txt
```

### Cross-Distribution Package Management

For application coverage beyond Arch repositories, consult the universal package management guide:

📖 **[docs/flatpak.md](flatpak.md)**

---

## 🛠️ 4. Ongoing System Maintenance

### Cache Pruning

```bash
sudo pacman -Sc
```

Removes cached packages that are no longer installed, reclaiming disk space while preserving the most recent package versions for rapid reinstallation.

### Orphan Package Removal

```bash
pacman -Qtdq
sudo pacman -Rns $(pacman -Qtdq)
```

Identifies and removes packages that were installed as dependencies but are no longer required by any installed package—a frequent source of system bloat.

---

## 🔗 Related Documentation

- 📖 **[Fedora Linux Guide](fedora.md)** — Workstation-focused distribution with stable release cycles
- 📖 **[Debian Linux Guide](debian.md)** — Conservative stability-first approach and multi-distro repository integration
- 📖 **[Nix Package Manager](nix.md)** — Declarative package management across distributions
- 📖 **[System Security Hardening](security.md)** — Defense-in-depth strategies for Arch systems
