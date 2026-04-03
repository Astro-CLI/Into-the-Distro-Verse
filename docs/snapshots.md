# Snapshots & Backups: The Safety Net 🛡️

Regardless of which distro you're using, snapshots and backups are essential for system recovery. This guide covers how to set up the perfect safety net for both Arch and Fedora users.

---

## 🕒 1. Snapshot Tools

Snapshots are near-instantaneous state captures of your filesystem. They are the best way to "undo" a broken update or a bad config change.

### Option A: TimeShift (Desktop Recommended)
Best for users who want a simple GUI. It uses specific BTRFS subvolume names (`@` and `@home`).

*   **Arch:** `paru -S timeshift timeshift-autosnap`
*   **Fedora:** `sudo dnf install timeshift`
*   **Automation:** On Arch, `timeshift-autosnap` automatically takes a snapshot before every `pacman` update.

### Option B: Snapper (Power User Alternative)
Powerful and CLI-focused. It's the native way snapshots are handled in Fedora and openSUSE.

*   **Arch:** `paru -S snapper snap-pac`
*   **Fedora:** `sudo dnf install snapper`
*   **Initial Setup:**
    ```bash
    sudo snapper -c root create-config /
    ```

---

## 💾 2. Backup Methods

### BTRFS Snapshots (Internal)
*   **Pros:** Instant, takes 0 space initially.
*   **Cons:** Only works on BTRFS. If your SSD dies, your snapshots die too.
*   **Use Case:** System rollbacks after a "broken" update.

### RSYNC Backups (External)
*   **Pros:** Works on any filesystem. Can be sent to an external drive or cloud storage.
*   **Cons:** Slower, takes literal space for every new file.
*   **Command:**
    ```bash
    rsync -avAXP --delete /source/ /destination/
    ```
*   **Use Case:** Off-site backups of your `/home` directory and personal data.

---

## 🛠️ 3. Bootloader Integration

Ensure you can boot directly into a snapshot from your boot menu.

*   **GRUB (Arch/Fedora):** Install `grub-btrfs` to see snapshots in the boot menu.
    ```bash
    # Arch
    paru -S grub-btrfs && sudo systemctl enable --now grub-btrfsd
    # Fedora
    sudo dnf install grub-btrfs
    ```
*   **systemd-boot (Arch):** Use `gummibbs` (AUR) to generate boot entries for your snapshots automatically.

---

## 🧹 4. Maintenance (BTRFS)

If you're using BTRFS, you should run these occasionally to keep the filesystem healthy.

```bash
# Scrub: Check for data corruption
sudo btrfs scrub start /

# Balance: Free up unused chunks
sudo btrfs balance start -dusage=50 /
```
