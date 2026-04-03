# Into the Distro-Verse 🌌

This repository is a collection of my Linux system configurations, package lists, and setup guides. It is designed to be a "single source of truth" for replicating my environment across different Linux distributions, focusing on **Arch Linux**, **Fedora**, and universal tools like **Nix** and **Flatpak**.

---

## 📖 Quick Navigation

Detailed setup and maintenance guides for each system and toolset.

| Distribution / Tool | Description | Guide |
| :--- | :--- | :--- |
| **Arch Linux** | Main desktop configuration & AUR setup | [**docs/arch.md**](docs/arch.md) |
| **Fedora** | Workstation setup & DNF optimizations | [**docs/fedora.md**](docs/fedora.md) |
| **Debian** | The Stable Foundation & External Repos | [**docs/debian.md**](docs/debian.md) |
| **Nix** | Reproducible package management | [**docs/nix.md**](docs/nix.md) |
| Homebrew | CLI tool manager for Linux | [**docs/homebrew.md**](docs/homebrew.md) |
| **Flatpak** | Sandboxed universal applications | [**docs/flatpak.md**](docs/flatpak.md) |
| **Snap** | Canonical's universal package manager | [**docs/snaps.md**](docs/snaps.md) |
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
<summary>Click to expand full resource list</summary>

