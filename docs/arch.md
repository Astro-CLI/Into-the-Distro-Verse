# Arch Linux: The Power-User's Starship 🚀

This guide covers the specific steps to set up and maintain the Arch Linux dimension of your Distro-Verse.

---

## 🚀 1. Essential Setup: The Launchpad

### Pacman Optimizations (The "Nice" Tweaks)
Before installing packages, make `pacman` faster and more visual.
1.  Edit the config: `sudo nano /etc/pacman.conf`
2.  Uncomment or add these lines under `[options]`:
    ```text
    Color
    ILoveCandy
    ParallelDownloads = 10
    ```
    *(ILoveCandy adds a Pac-Man eating pellets to your progress bars!)*

### Mirror Management (Reflector)
Arch mirrors can get slow or outdated. `reflector` automatically finds the fastest ones for you.
```bash
sudo pacman -S reflector
# Update mirrors to the 10 fastest HTTPS ones in your region
sudo reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```

### Install AUR Helper (`paru`)
Paru is a modern AUR helper written in Rust. It's the primary way to access the vast library of community packages.
```bash
sudo pacman -S --needed base-devel git && \
git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si && cd .. && rm -rf paru
```

---

## 📦 2. Snapshot & Maintenance

### Snapshot Management (BTRFS)
BTRFS snapshots are your "safety net." Always set this up before doing major system tweaks.
*   **TimeShift (Recommended):** `paru -S timeshift timeshift-autosnap`
*   **Snapper (Alternative):** `paru -S snapper snap-pac`

### BTRFS Maintenance
If you're using BTRFS, you should run these occasionally to keep the filesystem healthy.
```bash
# Scrub: Check for data corruption
sudo btrfs scrub start /

# Balance: Free up unused chunks
sudo btrfs balance start -dusage=50 /
```

### Bootloader Integration
Ensure you can boot into your snapshots if the system fails to start.
*   **GRUB:** `paru -S grub-btrfs && sudo systemctl enable --now grub-btrfsd`
*   **systemd-boot:** Use `gummibbs` (AUR) to generate snapshot entries.

---

## 📦 3. Package Management

| List | Content |
| :--- | :--- |
| **`arch_pkglist.txt`** | Official native packages. |
| **`arch_aur_list.txt`** | AUR packages (via `paru`). |

### Restore your system:
```bash
# Official packages
sudo pacman -S --needed - < packages/arch_pkglist.txt

# AUR packages
paru -S --needed - < packages/arch_aur_list.txt
```

### Universal Packages (Flatpak)
For a comprehensive guide on managing Flatpaks, permissions, and Flathub, see the universal guide:

*   📖 **[docs/flatpak.md](flatpak.md)**

---

## 🛠️ 3. Maintenance

### Clear Pacman Cache
```bash
sudo pacman -Sc
```

### Find and Remove Orphans
```bash
pacman -Qtdq
sudo pacman -Rns $(pacman -Qtdq)
```
