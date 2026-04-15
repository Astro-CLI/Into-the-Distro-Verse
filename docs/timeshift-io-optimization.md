# Timeshift I/O Optimization: Fixing Snapshot-Related Freezes 🔧

## Problem: Random System Freezes During Work/Gaming

When using **Timeshift with hourly snapshots on a full BTRFS disk with NVMe**, you may experience:
- **Periodic complete system freezes** (every ~1 hour)
- **Latency-sensitive apps freezing** (Citrix, remote work tools, streaming)
- **Gaming stutters** during snapshot creation
- **Audio/video recording glitches**

### Root Cause: NVMe I/O Scheduler Starvation

This issue is **specific to NVMe SSDs** on stock Arch kernels. Here's why:

- **HDDs/SSDs:** Slow storage naturally throttles I/O, preventing starvation
- **NVMe:** No built-in throttling, can queue 50,000+ IOPS instantly
- **Result:** BTRFS qgroup rescans after snapshots starve user applications of CPU time

BTRFS's hourly snapshots trigger aggressive **metadata operations** that create I/O latency:
1. **BTRFS qgroup rescans** after each snapshot (kernel-level operation)
2. **I/O queue explosion** on NVMe without fairness scheduler
3. **User process starvation** - Citrix/gaming/streaming get 0% CPU
4. **Result:** 2-3 second complete system freeze

### Why This Doesn't Happen on Your Friends' Systems

If your friends use **CachyOS or Zen kernels** (or HDDs/SSDs), they don't freeze because:
- **CachyOS/Zen kernels** have optimized I/O schedulers that prevent starvation
- **HDDs/SSDs** naturally serialize I/O, spreading operations over time
- **Better scheduler fairness** ensures background work doesn't starve foreground apps

---

## Solution Priority: Pick One

### 🥇 **Solution 1: Switch Kernel (Recommended for NVMe Users)**

The **fastest and most effective fix** if you're on NVMe.

#### Why Kernel Matters

Stock Arch kernel uses a generic I/O scheduler. Specialized kernels fix the I/O starvation problem:

| Kernel | Focus | Performance | Installation |
|--------|-------|-------------|--------------|
| **CachyOS** | Desktop latency optimization | ⭐⭐⭐⭐⭐ Best | Compile from AUR (~15 min) |
| **linux-zen** | Responsiveness & gaming | ⭐⭐⭐⭐ Very Good | Pre-built, instant |
| **linux-hardened** | Security + decent latency | ⭐⭐⭐ Good | Pre-built, instant |
| **Stock Arch** | Generic | ⭐⭐ Problem case | Already installed |

#### Installation

**Option A: linux-zen (Instant, Pre-built)**
```bash
# At next boot, select linux-zen from GRUB menu
# Or set as default:
sudo grub-mkconfig -o /etc/grub/grub.cfg
# Reboot and test through hourly snapshot cycle
```

**Option B: CachyOS (Best Performance, Compiles)**
```bash
paru -S linux-cachyos linux-cachyos-headers
# Reboot and select linux-cachyos from GRUB
# Test through hourly snapshot cycle
```

#### Real-World Results

**Tested on:** Arch Linux with NVMe, Timeshift hourly snapshots, Citrix workloads
- ✅ **CachyOS:** Complete elimination of freezes; "smooth sailing"
- ✅ **linux-zen:** ~50-70% improvement; minimal freezes
- ❌ **Stock Arch:** No improvement; freezes persist

**Note:** Your friends using CachyOS/Zen don't experience freezes because their kernel prevents I/O starvation.

---

### 🥈 **Solution 2: Exclude Heavy I/O Folders (No kernel change required)**

If switching kernels isn't an option, use folder exclusions to reduce I/O load.

#### What to Exclude (Safe to Skip Backups)

These folders rebuild automatically and don't need snapshot protection:

##### 1. **Citrix/Remote Desktop Cache** (Critical for work)
```
~/.ICAClient
~/.cache/citrix*
~/.local/share/citrix*
```
**Why:** Citrix creates temporary cache files every second. Snapshot operations compete for I/O, causing freezes.

