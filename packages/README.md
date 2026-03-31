# Package Management Guide

This directory houses the blueprints for your system's software. By tracking these lists, you can replicate your entire workspace on any machine in minutes.

---

## 📂 Which list should I use?

| List | Source | Best For... |
| :--- | :--- | :--- |
| **`pkglist.txt`** | Official Repos (`core`, `extra`) | System essentials, drivers, and standard tools. |
| **`aur_pkglist.txt`** | AUR (via `paru`) | Cutting-edge software, fonts, and niche tools (e.g., `zen-browser`). |
| **`flatpak_list.txt`** | Flathub | Proprietary apps or software you want isolated (e.g., `Discord`, `Spotify`). |

---

## 🚀 Restoration (How to install everything)

Once you have `paru` installed (see the main `README.md` for the quick setup), run these commands from the root of the repository:

```bash
# 1. Install Official Packages
sudo pacman -S --needed - < packages/pkglist.txt

# 2. Install AUR Packages
paru -S --needed - < packages/aur_pkglist.txt

# 3. Install Flatpaks
xargs -a packages/flatpak_list.txt -r flatpak install -y
```

---

## 🔄 Maintenance & Updating

Depending on your goal, you can update these lists in two ways:

### 1. The "Sync" Method (Match Current System)
Use this to make the repository **exactly match** your current machine. **Note:** This will remove packages from the text files if you have uninstalled them from your system.

```bash
pacman -Qqen > packages/pkglist.txt
paru -Qqem > packages/aur_pkglist.txt
flatpak list --app --columns=application > packages/flatpak_list.txt
```

### 2. The "Additive" Method (Add New Apps Only)
Use this if you want to add new apps you've installed recently, but want to **keep** old apps in the list (even if they aren't on this specific machine). This is great for a "Master List" across multiple devices.

```bash
# Add new native packages and remove duplicates
pacman -Qqen >> packages/pkglist.txt && sort -u -o packages/pkglist.txt packages/pkglist.txt

# Add new AUR packages and remove duplicates
paru -Qqem >> packages/aur_pkglist.txt && sort -u -o packages/aur_pkglist.txt packages/aur_pkglist.txt

# Add new Flatpaks and remove duplicates
flatpak list --app --columns=application >> packages/flatpak_list.txt && sort -u -o packages/flatpak_list.txt packages/flatpak_list.txt
```

### 3. Manual Pruning
If the lists get too cluttered, you can manually delete lines from the `.txt` files. After editing, it's good practice to sort them:
```bash
sort -u -o packages/pkglist.txt packages/pkglist.txt
```
