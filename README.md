<!-- 
    WIKI GUIDE: README.md
    This file contains my notes and setup steps. 
    Feel free to tweak it for your own distro! 
-->

### Into the Distro-Verse 🌌

My name is Ariel, and for the last few years, I've been the only Linux user in my neighborhood... maybe. I’ve learned that with great power comes great responsibility, especially when you’re dealing with a massive amount of configuration files. This is my attempt at a distro-agnostic guide for everyone, from beginners to power users. While I mostly use Arch, I truly believe that any user can benefit from these configurations, regardless of which distro they call home.

---

<!-- Section for specific setup/config steps -->
## 📘 Documentation Index

Detailed setup and maintenance guides organized by category. All items listed alphabetically within their category.

### 🐧 Operating Systems

| System | Description | Documentation |
| :--- | :--- | :--- |
| **Arch Linux** | Rolling-release environment & AUR setup | [docs/arch.md](docs/arch.md) |
| **Debian** | Stable-release environment & External repos | [docs/debian.md](docs/debian.md) |
| **Fedora** | Workstation environment & DNF optimizations | [docs/fedora.md](docs/fedora.md) |

### 📦 Package Managers & App Distribution

| System | Description | Documentation |
| :--- | :--- | :--- |
| **Flatpak** | Sandboxed universal applications | [docs/flatpak.md](docs/flatpak.md) |
| **Homebrew** | CLI tool manager for Linux | [docs/homebrew.md](docs/homebrew.md) |
| **Nix** | Reproducible package management | [docs/nix.md](docs/nix.md) |
| **Snap** | Canonical's universal package manager | [docs/snaps.md](docs/snaps.md) |

### 🎮 Virtualization & Emulation

| System | Description | Documentation |
| :--- | :--- | :--- |
| **Virtualization** | KVM/QEMU/Libvirt VM management | [docs/virtualization.md](docs/virtualization.md) |

### 🛡️ System Maintenance & Recovery

| System | Description | Documentation |
| :--- | :--- | :--- |
| **Snapshots** | System recovery with TimeShift/Snapper | [docs/snapshots.md](docs/snapshots.md) |
| **Timeshift I/O Optimization** | Fixing snapshot-related freezes & performance | [docs/timeshift-io-optimization.md](docs/timeshift-io-optimization.md) |

### 🌐 Networking & Hosting

| System | Description | Documentation |
| :--- | :--- | :--- |
| **Tor + Apache & Docker** | Anonymous website hosting with Apache & Docker | [docs/apache-tor-docker.md](docs/apache-tor-docker.md) |
| **Tor Hidden Service (Arch)** | Anonymous website hosting with Nginx (native) | [docs/tor-hidden-service-arch.md](docs/tor-hidden-service-arch.md) |

### 🎨 Creative & Media

| System | Description | Documentation |
| :--- | :--- | :--- |
| **Audio & Video** | Pro-audio, streaming, DAWs & OBS setup | [docs/audio-video.md](docs/audio-video.md) |
| **Music Streaming** | Music streaming without ads setup | [docs/streaming/music.md](docs/streaming/music.md) |
| **Streaming Services** | Complete streaming setup guide | [docs/streaming/README.md](docs/streaming/) |
| **Video Streaming** | Video streaming without ads setup | [docs/streaming/video.md](docs/streaming/video.md) |

### 🤖 AI & Intelligence

| System | Description | Documentation |
| :--- | :--- | :--- |
| **Local AI & LLM** | Self-hosted Ollama & Agentic Interpreters | [docs/local-ai.md](docs/local-ai.md) |

### 🐚 Shell Configuration

| Shell | Description | Documentation |
| :--- | :--- | :--- |
| **Bash** | Fallback shell with readline and modern tools | [docs/guides/shells/bash.md](docs/guides/shells/bash.md) |
| **Fish** | User-friendly shell with native features | [docs/guides/shells/fish.md](docs/guides/shells/fish.md) |
| **Shell Configs** | Backup and restore all shell configs (zsh, bash, fish, starship) | [configs/shells/README.md](configs/shells/README.md) |
| **ZSH** | Complete setup with Oh My Zsh and modern tools | [docs/guides/shells/zsh.md](docs/guides/shells/zsh.md) |

### ♿ Accessibility & Usability

| System | Description | Documentation |
| :--- | :--- | :--- |
| **Text-to-Speech** | High-quality neural TTS with Piper | [docs/accessibility-tts.md](docs/accessibility-tts.md) |

### 🛡️ Security & System Utilities

