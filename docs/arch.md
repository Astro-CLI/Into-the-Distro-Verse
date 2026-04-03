# Arch Linux Setup & Maintenance Guide 🚀

This guide covers the specific steps to set up and maintain an Arch Linux environment.

---

## 🚀 1. Essential Setup

### Pacman Optimizations (Quality of Life)
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

## 🛡️ 2. Snapshots & Maintenance

BTRFS snapshots are an essential "safety net" for system stability. For a comprehensive guide on setting up **TimeShift**, **Snapper**, and bootloader integration, see the universal guide:

*   📖 **[docs/snapshots.md](snapshots.md)**

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
