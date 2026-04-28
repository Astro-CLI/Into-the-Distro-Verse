<!-- 
    WIKI GUIDE: arch.md
    This file contains my notes and setup steps. 
    Feel free to tweak it for your own distro! 
-->

# Arch Linux Setup & Maintenance Guide 🚀

This guide covers the specific steps to set up and maintain an Arch Linux environment.

---

<!-- Section for specific setup/config steps -->
## 🚀 1. Essential Setup

<!-- Quick sub-note for this part -->
### Pacman Optimizations (Quality of Life)
Before installing packages, make `pacman` faster and more visual.
1.  Edit the config: `sudo nano /etc/pacman.conf`
2.  Uncomment or add these lines under `[options]` (`ILoveCandy` adds a Pac-Man eating pellets to your progress bars):

    ```text
    Color
    ILoveCandy
    ParallelDownloads = 10
    ```

<!-- Quick sub-note for this part -->
### Mirror Management (Reflector)
Arch mirrors can get slow or outdated. `reflector` automatically finds the fastest ones for you.

```bash
sudo pacman -S reflector
# Update mirrors to the 10 fastest HTTPS ones in your region
sudo reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

```

<!-- Quick sub-note for this part -->
### Install AUR Helper (`paru`)
Paru is a modern AUR helper written in Rust. It's the primary way to access the vast library of community packages.

**Shell (Bash/Zsh/Fish):**

```bash
sudo pacman -S --needed base-devel git && \
git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si && cd .. && rm -rf paru

```

<!-- Quick sub-note for this part -->
### Wayland Screen Sharing (Xwayland Video Bridge)

**Essential for Wayland users:** Enables screen sharing in Discord, OBS, Zoom, Chromium, and other applications on Wayland desktops.

```bash
# Install from AUR
paru -S xwaylandvideobridge

# Or search for it
paru -Ss xwayland video bridge

```

---

<!-- Section for specific setup/config steps -->
## 🛡️ 2. Snapshots & Maintenance

BTRFS snapshots are an essential "safety net" for system stability. For a comprehensive guide on setting up **TimeShift**, **Snapper**, and bootloader integration, see the universal guide:

*   📖 **[docs/snapshots.md](snapshots.md)**

---

<!-- Section for specific setup/config steps -->
## 📦 3. Package Management

| List | Content |
| :--- | :--- |
| **`arch_pkglist.txt`** | Official native packages. |
| **`arch_aur_list.txt`** | AUR packages (via `paru`). |

<!-- Quick sub-note for this part -->
### Restore your system:

```bash
# Official packages
sudo pacman -S --needed - < packages/arch_pkglist.txt

# AUR packages
paru -S --needed - < packages/arch_aur_list.txt

```

<!-- Quick sub-note for this part -->
### Universal Packages (Flatpak)
For a comprehensive guide on managing Flatpaks, permissions, and Flathub, see the universal guide:

*   📖 **[docs/flatpak.md](flatpak.md)**

---

<!-- Section for specific setup/config steps -->
## 🛠️ 3. Maintenance

<!-- Quick sub-note for this part -->
### Clear Pacman Cache

```bash
sudo pacman -Sc

```

<!-- Quick sub-note for this part -->
### Find and Remove Orphans

```bash
pacman -Qtdq
sudo pacman -Rns $(pacman -Qtdq)

```

---

<!-- Section for specific setup/config steps -->
## 🔗 Related Guides
*   📖 **[Fedora Guide](fedora.md)** - Setup and optimizations for Fedora Workstation.
*   📖 **[Debian Guide](debian.md)** - Stable-release management and external repos.
*   📖 **[Nix Guide](nix.md)** - Using the universal Nix package manager on Arch.
*   📖 **[Security Guide](security.md)** - Hardening your Arch system.


<!-- 
    TIP: If you're using Neovim, you can use 
    :set wrap to make this easier to read! 
-->