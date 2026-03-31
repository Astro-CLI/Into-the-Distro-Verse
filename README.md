# My Arch Linux Setup: A Personal Wiki & Manual Guide

Welcome to my personal Arch Linux setup repository! This project serves as a comprehensive, manually-curated backup of my desktop environment, including package lists, configurations, and a wealth of information for setting up a new system from scratch.

---

## 🚀 Fresh Install: Safety First

Follow these steps in order on a fresh Arch installation to set up a robust, auto-backing-up system.

### 1. Install AUR Helper (`paru`)
First, get the essential build tools and install `paru`.
```bash
sudo pacman -S --needed base-devel git && \
git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si && cd .. && rm -rf paru
```

### 2. Set Up Snapshot Management
Choose a tool to capture system states. **TimeShift is recommended** for its ease of use and GUI.

*   **Option A: TimeShift (Recommended)**
    Great for desktop users. `autosnap` ensures a backup is made before every `pacman` transaction.
    ```bash
    paru -S timeshift timeshift-autosnap
    ```
*   **Option B: Snapper (Alternative)**
    Powerful and CLI-focused.
    ```bash
    paru -S snapper snap-pac
    ```

### 3. Integrate with Bootloader
This allows you to boot directly into a previous snapshot from your boot menu if the system fails to start.

*   **Option A: GRUB (Recommended for Snapshots)**
    The most automated way to handle BTRFS snapshots. `grub-btrfs` automatically adds snapshots to your boot menu.
    ```bash
    paru -S grub-btrfs && sudo systemctl enable --now grub-btrfsd
    ```
*   **Option B: systemd-boot**
    A simpler, modern bootloader. While faster, it does **not** natively support booting into BTRFS snapshots as easily as GRUB. 
    *   **Reference Tool**: For a `grub-btrfs` experience, use `gummibbs` (AUR). It automatically generates boot entries for your snapshots.
    *   **Command**: `paru -S gummibbs`

> **Note:** After installation, open the **TimeShift** application from your app menu (GUI) or run `sudo timeshift --wizard` to select your BTRFS drive and set your backup frequency.

---

## How to Use This Repository

If you're setting up a new machine, follow these steps to replicate this environment:

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Astro-CLI/My_Linux_Setup.git
    cd My_Linux_Setup
    ```

2.  **Install Applications:**
    The `packages` directory contains lists of all installed applications. You can use them to quickly set up a new system. See the `packages/README.md` for detailed instructions.
    ```bash
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

## Part 3: System Maintenance & Security

Understanding how to maintain and recover your system is crucial. 

-   **Backups (TimeShift, BTRFS, GRUB)**: See **[docs/system_maintenance.md](docs/system_maintenance.md)**.
-   **Security (AppArmor, SELinux)**: See **[docs/security.md](docs/security.md)**.

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

## Part 5: The Ultimate Linux Resource List

A collection of the best documentation, creators, and communities in the Linux ecosystem.

### 📚 Essential Documentation
*   **Arch Wiki:** [wiki.archlinux.org](https://wiki.archlinux.org) - The most comprehensive Linux documentation on the planet.
*   **Gentoo Wiki:** [wiki.gentoo.org](https://wiki.gentoo.org) - Incredible depth for low-level system understanding.
*   **Debian Handbook:** [debian.org/doc/manuals/debian-handbook](https://www.debian.org/doc/manuals/debian-handbook/) - Foundation for all things APT and stable.
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
*   **Oh My Zsh:** [ohmyz.sh](https://ohmyz.sh) - The framework for managing your Zsh configuration.
*   **Terminals Are Sexy:** [github.com/herrbischoff/awesome-terminals](https://github.com/herrbischoff/awesome-terminals) - A massive list of terminal emulators and tools.

### 🔧 Performance & Hardening
*   **Linux Kernel Archive:** [kernel.org](https://www.kernel.org) - Where it all begins.
*   **Arch Linux Security Advisories:** [security.archlinux.org](https://security.archlinux.org) - Keep your system safe.
*   **TLDP (The Linux Documentation Project):** [tldp.org](https://tldp.org) - Classic guides and HOWTOs for deep learning.
