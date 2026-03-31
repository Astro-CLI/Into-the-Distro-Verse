# GRUB Configuration & Theme Backup

This directory contains backups for your GRUB bootloader settings managed via `grub-customizer` and the active visual theme.

## Files Included

-   `default_grub`: A backup of `/etc/default/grub`.
-   `grub-customizer.cfg`: The specific configuration generated/used by `grub-customizer` in `/etc/grub-customizer/`.
-   `themes/terminator-/`: The visual theme files located in `/boot/grub/themes/`.

## How to Restore

### 1. Restore the Theme
Copy the theme folder back to the system GRUB themes directory:
```bash
sudo mkdir -p /boot/grub/themes
sudo cp -r configs/grub/themes/terminator- /boot/grub/themes/
```

### 2. Restore GRUB Settings
You can manually update `/etc/default/grub` using the backed-up `default_grub` as a reference, or copy it directly (caution: check for UUID changes if on a new disk):
```bash
sudo cp configs/grub/default_grub /etc/default/grub
```

### 3. Restore Grub Customizer Settings
If you have `grub-customizer` installed:
```bash
sudo mkdir -p /etc/grub-customizer
sudo cp configs/grub/grub-customizer.cfg /etc/grub-customizer/grub.cfg
```

### 4. Update GRUB
After restoring the files, regenerate the GRUB configuration to apply changes:

**On Arch Linux:**
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**On Fedora:**
```bash
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```
