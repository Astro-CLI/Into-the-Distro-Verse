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
| **Snapshots** | The System Safety Net | [**docs/snapshots.md**](docs/snapshots.md) |

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

A collection of the best documentation, creators, and communities in the Linux ecosystem.

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
