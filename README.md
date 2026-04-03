# Into the Distro-Verse 🌌

This repository is a collection of my Linux system configurations, package lists, and setup guides. It is designed to be a "single source of truth" for replicating my environment across different Linux distributions, focusing on **Arch Linux**, **Fedora**, and universal tools like **Nix** and **Flatpak**.

---

## 📖 Quick Navigation

Detailed setup and maintenance guides for each system and toolset.

| Distribution / Tool | Description | Guide |
| :--- | :--- | :--- |
| **Arch Linux** | Main desktop configuration & AUR setup | [**docs/arch.md**](docs/arch.md) |
| **Fedora** | Workstation setup & DNF optimizations | [**docs/fedora.md**](docs/fedora.md) |
| **Nix** | Reproducible package management | [**docs/nix.md**](docs/nix.md) |
| **Homebrew** | CLI tool manager for Linux | [**docs/homebrew.md**](docs/homebrew.md) |
| **Flatpak** | Sandboxed universal applications | [**docs/flatpak.md**](docs/flatpak.md) |
| **Snapshots** | BTRFS & system recovery (TimeShift/Snapper) | [**docs/snapshots.md**](docs/snapshots.md) |

---

## 📦 Package Management

The `packages/` directory contains text files listing all installed applications. These are used to quickly restore software on a fresh installation.

### How to Restore
1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Astro-CLI/Into-the-Distro-Verse.git
    cd Into-the-Distro-Verse
    ```
2.  **Run the Restoration Guide:**
    Follow the specific commands for your system in the **[Package Management Guide](packages/README.md)**.

---

## 🛡️ Security & System Maintenance

Guides for hardening and maintaining a healthy Linux system.

*   **System Security:** Setup for AppArmor, UFW Firewall, ClamAV, and encrypted DNS (DoT). [**docs/security.md**](docs/security.md)
*   **System Maintenance:** Instructions for BTRFS health checks and backup strategies. [**docs/snapshots.md**](docs/snapshots.md)

---

## 🎨 Configuration & Dotfiles

Backups of key desktop environment settings to ensure a consistent experience.

-   **KDE Plasma:** Restore desktop layout, shortcuts, and global themes. [**configs/kde/README.md**](configs/kde/README.md)
-   **GRUB Bootloader:** Visual customization and themes. [**configs/grub/README.md**](configs/grub/README.md)

---

## 🕸️ The Ultimate Linux Resource List

A curated collection of documentation, communities, and tools for mastering Linux.

<details>
<summary>Click to expand resource list</summary>

### 📚 Essential Documentation
*   **Arch Wiki:** [wiki.archlinux.org](https://wiki.archlinux.org) - The most comprehensive Linux documentation available.
*   **Fedora Docs:** [docs.fedoraproject.org](https://docs.fedoraproject.org) - Official documentation for the Fedora ecosystem.
*   **Linux Journey:** [linuxjourney.com](https://linuxjourney.com) - Excellent for learning Linux fundamentals.

### 📺 Content Creators
*   **Chris Titus Tech:** [youtube.com/@ChrisTitusTech](https://www.youtube.com/@ChrisTitusTech) - Practical guides and optimization.
*   **The Linux Experiment:** [youtube.com/@TheLinuxExperiment](https://www.youtube.com/@TheLinuxExperiment) - Weekly news and reviews.
*   **Learn Linux TV:** [youtube.com/@LearnLinuxTV](https://www.youtube.com/@LearnLinuxTV) - Deep technical tutorials.

### 🐚 Terminal & CLI Mastery
*   **Starship:** [starship.rs](https://starship.rs) - A fast, customizable prompt for any shell.
*   **tldr.sh:** [tldr.sh](https://tldr.sh/) - Practical, example-based command usage.
*   **ShellCheck:** [shellcheck.net](https://www.shellcheck.net) - Static analysis for shell scripts.

*(See the full list in the README source for more links.)*
</details>