| System | Description | Documentation |
| :--- | :--- | :--- |
| **File Sync Guide** | File synchronization and backup strategies | [docs/file-sync-guide.md](docs/file-sync-guide.md) |
| **Security & Hardening** | AppArmor, UFW, ClamAV, encrypted DNS setup | [docs/security.md](docs/security.md) |
| **System Maintenance** | Routine system maintenance and optimization | [docs/system_maintenance.md](docs/system_maintenance.md) |
| **Wayland Security** | Wayland security considerations and fixes | [docs/wayland-privilege-escalation.md](docs/wayland-privilege-escalation.md) |

### ⚙️ Environment Configuration

| Configuration | Description | Documentation |
| :--- | :--- | :--- |
| **GRUB Bootloader** | Visual customization for the GRUB bootloader | [configs/grub/README.md](configs/grub/README.md) |
| **KDE Plasma** | Restore KDE Plasma layout, shortcuts, and themes | [configs/kde/README.md](configs/kde/README.md) |
| **Shell Configs** | Backup and restore all shell configs (zsh, bash, fish, starship) | [configs/shells/README.md](configs/shells/README.md) |

### 📋 Reference & Resources

| Resource | Description | Documentation |
| :--- | :--- | :--- |
| **License** | Project license information | [docs/legal/licence.md](docs/legal/licence.md) |
| **Packages** | List of installed applications and restoration guide | [packages/README.md](packages/README.md) |

---

<!-- Section for specific setup/config steps -->
## 📦 Software & Repositories

The `packages/` directory contains text files listing all installed applications. These are used to quickly restore software on a fresh installation.

