# KDE Plasma Configuration Backup

This directory contains a backup of key KDE Plasma configuration files.

## Files Included

-   `plasma-org.kde.plasma.desktop-appletsrc`: Panels, widgets, and desktop layout.
-   `kdeglobals`: Global settings (themes, fonts, color schemes).
-   `kwinrc`: KWin window manager configuration (effects, rules, shortcuts).
-   `konsolerc`: Konsole terminal emulator settings.
-   `plasmarc`: Global Plasma shell settings.
-   `kglobalshortcutsrc`: Global keyboard shortcuts.

## How to Restore Configuration

To restore these settings on a new KDE Plasma installation, follow these steps:

1.  **Log out of your Plasma session.** It is crucial to not be in an active session when overwriting these files. Use a TTY (`Ctrl+Alt+F3`) if necessary.

2.  **Back up your existing configuration (optional but recommended).** 
    ```bash
    mkdir -p ~/.config/kde_backup_$(date +%Y-%m-%d)
    cp ~/.config/plasma-org.kde.plasma.desktop-appletsrc ~/.config/kdeglobals ~/.config/kwinrc ~/.config/konsolerc ~/.config/plasmarc ~/.config/kglobalshortcutsrc ~/.config/kde_backup_$(date +%Y-%m-%d)/
    ```

3.  **Restore the configurations.** From the **root of this repository**, run:
    ```bash
    cp configs/kde/plasma-org.kde.plasma.desktop-appletsrc ~/.config/
    cp configs/kde/kdeglobals ~/.config/
    cp configs/kde/kwinrc ~/.config/
    cp configs/kde/konsolerc ~/.config/
    cp configs/kde/plasmarc ~/.config/
    cp configs/kde/kglobalshortcutsrc ~/.config/
    ```

4.  **Log back into your Plasma session.**

**Note:** Restoring configuration files from a different version of Plasma might lead to unexpected issues. This backup is most reliable when moving between similar Plasma versions.
