# System Maintenance: Snapshots, Backups, and Bootloaders

This guide covers essential maintenance for both **Arch Linux** and **Fedora**, focusing on BTRFS, snapshots (TimeShift/Snapper), and bootloaders (GRUB/systemd-boot).

---

## 1. Snapshot Tools: TimeShift vs. Snapper

Snapshots are near-instantaneous state captures.

### TimeShift (Recommended for Beginners)
- **Best for**: Desktop users wanting a simple GUI.
- **Arch**: `sudo pacman -S timeshift`
- **Fedora**: `sudo dnf install timeshift`
- **Logic**: Uses specific BTRFS subvolume names (`@` and `@home`).
- **Automation**: Use `timeshift-autosnap` (AUR) on Arch to back up before updates.

### Snapper (Power User Alternative)
- **Best for**: Advanced users and those who want more granular control.
- **Arch**: `sudo pacman -S snapper snap-pac`
- **Fedora**: `sudo dnf install snapper` (Snapper is very well integrated into Fedora/openSUSE).
- **Configuration**:
    ```bash
    sudo snapper -c root create-config /
    ```
- **Timeline snapshots**: Snapper can be configured to take hourly snapshots automatically via systemd timers.

---

## 2. Backup Methods: BTRFS vs. RSYNC

### BTRFS Snapshots
- **Pros**: Instant, takes 0 space initially, perfect for system rollbacks.
- **Cons**: Only works on BTRFS. If the drive dies, the snapshot dies too.
- **Use Case**: Rolling back a broken update or a bad config change.

### RSYNC Backups
- **Pros**: Filesystem agnostic. Can be sent to external drives or cloud storage.
- **Cons**: Slower, takes literal space for every new file.
- **Command**:
    ```bash
    rsync -avAXP --delete /source/ /destination/
    ```
    *(Flags: -a archive, -v verbose, -A ACLs, -X xattrs, -P progress)*
- **Use Case**: Off-site backups of personal data.

---

## 3. BTRFS Maintenance

BTRFS is the default on Fedora and highly recommended for Arch.

### Subvolume Layouts
- **Arch (Common)**: `@` (root), `@home`, `@cache`, `@log`.
- **Fedora (Default)**: `root` (root), `home` (home).
- **Note**: TimeShift requires the Arch-style `@` naming convention. On Fedora, you may need to rename subvolumes to use TimeShift in BTRFS mode.

### Health Checks
- **Scrub (Check for errors)**:
    ```bash
    sudo btrfs scrub start /
    ```
- **Balance (Free up space)**:
    ```bash
    sudo btrfs balance start -dusage=50 /
    ```

---

## 4. Bootloaders: GRUB vs. systemd-boot

### GRUB
- **Best for**: Snapshot integration and dual-booting.
- **Update (Arch)**: `sudo grub-mkconfig -o /boot/grub/grub.cfg`
- **Update (Fedora)**: `sudo grub2-mkconfig -o /boot/grub2/grub.cfg`
- **Snapshot Support**: Install `grub-btrfs` to see snapshots in the boot menu.

### systemd-boot
- **Best for**: Speed, simplicity, and modern UEFI systems.
- **Arch**: `bootctl install`
- **Fedora**: Can be switched to, but GRUB is the default.
- **Update**: No "config regeneration" command needed; it reads entries from `/boot/loader/entries/`.
- **Snapshot Support**: Use `gummibbs` (Arch/AUR) to generate snapshot entries for the menu.

---

## 5. Summary: Arch vs. Fedora Maintenance

| Task | Arch Linux | Fedora |
| :--- | :--- | :--- |
| **Package Manager** | `pacman` / `paru` | `dnf` |
| **Snapshots** | TimeShift + `autosnap` | Snapper (native support) |
| **Bootloader** | GRUB or systemd-boot | GRUB (default) |
| **Kernel Updates** | Requires manual GRUB update* | Automatic via `dnf` |

*\*Only if using custom hooks or specific manual setups; usually handled by hooks in Arch as well.*
