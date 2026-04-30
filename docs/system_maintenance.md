<!-- 
    WIKI GUIDE: system_maintenance.md
    Essential maintenance for Arch Linux and Fedora, covering snapshots,
    backups, BTRFS operations, and bootloader management.
-->

### System Maintenance: Snapshots, Backups & Recovery

Your system will break. Maybe a bad update, maybe a config mistake. This guide sets up safety nets so you can recover quickly. We'll cover snapshots (fast rollbacks), backups (disaster recovery), and bootloaders (recovery options).

---

## 🤔 Why This Matters

- **Bad updates happen** - Snapshot before updating, roll back if needed
- **Accidental deletion** - External backups protect your files
- **System corruption** - Boot into snapshots to diagnose
- **Peace of mind** - Know your system is protected
- **Quick recovery** - Get back online in minutes, not hours

---

## 📸 1. Snapshot Tools: TimeShift vs. Snapper

Snapshots are instant system backups. They take almost no space and let you "undo" changes.

### TimeShift (Recommended for Most Users)

Best if you want a simple GUI and don't need power-user features.

**Installation:**
```bash
### Arch
paru -S timeshift timeshift-autosnap

### Fedora
sudo dnf install timeshift
```

**How it works:**
- Uses BTRFS subvolumes named `@` and `@home`
- Automatic snapshots before package manager updates (with autosnap)
- Simple point-and-click restore
- Shows up in your boot menu for recovery

**Pro tip:** On Arch with autosnap, updates are automatically backed up.

### Snapper (Power User Alternative)

Best if you want granular control and more features.

**Installation:**
```bash
### Arch
paru -S snapper snap-pac

### Fedora
sudo dnf install snapper
```

**Setup:**
```bash
sudo snapper -c root create-config /
```

**Features:**
- Timeline snapshots (hourly, daily)
- Pre/post snapshot pairs (track exactly what changed)
- Config-based customization
- More overhead but very powerful

---

## 💾 2. Backup Methods: Internal vs. External

### BTRFS Snapshots (Internal)

**Pros:**
- Instant - takes almost no time
- Zero space overhead initially
- Perfect for rollbacks after updates

**Cons:**
- Only on BTRFS filesystems
- Lives on same drive - if drive dies, snapshots die too

**Best for:** Quick rollbacks after bad updates

### RSYNC Backups (External)

**Pros:**
- Works on any filesystem
- Can backup to external drives or remote servers
- Space-efficient (only changed files)

**Cons:**
- Slower than BTRFS snapshots
- Takes real disk space
- Manual scheduling required

**Command:**
```bash
rsync -avAXP --delete /source/ /destination/
```

**Best for:** Disaster recovery and off-site backups

---

## 🛠️ 3. BTRFS Operations

If you're using BTRFS, run these occasionally for filesystem health:

### Check for Errors

```bash
sudo btrfs scrub start /
```

This checks the filesystem for corruption (like a disk health check).

### Free Up Space

```bash
sudo btrfs balance start -dusage=50 /
```

This consolidates storage chunks (occasionally helpful for BTRFS).

---

## ⚙️ 4. Bootloader Setup: GRUB vs. systemd-boot

Your bootloader is the menu you see when your computer starts. You can boot into snapshots from here for recovery.

### GRUB (Best for Snapshots)

**Installation:**
```bash
### Arch
sudo pacman -S grub-btrfs
sudo systemctl enable --now grub-btrfsd.service

### Fedora
sudo dnf install grub-btrfs
```

**Advantage:** You'll see snapshots in your boot menu for easy recovery.

**Update after kernel changes:**
```bash
### Arch
sudo grub-mkconfig -o /boot/grub/grub.cfg

### Fedora
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

### systemd-boot (Modern, Faster)

**Setup:**
```bash
### Arch
bootctl install
```

**Advantage:** Simpler, faster, no configuration needed.

**For snapshots on systemd-boot:**
```bash
### Arch (AUR)
paru -S gummibbs
```

---

## 📋 5. Comparing Arch vs. Fedora Maintenance

| Task | Arch | Fedora |
|------|------|--------|
| Package updates | `pacman -Syu` or `paru -Syu` | `sudo dnf upgrade` |
| Snapshots | TimeShift + autosnap | Snapper (native) |
| Bootloader | GRUB or systemd-boot | GRUB (default) |
| Health checks | Manual BTRFS operations | Automatic in DNF |

---

## 🎯 Best Practices

1. **Before major updates:**
   ```bash
   # Take a snapshot first
   sudo timeshift --create --comments "Before major update"
   
   # Then update
   sudo pacman -Syu
   ```

2. **Enable automatic snapshots:**
   ```bash
   # Arch with autosnap
   systemctl --user enable --now timeshift-autosnap-hourly
   ```

3. **Regular RSYNC backups:**
   ```bash
   # Weekly backup to external drive
   0 3 * * 0 rsync -av ~/important /media/backup/
   ```

4. **Check boot menu regularly:**
   - Reboot and check that snapshots appear in bootloader
   - Verify you can boot into an old snapshot if needed

---

## 🆘 Troubleshooting

### Can't Boot After Update

1. Hold Shift while booting (GRUB menu appears)
2. Select a snapshot from before the update
3. Boot into that snapshot
4. Investigate what went wrong in the newer version

### BTRFS Quota Freezes

If your system freezes for 1-2 minutes during snapshots:

```bash
### Disable BTRFS quotas (stops the freezing)
sudo btrfs quota disable /

### Note: TimeShift GUI won't show snapshot sizes, but it still works
```

See the [TimeShift I/O Optimization](timeshift-io-optimization.md) guide for detailed solutions.

---

## 🎯 Why Would I Do This?

- **Never lose your system** - Always have a working version to boot
- **Experiment safely** - Try changes knowing you can undo them
- **Disaster recovery** - External backups protect against hardware failure
- **Upgrade confidently** - Know you can roll back if something breaks
- **Learn from mistakes** - Boot old snapshots to debug what went wrong

---

## 🔗 Related Guides

- 📖 **[Snapshots & Backups](snapshots.md)** - Deeper snapshot concepts
- 📖 **[TimeShift I/O Optimization](timeshift-io-optimization.md)** - Fix snapshot freezes
- 📖 **[Arch Linux Guide](arch.md)** - BTRFS layout for Arch
- 📖 **[Fedora Guide](fedora.md)** - Fedora-specific maintenance
- 📖 **[Security Hardening](security.md)** - Additional protection layers
