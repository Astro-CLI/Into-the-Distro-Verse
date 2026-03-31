# KDE Plasma Configuration Backup

This directory contains a backup of key KDE Plasma configuration files.

## Files Included

-   `plasma-org.kde.plasma.desktop-appletsrc`: Contains settings for your panels, widgets, and desktop layout.
-   `kdeglobals`: Stores global settings like themes, fonts, color schemes, and styles.
-   `kwinrc`: Holds configuration for the KWin window manager, including effects, window rules, and shortcuts.
-   `konsolerc`: Contains profiles and settings for the Konsole terminal emulator.

## How to Restore Configuration

To restore these settings on a new KDE Plasma installation, follow these steps:

1.  **Log out of your Plasma session.** It is crucial to not be in an active session when overwriting these files. You can switch to a TTY (e.g., by pressing `Ctrl+Alt+F3`) and log in there.

2.  **Back up your existing configuration (optional but recommended).** Before copying the new files, it's wise to back up your current ones:
    ```bash
    mkdir -p ~/.config/kde_backup_$(date +%Y-%m-%d)
    mv ~/.config/plasma-org.kde.plasma.desktop-appletsrc ~/.config/kde_backup_$(date +%Y-%m-%d)/
    mv ~/.config/kdeglobals ~/.config/kde_backup_$(date +%Y-%m-%d)/
    mv ~/.config/kwinrc ~/.config/kde_backup_$(date +%Y-%m-%d)/
    mv ~/.config/konsolerc ~/.config/kde_backup_$(date +%Y-%m-%d)/
    ```

3.  **Copy the backed-up files to your `~/.config` directory.** Assuming you have cloned this repository to `~/Projects/My_Linux_Setup`, run the following commands:
    ```bash
    cp ~/Projects/My_Linux_Setup/configs/kde/plasma-org.kde.plasma.desktop-appletsrc ~/.config/
    cp ~/Projects/My_Linux_Setup/configs/kde/kdeglobals ~/.config/
    cp ~/Projects/My_Linux_Setup/configs/kde/kwinrc ~/.config/
    cp ~/Projects/My_Linux_Setup/configs/kde/konsolerc ~/.config/
    ```

4.  **Log back into your Plasma session.** Your desktop layout, theme, window settings, and terminal profiles should now be restored.

**Note:** Restoring configuration files from a different version of Plasma might lead to unexpected issues. This backup is most reliable when moving between similar Plasma versions.
