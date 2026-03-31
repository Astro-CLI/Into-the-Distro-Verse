# Application Package Lists

This directory contains lists of installed packages from different sources on the Arch Linux system. These lists can be used to quickly reinstall the same applications on a new system.

## Package Lists

-   `pkglist.txt`: A list of all explicitly installed packages from the official Arch Linux repositories (core, extra, etc.).
-   `aur_pkglist.txt`: A list of all explicitly installed packages from the Arch User Repository (AUR).
-   `flatpak_list.txt`: A list of all installed Flatpak applications.

## How to Regenerate the Lists

To keep these lists up-to-date with your current system, run the following commands from the root of this repository. This ensures that packages are correctly categorized by their source.

1.  **List Official (Native) Packages:**
    Only lists explicitly installed packages found in the official sync databases.
    ```bash
    pacman -Qqen > packages/pkglist.txt
    ```

2.  **List AUR (Foreign) Packages:**
    Uses `paru` to list explicitly installed packages NOT found in the official repositories.
    ```bash
    paru -Qqem > packages/aur_pkglist.txt
    ```

3.  **List Flatpak Packages:**
    ```bash
    flatpak list --app --columns=application > packages/flatpak_list.txt
    ```

After regenerating the lists, remember to commit and push the changes to this repository.

## How to Restore Packages on a New System

On a new Arch Linux installation, you can use these lists to reinstall all your applications.

1.  **Install an AUR Helper (e.g., `paru`):**
    You'll need an AUR helper to install packages from the AUR list. If you don't have one, you can install `paru` with these commands:
    ```bash
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    ```

2.  **Install Your Packages:**
    From the root of this repository, run the following commands:
    ```bash
    # Install official packages
    sudo pacman -S --needed - < packages/pkglist.txt

    # Install AUR packages
    paru -S --needed - < packages/aur_pkglist.txt

    # Install Flatpak packages
    xargs -a packages/flatpak_list.txt -r flatpak install -y
    ```
