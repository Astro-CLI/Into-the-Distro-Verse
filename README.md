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
    The `kde` directory contains backups of key Plasma configuration files. See the `kde/README.md` for detailed instructions on how to restore your desktop look and feel.

---

## Repository Structure

-   `README.md`: This main guide.
-   `packages/`: Contains lists of installed packages from Pacman, the AUR, and Flatpak. See the `packages/README.md` for more info.
-   `kde/`: Contains backed-up configuration files for KDE Plasma. See the `kde/README.md` for restoration instructions.
-   `.gitignore`: Specifies files and directories to be ignored by Git.

---

## Part 1: Application Management

The `packages` directory contains text files listing every application installed on the system, separated by source (official repositories, AUR, and Flatpak).

For detailed instructions on how to use these lists to regenerate them or to provision a new machine, please see the **[packages/README.md](packages/README.md)** file.

---

## Part 2: KDE Plasma Configuration

This repository stores key KDE Plasma configuration files in the `kde` directory. This allows for a quick and easy way to restore your desktop's appearance, settings, and terminal profiles on a new installation.

The old method of using a bare git repository for dotfiles has been deprecated in favor of this more explicit and organized approach.

For detailed instructions on how to restore your Plasma environment, please see the **[kde/README.md](kde/README.md)** file.

---

## Part 3: Extra Arch Linux Tips

Here are some useful commands and tips for maintaining a healthy Arch Linux system.

-   **Update Your System:**
    Always keep your system up-to-date to get the latest security patches and features.
    ```bash
    sudo pacman -Syu
    ```

-   **Clean Pacman Cache:**
    Over time, the pacman cache can grow large. You can safely remove all cached packages that are not currently installed.
    ```bash
    sudo pacman -Sc
    ```
    To remove all cached packages, including for installed packages (which will be re-downloaded if you ever need to reinstall them), use:
    ```bash
    sudo pacman -Scc
    ```

-   **Find Orphaned Packages:**
    Orphaned packages are dependencies that were installed for another package but are no longer needed. You can list them with:
    ```bash
    pacman -Qtdq
    ```
    And remove them with:
    ```bash
    sudo pacman -Rns $(pacman -Qtdq)
    ```

-   **Check for Failed Services:**
    Quickly see if any systemd services have failed to start.
    ```bash
    systemctl --failed
    ```

---

## Part 4: General System Tools & Services

This section contains useful tools and services for any Arch Linux installation, desktop or laptop.

### Managing Services with `systemctl-tui`

`systemctl-tui` provides a user-friendly terminal interface for managing systemd services. It's much easier than typing `systemctl` commands manually.

- **Installation:**
    ```bash
    paru -S systemctl-tui
    ```

### Enabling Bluetooth

To use Bluetooth devices, you need to enable the `bluetooth.service`.

```bash
# To enable (start on boot) and start the service now:
sudo systemctl enable --now bluetooth.service
```

---

## Part 5: Bootloader Information

Understanding your bootloader is crucial for system management, especially when dealing with kernel updates, hibernation, and advanced configurations.

### GRUB vs systemd-boot

**GRUB (GRand Unified Bootloader)**
- Traditional, feature-rich bootloader
- Supports BIOS and UEFI systems
- Highly configurable with themes and advanced options
- Configuration in `/etc/default/grub` and `/etc/grub.d/`
- Update with: `sudo grub-mkconfig -o /boot/grub/grub.cfg`

**systemd-boot**
- Lightweight, UEFI-only bootloader
- Part of the systemd project
- Simpler configuration with text files
- Configuration in `/boot/loader/` and `/boot/loader/entries/`
- Update with: `sudo bootctl update`
- Entries are typically auto-managed or created manually

### Determining Your Bootloader

```bash
# Check if you're using GRUB
ls /boot/grub/grub.cfg

# Check if you're using systemd-boot
bootctl status
```

### When to Choose Each

**Choose GRUB if:**
- You have BIOS/Legacy systems
- You need advanced boot options or themes
- You're dual-booting with Windows (easier setup)

**Choose systemd-boot if:**
- You have a UEFI-only setup
- You prefer simplicity and faster boot times
- You want systemd integration

---

## Part 6: Advanced Customization

This section covers more advanced topics that can significantly change how your system behaves.

### Trying an Alternative Kernel (Linux-Zen)

The Zen kernel is tuned for better desktop responsiveness and performance. It's a popular choice for gaming, compiling, or heavy multitasking.

1.  **Installation:**
    ```bash
    sudo pacman -S linux-zen linux-zen-headers
    ```

2.  **Update Your Bootloader:** After installation, you must update your bootloader to "see" the new kernel.

    **For GRUB:**
    ```bash
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ```

    **For systemd-boot:**
    ```bash
    sudo bootctl update
    ```
    The kernel entries are usually auto-detected, but you may need to copy or create new entries in `/boot/loader/entries/`.

3.  **Reboot:** You can now choose the Zen kernel from your boot menu.

### Replacing Core Utilities with `uutils`

`uutils` is a project to rewrite the standard GNU core utilities (`ls`, `cp`, `mv`, etc.) in Rust, focusing on safety and performance. This is a significant change and should be approached with caution.

