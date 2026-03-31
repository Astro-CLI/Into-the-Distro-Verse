# System Maintenance: TimeShift, BTRFS, and GRUB

This guide covers the essential tools and configurations used for system backup, filesystem management, and booting on this Arch Linux setup.

---

## 1. TimeShift: System Restore Points

TimeShift is a powerful utility that provides system restore functionality, similar to "System Restore" in Windows or "Time Machine" in macOS. It creates incremental snapshots of the system at regular intervals.

### Key Features
- **Snapshots**: Captures the state of the system (excluding user data in `/home` by default).
- **RSYNC vs. BTRFS**: 
    - **RSYNC mode**: Uses `rsync` and hard links. Works on any filesystem.
    - **BTRFS mode**: Uses BTRFS subvolumes. Snapshots are nearly instantaneous and take almost no space initially. **(Recommended for this setup)**.

### Common Commands
- **Create a snapshot**:
    ```bash
    sudo timeshift --create --comments "Before update"
    ```
- **List snapshots**:
    ```bash
    sudo timeshift --list
    ```
- **Restore a snapshot**:
    ```bash
    sudo timeshift --restore
    ```

---

## 2. BTRFS: The Modern Filesystem

BTRFS (B-Tree Filesystem) is a modern Copy-on-Write (CoW) filesystem for Linux aimed at implementing advanced features while also focusing on fault tolerance, repair, and easy administration.

### Subvolumes
This setup typically uses subvolumes to organize data and enable efficient snapshots:
- `@`: Mounted at `/` (root).
- `@home`: Mounted at `/home`.
- `@cache`: Mounted at `/var/cache`.
- `@log`: Mounted at `/var/log`.

### Maintenance
- **Scrub**: Regularly check for data corruption.
    ```bash
    sudo btrfs scrub start /
    ```
- **Balance**: Rebalance data across chunks (useful for reclaiming space).
    ```bash
    sudo btrfs balance start /
    ```
- **Usage**: Check real disk usage.
    ```bash
    sudo btrfs filesystem usage /
    ```

---

## 3. GRUB: The Bootloader

GRUB (GRand Unified Bootloader) is the default bootloader for this system. It handles the initial boot process and allows selecting different kernels or operating systems.

### Configuration
The main configuration file is `/boot/grub/grub.cfg`, but it should **never** be edited manually. Instead, edit `/etc/default/grub` and files in `/etc/grub.d/`.

### Updating GRUB
After installing a new kernel or changing `/etc/default/grub`, always regenerate the config:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Integration with TimeShift
With the `grub-btrfs` package, TimeShift snapshots can automatically appear in the GRUB boot menu, allowing you to boot into a previous system state directly if the current one fails.