### System Restoration

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Astro-CLI/Into-the-Distro-Verse.git
   cd Into-the-Distro-Verse
   ```

2. **Follow the Guide:**
   See **[Package Management Guide](packages/README.md)** for restoration commands.

---

<!-- Section for specific setup/config steps -->
## 🛡️ System Hardening & Integrity

Guides for securing and maintaining the integrity of a Linux system.

- **Network & Security:** Setup for AppArmor, UFW Firewall, ClamAV, and encrypted DNS (DoT). [**docs/security.md**](docs/security.md)
- **System Integrity:** Instructions for BTRFS health checks and automated snapshots. [**docs/snapshots.md**](docs/snapshots.md)

---

<!-- Section for specific setup/config steps -->
## 🕸️ The Ultimate Linux Resource List

A curated collection of documentation, communities, and tools for mastering Linux.

<details>
<summary>Click to expand full resource list</summary>

<!-- Quick sub-note for this part -->
### 📚 Essential Documentation
*   **Arch Wiki:** [wiki.archlinux.org](https://wiki.archlinux.org) - The most comprehensive Linux documentation on the planet.
*   **Fedora Docs:** [docs.fedoraproject.org](https://docs.fedoraproject.org) - Official documentation for the Fedora ecosystem.
*   **Linux Journey:** [linuxjourney.com](https://linuxjourney.com) - The best place for beginners to start learning.
*   **Kernel.org Docs:** [docs.kernel.org](https://www.kernel.org/doc/html/latest/) - The "source of truth" for the Linux kernel itself.
*   **TLDP (The Linux Documentation Project):** [tldp.org](https://tldp.org) - Classic guides and deep-dive HOWTOs.
*   **Arch Linux Security Advisories:** [security.archlinux.org](https://security.archlinux.org) - Track vulnerabilities across the Arch ecosystem.
*   **NixOS Wiki:** [nixos.wiki](https://nixos.wiki) - Essential for understanding declarative system management.
*   **DigitalOcean Tutorials:** [digitalocean.com/community/tutorials](https://www.digitalocean.com/community/tutorials) - High-quality guides for servers and security.
*   **tldr.sh:** [tldr.sh](https://tldr.sh/) - Practical, example-based command usage.

<!-- Quick sub-note for this part -->
### 📺 Content Creators (YouTube)
*   **Chris Titus Tech:** [youtube.com/@ChrisTitusTech](https://www.youtube.com/@ChrisTitusTech) - Practical guides and system optimization.
*   **The Linux Experiment:** [youtube.com/@TheLinuxExperiment](https://www.youtube.com/@TheLinuxExperiment) - Weekly news and desktop reviews.
*   **Learn Linux TV:** [youtube.com/@LearnLinuxTV](https://www.youtube.com/@LearnLinuxTV) - Deep technical tutorials and certifications.
*   **Brodie Robertson:** [youtube.com/@BrodieRobertson](https://www.youtube.com/@BrodieRobertson) - Tech commentary and software deep-dives.
*   **DistroTube:** [youtube.com/@DistroTube](https://www.youtube.com/@DistroTube) - TWMs, terminal workflows, and FOSS philosophy.
*   **Mental Outlaw:** [youtube.com/@MentalOutlaw](https://www.youtube.com/@MentalOutlaw) - Privacy, security, and minimalism.
*   **Gardiner Bryant:** [youtube.com/@GardinerBryant](https://www.youtube.com/@GardinerBryant) - Linux gaming and hardware.
*   **Level1Techs:** [youtube.com/@Level1Techs](https://www.youtube.com/@Level1Techs) - High-end hardware and enterprise Linux.
*   **The Linux Cast:** [youtube.com/@TheLinuxCast](https://www.youtube.com/@TheLinuxCast) - Workflow and productivity discussions.

<!-- Quick sub-note for this part -->
### 📰 News & Blogs
*   **Phoronix:** [phoronix.com](https://www.phoronix.com) - The go-to source for Linux hardware benchmarks and kernel news.
*   **GamingOnLinux:** [gamingonlinux.com](https://www.gamingonlinux.com) - The definitive source for Linux gaming news (Proton, Steam Deck).
*   **It's FOSS:** [itsfoss.com](https://itsfoss.com) - Beginner-friendly tutorials and high-level news.
*   **OMG! Ubuntu!:** [omgubuntu.co.uk](https://www.omgubuntu.co.uk) - News specifically for the Ubuntu and GNOME ecosystem.
*   **9to5Linux:** [9to5linux.com](https://9to5linux.com/) - Daily Linux news and release announcements.

<!-- Quick sub-note for this part -->
### 💬 Community & Discussion
*   **r/linux:** [reddit.com/r/linux](https://www.reddit.com/r/linux/) - General Linux discussion.
*   **r/unixporn:** [reddit.com/r/unixporn](https://www.reddit.com/r/unixporn/) - Desktop customization and "ricing" inspiration.
*   **r/linux_gaming:** [reddit.com/r/linux_gaming](https://www.reddit.com/r/linux_gaming/) - Gaming, Proton, and Wine discussions.
*   **Arch Linux Forums:** [bbs.archlinux.org](https://bbs.archlinux.org/) - Technical discussions with the experts.
*   **Fosstodon:** [fosstodon.org](https://fosstodon.org/) - The most active FOSS-focused Mastodon instance.

<!-- Quick sub-note for this part -->
### 🛠️ Software & Customization
*   **Awesome Linux Software:** [github.com/luong-komorebi/Awesome-Linux-Software](https://github.com/luong-komorebi/Awesome-Linux-Software) - A massive directory of Linux apps.
*   **Privacy Guides:** [privacyguides.org](https://www.privacyguides.org) - Hardening your system and choosing secure software.
*   **Suckless.org:** [suckless.org](https://suckless.org) - Philosophy of minimalism and efficiency in software.
*   **Flathub:** [flathub.org](https://flathub.org) - The primary repository for Flatpak apps.
*   **ProtonDB:** [protondb.com](https://www.protondb.com/) - Check how well your Steam games run on Linux.
*   **Nerd Fonts:** [nerdfonts.com](https://www.nerdfonts.com) - Essential icons for your terminal and status bars.

<!-- Quick sub-note for this part -->
### 🐚 Terminal & CLI Mastery
*   **Starship:** [starship.rs](https://starship.rs) - The minimal, blazing-fast, and infinitely customizable prompt.
*   **ShellCheck:** [shellcheck.net](https://www.shellcheck.net) - A must-have tool for writing better bash scripts.
*   **Oh My Zsh:** [ohmyz.sh](https://ohmyz.sh) - The most popular framework for Zsh.
*   **Powerlevel10k:** [github.com/romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k) - A fast and highly customizable Zsh theme.
*   **Fish Shell:** [fishshell.com](https://fishshell.com) - A smart and user-friendly shell that works out of the box.

<!-- Quick sub-note for this part -->
### 🎙️ Podcasts & Audio
*   **Linux Unplugged:** [linuxunplugged.com](https://linuxunplugged.com) - The most popular weekly Linux talk show.
*   **Late Night Linux:** [latenightlinux.com](https://latenightlinux.com) - Honest and humorous views on the ecosystem.
*   **Linux Action News:** [linuxactionnews.com](https://linuxactionnews.com) - Weekly summary of the most important news.
*   **Destination Linux:** [destinationlinux.net](https://destinationlinux.net) - Friendly, community-focused discussion.

</details>


<!-- 
    TIP: If you're using Neovim, you can use 
    :set wrap to make this easier to read! 
-->