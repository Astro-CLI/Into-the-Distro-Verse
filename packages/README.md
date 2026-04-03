# Package Management Guide

This directory contains the package lists and restoration scripts for various Linux distributions. Use these files to quickly replicate a software environment on a fresh installation.

---

## 📂 Package Lists

| List | Distribution | Source |
| :--- | :--- | :--- |
| **`arch_pkglist.txt`** | Arch Linux | Official Repos (`core`, `extra`) |
| **`arch_aur_list.txt`** | Arch Linux | AUR (via `paru`) |
| **`fedora_pkglist.txt`** | Fedora | Official DNF Repos |
| **`flatpak_list.txt`** | Universal | Flathub |

---

## 🚀 Restoration (How to install everything)

### Arch Linux
```bash
# 1. Install Official Packages
sudo pacman -S --needed - < packages/arch_pkglist.txt

# 2. Install AUR Packages
paru -S --needed - < packages/arch_aur_list.txt
```

### Universal (Flatpaks)
```bash
# Install Flatpaks on any system
xargs -a packages/flatpak_list.txt -r flatpak install -y
```

---

## 🔄 Maintenance & Syncing

To keep these lists updated with your current system configuration:

### Sync Arch Lists
```bash
pacman -Qqen > packages/arch_pkglist.txt
paru -Qqem > packages/arch_aur_list.txt
```

### Sync Universal Lists
```bash
flatpak list --app --columns=application > packages/flatpak_list.txt
```