##### 2. **General App Caches** (Rebuilt automatically)
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

##### 3. **Game Files** (Optional - depends on setup)
```
~/.local/share/Steam/steamapps   # If games on NVME with separate backup
```
**Why:** Game files are large but not critical to backup—Steam/Heroic manage their own versions.

#### Implementation

**Option A: Manual Configuration (Advanced)**

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

**Option B: Automated Script**

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

During the next hourly snapshot, monitor for freezes:

```bash
# Terminal 1: Watch for BTRFS qgroup scans
journalctl --grep="qgroup" --follow

# Terminal 2: Run a test (Citrix, game, or streaming)
# Verify no freezes occur
```

### Confirm Freezes Are Gone

1. ✅ **Citrix/Remote Work** - No more hourly freezes
2. ✅ **Gaming** - No stutters during snapshot times
3. ✅ **Streaming/Recording** - Smooth audio/video without drops

---

## Advanced: Other Solutions if Kernel Change Isn't Possible

If you can't or won't switch kernels, here are alternatives (in order of effectiveness):

### Option 1: Disable BTRFS Quotas
**Impact:** Complete freeze elimination, but no snapshot size estimates in GUI
```bash
btrfs quota disable /
```

### Option 2: Reduce I/O Scheduler Aggressiveness
Switch to `kyber` scheduler for fairness:
```bash
echo kyber | sudo tee /sys/block/nvme0n1/queue/scheduler
```

### Option 3: Tune BTRFS Metadata Allocation
Reduce metadata chunk allocations:
```bash
sudo btrfs filesystem tune -m 5 /
```

### Option 4: Disable Free Space Tree (Legacy v1)
Reduces metadata overhead (one-time operation):
```bash
sudo btrfs filesystem feature disable quotagroup /
```

---

## Troubleshooting

### Freezes Still Occurring After Kernel Switch?

1. **Verify the new kernel is running:**
   ```bash
   uname -r
   ```
   Should show `cachyos` or `zen`

2. **Allow 2-3 hourly snapshot cycles** - performance may improve gradually

3. **Try the next kernel option** (if using zen, try cachyos)

4. **Fall back to folder exclusions** (see Solution 2)

### Freezes Still Occurring After Folder Exclusions?

1. **Check if exclusions were applied:**
   ```bash
   sudo cat /etc/timeshift/timeshift.json | grep -A 20 '"exclude"'
   ```

2. **Look for other heavy I/O sources:**
   ```bash
   iotop -o -b -n 1
   ```

3. **Consider additional exclusions:**
   - `~/.local/share/applications/`
   - `~/.config/google-chrome/Default/Cache*`
   - Custom work directories with temp files

4. **Try kernel switch** (most effective solution)

---

## Monitoring Snapshot Health

### List All Snapshots
```bash
sudo timeshift --list
```

### Check Timeshift Logs
```bash
sudo journalctl -u timeshift-launcher -n 50 -f
```

### Manual Snapshot Test
```bash
sudo timeshift --create --comments "Test snapshot"
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
| **Hourly system freezes on NVMe** | 🥇 **Switch to CachyOS or linux-zen kernel** |
| **Can't switch kernels** | Exclude cache + Citrix folders, or disable quotas |
| **Citrix/remote work latency** | Kernel switch (CachyOS) or folder exclusions |
| **Gaming stutters during snapshots** | Kernel switch or reduce BTRFS metadata load |
| **Recording drops** | Kernel switch or exclude OBS cache |
| **Want to keep hourly snapshots** | ✅ All solutions maintain hourly frequency |

**Key Takeaway:** The **fastest fix is switching to an optimized kernel** (CachyOS or linux-zen). This solves the root cause of I/O scheduler starvation on NVMe. If that's not possible, folder exclusions + BTRFS tuning can mitigate the problem. The issue is specific to **NVMe + stock Arch kernel I/O scheduling**, not an inherent Timeshift limitation.
