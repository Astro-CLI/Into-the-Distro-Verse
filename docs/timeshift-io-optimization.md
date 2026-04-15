# Timeshift I/O Optimization: Fixing Snapshot-Related Freezes 🔧

## Problem: Random System Freezes During Work/Gaming

When using **Timeshift with hourly snapshots on a full BTRFS disk**, you may experience:
- **Periodic complete system freezes** (every ~1 hour)
- **Latency-sensitive apps freezing** (Citrix, remote work tools, streaming)
- **Gaming stutters** during snapshot creation
- **Audio/video recording glitches**

### Root Cause

Timeshift's hourly snapshots trigger aggressive **BTRFS metadata operations** that create I/O latency. When your disk is >70% full, BTRFS becomes even more aggressive with background cleanup and compaction. This causes:

1. **BTRFS qgroup rescans** (CPU spikes to 24%+)
2. **I/O stalls** on latency-sensitive workloads
3. **Citrix/ICA protocol freezing** (even 100-200ms latency causes hangs)
4. **Game stutters** and dropped frames during snapshots

### Why Not Just Disable Snapshots?

❌ **Bad idea** - You lose system recovery capability and protection against bad updates.

✅ **Better idea** - **Exclude heavy I/O folders from snapshots** while keeping hourly backups for system files.

---

## Solution: Strategic Folder Exclusion

### What to Exclude (Safe to Skip Backups)

These folders rebuild automatically and don't need snapshot protection:

#### 1. **Citrix/Remote Desktop Cache** (Critical for work)
```
~/.ICAClient
~/.cache/citrix*
~/.local/share/citrix*
```
**Why:** Citrix creates temporary cache files every second. Snapshot operations compete for I/O, causing freezes.

#### 2. **General App Caches** (Rebuilt automatically)
```
~/.cache                     # All caches
~/.cache/discord*            # Discord cache
~/.cache/obs*                # OBS streaming cache
~/.cache/proton*             # Proton/Wine cache
~/.cache/spotify             # Spotify cache
~/.cache/wine*               # Wine cache
~/.cache/heroic*             # Heroic Games Launcher
```
**Why:** These rebuild when apps start. Excluding them saves massive I/O during snapshots.

#### 3. **Game Files** (Optional - depends on setup)
```
~/.local/share/Steam/steamapps   # If games on NVME with separate backup
```
**Why:** Game files are large but not critical to backup—Steam/Heroic manage their own versions.

---

## Implementation

### Option A: Manual Configuration (Advanced)

Edit `/etc/timeshift/timeshift.json`:

```bash
sudo nano /etc/timeshift/timeshift.json
```

Find the `"exclude"` array and replace it with:

```json
"exclude": [
  "/home/astro/.ICAClient",
  "/home/astro/.cache/citrix*",
  "/home/astro/.local/share/citrix*",
  "/home/astro/.cache",
  "/home/astro/.cache/discord*",
  "/home/astro/.cache/obs*",
  "/home/astro/.cache/proton*",
  "/home/astro/.cache/spotify",
  "/home/astro/.cache/wine*",
  "/home/astro/.cache/heroic*",
  "/home/astro/.local/share/Steam/steamapps"
]
```

Then restart Timeshift:
```bash
sudo systemctl restart timeshift
```

### Option B: Automated Script

Create a script to apply these exclusions:

```bash
#!/bin/bash
sudo python3 << 'PYTHON'
import json

config_path = '/etc/timeshift/timeshift.json'

with open(config_path, 'r') as f:
    config = json.load(f)

excludes = [
    "/home/astro/.ICAClient",
    "/home/astro/.cache/citrix*",
    "/home/astro/.local/share/citrix*",
    "/home/astro/.cache",
    "/home/astro/.cache/discord*",
    "/home/astro/.cache/obs*",
    "/home/astro/.cache/proton*",
    "/home/astro/.cache/spotify",
    "/home/astro/.cache/wine*",
    "/home/astro/.cache/heroic*",
    "/home/astro/.local/share/Steam/steamapps",
]

config['exclude'] = excludes

with open(config_path, 'w') as f:
    json.dump(config, f, indent=2)

print("✅ Updated timeshift.json exclusions")
PYTHON
```