### 📚 Essential Documentation
*   **Arch Wiki:** [wiki.archlinux.org](https://wiki.archlinux.org) - The most comprehensive Linux documentation on the planet.
*   **Gentoo Wiki:** [wiki.gentoo.org](https://wiki.gentoo.org) - Incredible depth for low-level system understanding.
*   **Debian Handbook:** [debian.org/doc/manuals/debian-handbook](https://www.debian.org/doc/manuals/debian-handbook/) - Foundation for all things APT and stable.
*   **Fedora Docs:** [docs.fedoraproject.org](https://docs.fedoraproject.org) - Official documentation for the Fedora ecosystem.
*   **NixOS Wiki:** [nixos.wiki](https://nixos.wiki) - Essential for understanding the declarative nature of Nix.
*   **Linux Journey:** [linuxjourney.com](https://linuxjourney.com) - The best place for beginners to start learning.
*   **The Linux Book:** [thelinuxbook.com](https://thelinuxbook.com) - A fantastic free resource for mastering the system.
*   **tldr.sh:** [tldr.sh](https://tldr.sh/) - Practical, example-based command usage.
*   **DigitalOcean Tutorials:** [digitalocean.com/community/tutorials](https://www.digitalocean.com/community/tutorials) - High-quality guides for servers and security.

### 📺 Content Creators (YouTube)
*   **Chris Titus Tech:** [youtube.com/@ChrisTitusTech](https://www.youtube.com/@ChrisTitusTech) - Practical guides and system optimization.
*   **The Linux Experiment:** [youtube.com/@TheLinuxExperiment](https://www.youtube.com/@TheLinuxExperiment) - Weekly news and desktop reviews.
*   **DistroTube:** [youtube.com/@DistroTube](https://www.youtube.com/@DistroTube) - TWMs, terminal workflows, and FOSS philosophy.
*   **Brodie Robertson:** [youtube.com/@BrodieRobertson](https://www.youtube.com/@BrodieRobertson) - Tech commentary and software deep-dives.
*   **Learn Linux TV:** [youtube.com/@LearnLinuxTV](https://www.youtube.com/@LearnLinuxTV) - Professional technical tutorials.
*   **Mental Outlaw:** [youtube.com/@MentalOutlaw](https://www.youtube.com/@MentalOutlaw) - Privacy and minimalism.
*   **Gardiner Bryant:** [youtube.com/@GardinerBryant](https://www.youtube.com/@GardinerBryant) - Linux gaming and hardware.
*   **Level1Techs:** [youtube.com/@Level1Techs](https://www.youtube.com/@Level1Techs) - High-end hardware and enterprise Linux.
*   **Linus Tech Tips:** [youtube.com/@LinusTechTips](https://www.youtube.com/@LinusTechTips) - See their "Linux Challenge" series.
*   **The Linux Cast:** [youtube.com/@TheLinuxCast](https://www.youtube.com/@TheLinuxCast) - Discussions on workflow and productivity.

### 📰 News & Blogs
*   **Phoronix:** [phoronix.com](https://www.phoronix.com) - The go-to source for Linux hardware benchmarks and kernel news.
*   **GamingOnLinux:** [gamingonlinux.com](https://www.gamingonlinux.com) - Keeping up with the massive strides in Linux gaming (Proton, Steam Deck).
*   **It's FOSS:** [itsfoss.com](https://itsfoss.com) - Great tutorials and high-level news.
*   **OMG! Ubuntu!:** [omgubuntu.co.uk](https://www.omgubuntu.co.uk) - Specifically for the Ubuntu and GNOME ecosystem.

### 💬 Community & Discussion
*   **r/linux:** [reddit.com/r/linux](https://www.reddit.com/r/linux/) - General Linux discussion.
*   **r/linux4noobs:** [reddit.com/r/linux4noobs](https://www.reddit.com/r/linux4noobs/) - Friendly beginner support.
*   **r/linuxquestions:** [reddit.com/r/linuxquestions](https://www.reddit.com/r/linuxquestions/) - Technical troubleshooting.
*   **r/linux_gaming:** [reddit.com/r/linux_gaming](https://www.reddit.com/r/linux_gaming/) - Gaming, Proton, and Wine.
*   **r/unixporn:** [reddit.com/r/unixporn](https://www.reddit.com/r/unixporn/) - Desktop customization inspiration.
*   **Arch Linux Forums:** [bbs.archlinux.org](https://bbs.archlinux.org/) - Where the real experts hang out.

### 🛠️ Software & Customization
*   **Awesome Linux Software:** [github.com/luong-komorebi/Awesome-Linux-Software](https://github.com/luong-komorebi/Awesome-Linux-Software) - A massive directory of apps.
*   **Awesome Linux Apps:** [github.com/cuongtk8/awesome-linux-apps](https://github.com/cuongtk8/awesome-linux-apps) - Curated modern applications.
*   **Awesome Self-Hosted:** [github.com/awesome-selfhosted/awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted) - Services you can run yourself.
*   **Privacy Guides:** [privacyguides.org](https://www.privacyguides.org) - Hardening your system for maximum privacy.
*   **Suckless.org:** [suckless.org](https://suckless.org) - Philosophy of minimalism and efficiency in software.
*   **Flathub:** [flathub.org](https://flathub.org) - The primary repository for Flatpak apps.
*   **Nerd Fonts:** [nerdfonts.com](https://www.nerdfonts.com) - Essential icons for your terminal and bar.

### 🎙️ Podcasts & Audio
*   **Linux Unplugged:** [linuxunplugged.com](https://linuxunplugged.com) - The most popular weekly Linux talk show.
*   **Late Night Linux:** [latenightlinux.com](https://latenightlinux.com) - Honest, humorous, and critical views on the ecosystem.
*   **Linux Action News:** [linuxactionnews.com](https://linuxactionnews.com) - Weekly summary of the most important news.
*   **Destination Linux:** [destinationlinux.net](https://destinationlinux.net) - Friendly, community-focused discussion.

### 🐚 Terminal & CLI Mastery
*   **Linux Command Library:** [linuxcommandlibrary.com](https://linuxcommandlibrary.com) - Comprehensive manual for CLI tools.
*   **ShellCheck:** [shellcheck.net](https://www.shellcheck.net) - A must-have tool for writing better bash scripts.
*   **Oh My Bash:** [ohmybash.nathaniel.land](https://ohmybash.nathaniel.land) - A framework for managing your Bash configuration.
*   **Oh My Zsh:** [ohmyz.sh](https://ohmyz.sh) - The most popular framework for Zsh.
*   **Powerlevel10k:** [github.com/romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k) - A fast and highly customizable Zsh theme.
*   **Fish Shell:** [fishshell.com](https://fishshell.com) - A smart and user-friendly shell that works out of the box.
*   **Oh My Fish:** [github.com/oh-my-fish/oh-my-fish](https://github.com/oh-my-fish/oh-my-fish) - Package manager for Fish shell.
*   **Starship:** [starship.rs](https://starship.rs) - The minimal, blazing-fast, and infinitely customizable prompt for any shell.
*   **Terminals Are Sexy:** [github.com/herrbischoff/awesome-terminals](https://github.com/herrbischoff/awesome-terminals) - A massive list of terminal emulators and tools.

### 🔧 Performance & Hardening
*   **Linux Kernel Archive:** [kernel.org](https://www.kernel.org) - Where it all begins.
*   **Arch Linux Security Advisories:** [security.archlinux.org](https://security.archlinux.org) - Keep your system safe.
*   **TLDP (The Linux Documentation Project):** [tldp.org](https://tldp.org) - Classic guides and HOWTOs for deep learning.

</details>