- **To Learn More:** See the project's [GitHub page](https://github.com/uutils/coreutils).

---

## Part 7: Exploring Graphical Interfaces

While you are using KDE Plasma, Arch Linux allows you to install and switch between many different graphical interfaces. Here are some popular choices.

### Desktop Environments (DEs)

A DE provides a complete, integrated graphical experience, including a window manager, panels, system settings, file manager, and more.

-   **KDE Plasma:** ([kde.org](https://kde.org/plasma-desktop)) What you are currently using. Known for its extreme customizability and rich feature set.
-   **GNOME:** ([gnome.org](https://www.gnome.org)) A modern, workflow-focused desktop that provides a very different experience from traditional desktops.
-   **COSMIC:** ([system76.com/cosmic](https://system76.com/cosmic)) A new, Rust-based desktop environment being developed by System76 (the makers of Pop!_OS).

### Tiling Window Managers (WMs)

For users who prefer keyboard-driven workflows and maximum screen real estate, tiling WMs automatically arrange windows in non-overlapping tiles. They are highly configurable but require more manual setup than a full DE.

-   **Hyprland:** ([hyprland.org](https://hyprland.org)) A dynamic, Wayland-native tiling compositor known for its smooth animations and visual flair.
-   **Sway:** ([swaywm.org](https://swaywm.org)) A Wayland-native, drop-in replacement for the i3 window manager, making it a popular choice for those familiar with i3.

---

## Part 8: The Ultimate Laptop Guide

This section contains configurations specifically for laptops to improve battery life and convenience.

### Power Management & CPU Scaling

- **`auto-cpufreq` (Recommended):** An automatic CPU optimizer. Install from the AUR (`paru -S auto-cpufreq`) and enable the service (`sudo systemctl enable --now auto-cpufreq.service`).
- **`TLP`:** A more comprehensive power management tool. Install from the official repos (`sudo pacman -S tlp`) and enable the service (`sudo systemctl enable --now tlp.service`).

> **Note:** Use **either** `auto-cpufreq` **or** `TLP`, not both.

### Hibernation (Save to Disk)

Hibernation saves your session to disk and powers off the machine. It requires a swap file or partition and proper bootloader configuration.

#### Setting Up Swap

**Option 1: Using systemd-swap (Recommended for beginners)**
1. Install from AUR: `paru -S systemd-swap`
2. Enable the service: `sudo systemctl enable --now systemd-swap.service`
3. Edit `/etc/systemd/swap.conf` and ensure `swapfc_enabled=1`

**Option 2: Manual swap file creation**
1. Create a swap file (adjust size as needed - typically equal to RAM):
   ```bash
   sudo dd if=/dev/zero of=/swapfile bs=1M count=8192 status=progress
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   ```
2. Add to `/etc/fstab`:
   ```bash
   echo '/swapfile none swap defaults 0 0' | sudo tee -a /fstab
   ```

**Option 3: Dedicated swap partition**
- Use a tool like `cfdisk` or `gparted` to create a swap partition
- Format it: `sudo mkswap /dev/sdXY`
- Enable it: `sudo swapon /dev/sdXY`
- Add to `/etc/fstab`: `/dev/sdXY none swap defaults 0 0`

#### Configure the Bootloader

**For GRUB:**
1. Find your swap UUID:
   ```bash
   sudo findmnt -no UUID -T /swapfile  # For swap file
   # OR for swap partition:
   lsblk -f | grep swap
   ```
2. For swap file, also get the offset:
   ```bash
   sudo filefrag -v /swapfile | awk '{if($1=="0:"){print substr($4, 1, length($4)-2)}}'
   ```
3. Edit `/etc/default/grub` and add to `GRUB_CMDLINE_LINUX_DEFAULT`:
   ```bash
   # For swap file:
   resume=UUID=<root-uuid> resume_offset=<offset>
   # For swap partition:
   resume=UUID=<swap-uuid>
   ```
4. Regenerate GRUB config:
   ```bash
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```

**For systemd-boot:**
1. Find your swap information (same commands as above)
2. Edit your boot entries in `/boot/loader/entries/` (e.g., `arch.conf`):
   ```
   # For swap file:
   options root=UUID=<root-uuid> resume=UUID=<root-uuid> resume_offset=<offset> rw
   # For swap partition:
   options root=UUID=<root-uuid> resume=UUID=<swap-uuid> rw
   ```

#### Enable Hibernation Services

1. Add the `resume` hook to `/etc/mkinitcpio.conf`:
   ```bash
   HOOKS=(... block filesystems resume fsck)
   ```
2. Regenerate initramfs:
   ```bash
   sudo mkinitcpio -P
   ```
3. Test hibernation:
   ```bash
   systemctl hibernate
   ```

#### Swap Size Considerations

- **For hibernation:** Swap should be at least equal to your RAM size
- **For systems with 16GB+ RAM:** You can use smaller swap (4-8GB) if hibernation isn't critical
- **For systems with limited disk space:** Consider using a swap partition on a separate drive
- **SSD users:** Swap files/partitions on SSDs are fine for modern drives with wear leveling

#### Troubleshooting Hibernation

**Common Issues:**
- **"No resume device found":** Check that resume UUID/offset is correct in bootloader config
- **System hangs during hibernation:** Disable problematic modules in `/etc/modprobe.d/`
- **Hibernation works but resume fails:** Verify the `resume` hook is properly positioned in mkinitcpio.conf
- **Swap not detected:** Run `swapon --show` to verify swap is active

**Testing hibernation safely:**
1. Save all work and close applications
2. Test with: `sudo systemctl hibernate`
3. If it fails to resume, you can still boot normally

**Useful commands:**
```bash
# Check current swap usage
swapon --show
free -h

# Monitor hibernation logs
journalctl -b -u systemd-hibernate
```

> **Note:** Always test hibernation thoroughly before relying on it. Some hardware/drivers may have compatibility issues.

---

## Part 9: The Ultimate Resource List

Here is a comprehensive list of official sites, documentation, and community resources related to your setup.

### Core System & Desktop
*   **Arch Linux:** [archlinux.org](https://archlinux.org)
*   **Arch Wiki:** [wiki.archlinux.org](https://wiki.archlinux.org)
*   **KDE Plasma:** [kde.org/plasma-desktop](https://kde.org/plasma-desktop)

### Shell & Prompt
*   **Zsh:** [zsh.org](https://www.zsh.org)
*   **Oh My Zsh:** [ohmyz.sh](https://ohmyz.sh)
*   **Powerlevel10k:** [github.com/romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k) - Your current prompt.
*   **Starship:** [starship.rs](https://starship.rs) - A popular, fast, cross-shell prompt written in Rust.

### Modern Command-Line Tools

#### File & Directory Management
*   **eza:** [github.com/eza-community/eza](https://github.com/eza-community/eza) - A modern replacement for `ls` (maintained fork of `exa`).
*   **zoxide:** [github.com/ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide) - A smarter `cd` command that learns your habits.
*   **broot:** [github.com/Canop/broot](https://github.com/Canop/broot) - An interactive tree-view file navigator.
*   **dust:** [github.com/bootandy/dust](https://github.com/bootandy/dust) - A more intuitive `du` replacement for checking disk usage.
*   **duf:** [github.com/muesli/duf](https://github.com/muesli/duf) - A better `df` replacement for checking free disk space.

#### Text Processing & Viewing
*   **bat:** [github.com/sharkdp/bat](https://github.com/sharkdp/bat) - A `cat` clone with syntax highlighting and Git integration.
*   **ripgrep (`rg`):** [github.com/BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep) - An extremely fast replacement for `grep`.
*   **fd:** [github.com/sharkdp/fd](https://github.com/sharkdp/fd) - A simple and fast replacement for `find`.
*   **sd:** [github.com/chmln/sd](https://github.com/chmln/sd) - An intuitive find & replace tool, as an alternative to `sed`.

#### System & Process Monitoring
*   **btop:** [github.com/aristocratos/btop](https://github.com/aristocratos/btop) - A beautiful and resource-rich system monitor.
*   **procs:** [github.com/dalance/procs](https://github.com/dalance/procs) - A modern replacement for `ps` with a tree-view and more info.
*   **gping:** [github.com/orf/gping](https://github.com/orf/gping) - A version of `ping` that includes a graph in the terminal.

#### Git & Development
*   **gitui:** [github.com/gitui-org/gitui](https://github.com/gitui-org/gitui) - A blazing fast terminal UI for Git written in Rust. Provides the comfort of a Git GUI right in your terminal with keyboard-only control, staging, committing, stashing, branching, and log browsing.
*   **git-delta:** [github.com/dandavison/delta](https://github.com/dandavison/delta) - A syntax-highlighting pager for `git diff` and `git log`.
*   **lazygit:** [github.com/jesseduffield/lazygit](https://github.com/jesseduffield/lazygit) - A terminal UI for Git that makes common operations much faster.
*   **GitHub CLI (`gh`):** [cli.github.com](https://cli.github.com) - The official command-line tool for interacting with GitHub.

### Editors & IDEs
*   **Neovim:** [neovim.io](https://neovim.io)
*   **AstroNvim:** [astronvim.com](https://astronvim.com) - A popular, pre-configured distribution for Neovim.
*   **Zed:** [zed.dev](https://zed.dev)

### Web Browsers
*   **Brave Browser:** [brave.com](https://brave.com)
*   **Tor Browser:** [torproject.org](https://www.torproject.org)
*   **Zen Browser:** [zen-browser.app](https://zen-browser.app)

### Community & Inspiration
*   **Chris Titus Tech:** [christitus.com](https://christitus.com/)
*   **DistroTube:** [distro.tube](https://distro.tube/)
*   **Brodie Robertson:** [brodierobertson.xyz](https://brodierobertson.xyz/)
*   **/r/unixporn:** [reddit.com/r/unixporn](https://www.reddit.com/r/unixporn/)
*   **Awesome Lists:** [github.com/sindresorhus/awesome](https://github.com/sindresorhus/awesome) - A massive collection of "awesome" lists for all sorts of topics.