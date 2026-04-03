# Arch Linux: The Power-User's Starship 🚀

This guide covers the specific steps to set up and maintain the Arch Linux dimension of your Distro-Verse.

---

## 🚀 1. Essential Setup: The Launchpad

### Install AUR Helper (`paru`)
Paru is a modern AUR helper written in Rust. It's the primary way to access the vast library of community packages.
```bash
sudo pacman -S --needed base-devel git && \
git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si && cd .. && rm -rf paru
```

### Snapshot Management (BTRFS)
BTRFS snapshots are your "safety net." Always set this up before doing major system tweaks.
*   **TimeShift (Recommended):** `paru -S timeshift timeshift-autosnap`
*   **Snapper (Alternative):** `paru -S snapper snap-pac`

### Bootloader Integration
Ensure you can boot into your snapshots if the system fails to start.
*   **GRUB:** `paru -S grub-btrfs && sudo systemctl enable --now grub-btrfsd`
*   **systemd-boot:** Use `gummibbs` (AUR) to generate snapshot entries.

---

## 📦 2. Package Management

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
