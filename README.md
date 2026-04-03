# 🕷️ Into the Distro-Verse: Across the Multi-Distro Universe

Welcome to my personal Linux repository! This is a comprehensive, manually-curated backup of my system configurations, package lists, and guides for navigating different Linux "universes." 

Whether you're in the Arch Dimension, the Fedora Dimension, or experimenting with the Nix/Homebrew Multiverse, this repo has everything you need to replicate my environment.

---

## 🚀 Choose Your Dimension

Click on your current (or future) distribution to get started with a fresh install and system-specific tweaks.

| Dimension | Role | Guide |
| :--- | :--- | :--- |
| **Arch Linux** | The Power-User's Starship | [**docs/arch.md**](docs/arch.md) |
| **Fedora** | The Modern Desktop | [**docs/fedora.md**](docs/fedora.md) |
| **Nix** | The Universal Multi-Tool | [**docs/nix.md**](docs/nix.md) |
| **Homebrew** | The Linux "Brew" | [**docs/homebrew.md**](docs/homebrew.md) |
| **Flatpak** | The Universal App Store | [**docs/flatpak.md**](docs/flatpak.md) |

---

## 📦 Dimension-Specific Packages

The `packages/` directory contains text files for every application installed, separated by source and dimension. This allows for quick system restoration across different distros.

### How to use these lists:
1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Astro-CLI/Into-the-Distro-Verse.git
    cd Into-the-Distro-Verse
    ```
2.  **Follow the Restoration Guide:**
    See **[packages/README.md](packages/README.md)** for detailed, dimension-specific instructions on how to install everything.

---

## 🛡️ System Security & Maintenance

Security is a multi-layered approach. These guides cover how to protect your system regardless of which distro you're using.

*   **Security & Protection:** Hardening with AppArmor, Firewall (UFW), Antivirus (ClamAV), and Rootkit detection. [**docs/security.md**](docs/security.md)
*   **System Maintenance:** BTRFS snapshots, backups, and bootloader management. [**docs/system_maintenance.md**](docs/system_maintenance.md)

---

## 🎨 Configuration & Dotfiles

This repository stores key configuration files in the `configs` directory to ensure a consistent look and feel across all dimensions.

-   **KDE Plasma:** Restore themes, shortcuts, and layout. [**configs/kde/README.md**](configs/kde/README.md)
-   **GRUB & Theme:** Bootloader visual customization. [**configs/grub/README.md**](configs/grub/README.md)

---

## 🛠️ Extra Distro-Verse Tips

*   **Clean System Caches:** Keep your storage lean by regularly cleaning native package caches (e.g., `sudo pacman -Sc` or `sudo dnf clean all`).
*   **AUR & COPR Hygiene:** Always check your community packages for potential security risks before updating.
*   **Stay Updated:** Run your updates regularly! 
    ```bash
    # Arch
    paru -Syu
    # Fedora
    sudo dnf upgrade --refresh
    ```

---

## 🕸️ The Ultimate Linux Resource List

Looking for more knowledge? Check out the **[Bottom of the README](README.md#part-5-the-ultimate-linux-resource-list)** for the best documentation, creators, and communities in the Linux ecosystem.