Save as `~/.config/timeshift-optimize.sh`, make executable, and run:
```bash
chmod +x ~/.config/timeshift-optimize.sh
~/.config/timeshift-optimize.sh
```

---

## Verification

### Check Current Exclusions

```bash
sudo python3 -c "import json; print(json.dumps(json.load(open('/etc/timeshift/timeshift.json'))['exclude'], indent=2))"
```

### Monitor Snapshot Impact

During the next hourly snapshot, monitor I/O latency:

```bash
# Terminal 1: Watch BTRFS operations
sudo watch -n 1 'btrfs fi show /'

# Terminal 2: Monitor system I/O
iostat -x 1

# Terminal 3: Run a test (Citrix, game, or streaming)
# Verify no freezes occur
```

### Confirm Freezes Are Gone

1. ✅ **Citrix/Remote Work** - No more hourly freezes
2. ✅ **Gaming** - No stutters during snapshot times
3. ✅ **Streaming/Recording** - Smooth audio/video without drops
4. ✅ **Disk I/O** - Lower background load

---

## Advanced: Monitoring Snapshot Health

### Check Snapshot Size

```bash
sudo btrfs filesystem show /
sudo btrfs qgroup show /
```

### List All Snapshots

```bash
sudo timeshift --list
```

### Manual Snapshot Test

```bash
sudo timeshift --create --comments "Test snapshot"
```

### Check Timeshift Logs

```bash
sudo journalctl -u timeshift-launcher -n 50 -f
```

---

## Troubleshooting

### Freezes Still Occurring?

1. **Check if exclusions were applied:**
   ```bash
   sudo cat /etc/timeshift/timeshift.json | grep -A 20 '"exclude"'
   ```

2. **Look for other heavy I/O sources:**
   ```bash
   # Monitor which processes cause I/O during snapshot
   iotop -o -b -n 1
   ```

3. **Consider additional exclusions:**
   - `~/.local/share/applications/` (if apps cache frequently)
   - `~/.config/google-chrome/Default/Cache*` (browser cache)
   - Any custom work directories with temporary files

4. **Disable BTRFS quotas** (if you don't need snapshot size estimates):
   ```bash
   sudo btrfs quota disable /
   ```

### Snapshot Not Creating?

Verify Timeshift is running:
```bash
sudo systemctl status timeshift
sudo systemctl restart timeshift
```

### Need to Restore a Snapshot?

1. **Boot into snapshot from GRUB menu** (if grub-btrfs is installed)
2. **Or restore while running:**
   ```bash
   sudo timeshift --restore --snapshot '2026-04-14_12-00-00'
   ```

---

## Related Guides

- 📖 **[Snapshots & Backups](snapshots.md)** - General snapshot concepts
- 📖 **[Arch Linux Setup](arch.md)** - BTRFS layout and Timeshift config
- 📖 **[System Maintenance](system_maintenance.md)** - Backup strategies
- 📖 **[Fedora Setup](fedora.md)** - Timeshift on Fedora/Silverblue

---

## Summary

| Issue | Solution |
|-------|----------|
| **Hourly system freezes** | Exclude cache + Citrix folders from snapshots |
| **Citrix latency** | Remove `.cache/citrix*` from backups |
| **Gaming stutters** | Exclude game cache and staging directories |
| **Recording drops** | Exclude OBS cache and temp directories |
| **Snapshots still needed** | ✅ They still run hourly, just skip heavy I/O folders |

**Key Takeaway:** You don't need to disable snapshots—just be smart about *what* you snapshot. Keep hourly backups for system files, but exclude transient cache and temporary data that rebuilds automatically. This gives you the best of both worlds: **system recovery + smooth performance**.
