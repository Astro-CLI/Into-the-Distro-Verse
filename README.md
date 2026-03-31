# My Arch Linux Setup: A Personal Wiki & Manual Guide

Welcome to my personal Arch Linux setup repository! This project serves as a comprehensive, manually-curated backup of my desktop environment, including package lists, configurations, and a wealth of information for setting up a new system from scratch.

This guide prioritizes knowledge and manual control over automation, helping you understand each part of the setup process.

---

## How to Use This Repository

If you're setting up a new machine, follow these steps to replicate this environment:

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Astro-CLI/My_Linux_Setup.git ~/Projects/My_Linux_Setup
    ```

2.  **Install Applications:**
    The `packages` directory contains lists of all installed applications. You can use them to quickly set up a new system. See the `packages/README.md` for detailed instructions.
    ```bash
    # Navigate to the repository
    cd ~/Projects/My_Linux_Setup

    # Install packages from the lists
    sudo pacman -S --needed - < packages/pkglist.txt
    paru -S --needed - < packages/aur_pkglist.txt
    xargs -a packages/flatpak_list.txt -r flatpak install -y
    ```

3.  **Restore KDE Plasma Configuration:**
    The `configs/kde` directory contains backups of key Plasma configuration files. See the `configs/kde/README.md` for detailed instructions on how to restore your desktop look and feel.

---

## Repository Structure

-   `packages/`: Contains lists of installed packages from Pacman, the AUR, and Flatpak.
-   `configs/`: Contains backed-up configuration files for various desktop environments and tools (e.g., KDE).
-   `apps/`: Application-specific configurations and data (e.g., Packet Tracer).
-   `docs/`: Detailed documentation on system maintenance, filesystem, and bootloader.
-   `README.md`: This main guide.

---

## Part 1: Application Management

The `packages` directory contains text files listing every application installed on the system, separated by source (official repositories, AUR, and Flatpak).

For detailed instructions on how to use these lists to regenerate them or to provision a new machine, please see the **[packages/README.md](packages/README.md)** file.

---

## Part 2: Configuration & Dotfiles

This repository stores key configuration files in the `configs` directory. This allows for a quick and easy way to restore your desktop's appearance, settings, and terminal profiles on a new installation.

-   **KDE Plasma:** See **[configs/kde/README.md](configs/kde/README.md)** for restoration instructions.

---

## Part 3: System Maintenance (TimeShift, BTRFS, GRUB)

Understanding how to maintain and recover your system is crucial. We use TimeShift for snapshots on a BTRFS filesystem, with GRUB as our bootloader.

For detailed information, see **[docs/system_maintenance.md](docs/system_maintenance.md)**.

---

## Part 4: Extra Arch Linux Tips

Here are some useful commands and tips for maintaining a healthy Arch Linux system.

-   **Update Your System:**
    ```bash
    sudo pacman -Syu
    ```

-   **Clean Pacman Cache:**
    ```bash
    sudo pacman -Sc
    ```

-   **Find Orphaned Packages:**
    ```bash
    pacman -Qtdq
    sudo pacman -Rns $(pacman -Qtdq)
    ```

-   **Check for Failed Services:**
    ```bash
    systemctl --failed
    ```

---

## Part 5: The Ultimate Resource List

*   **Arch Linux:** [archlinux.org](https://archlinux.org)
*   **Arch Wiki:** [wiki.archlinux.org](https://wiki.archlinux.org)
*   **KDE Plasma:** [kde.org/plasma-desktop](https://kde.org/plasma-desktop)
*   **Zsh:** [zsh.org](https://www.zsh.org) | **Oh My Zsh:** [ohmyz.sh](https://ohmyz.sh)
