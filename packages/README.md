# Package Management Guide

This directory houses the blueprints for your system's software across different Linux dimensions.

---

## 📂 Dimension-Specific Lists

| List | Dimension | Source |
| :--- | :--- | :--- |
| **`arch_pkglist.txt`** | Arch Linux | Official Repos (`core`, `extra`) |
| **`arch_aur_list.txt`** | Arch Linux | AUR (via `paru`) |
| **`fedora_pkglist.txt`** | Fedora | Official DNF Repos |
| **`flatpak_list.txt`** | Universal | Flathub |

---

## 🚀 Restoration (How to install everything)

### For the Arch Dimension:
```bash
# 1. Install Official Packages
sudo pacman -S --needed - < packages/arch_pkglist.txt

# 2. Install AUR Packages
paru -S --needed - < packages/arch_aur_list.txt
```

### For the Universal Dimension (Flatpaks):
```bash
# Install Flatpaks on any system
xargs -a packages/flatpak_list.txt -r flatpak install -y
```

---

## 🔄 Maintenance & Syncing

To keep these lists updated with your current machine's configuration:

### Sync Arch Lists
```bash
pacman -Qqen > packages/arch_pkglist.txt
paru -Qqem > packages/arch_aur_list.txt
```

### Sync Universal Lists
```bash
flatpak list --app --columns=application > packages/flatpak_list.txt
```
