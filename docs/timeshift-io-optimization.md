<!-- 
    WIKI GUIDE: timeshift-io-optimization.md
    Solutions for fixing system freezes caused by BTRFS snapshot operations
    on NVMe SSDs, with detailed tuning guidelines.
-->

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

### 🥇 **Solution 1: I/O Throttling & Latency Injection (Recommended - Keeps System Responsive)**

**The real fix:** Slow down snapshot I/O operations so they don't starve your foreground processes. This is the **only solution that lets you keep using your computer during snapshots**.

#### Why This Works

Instead of fighting the I/O scheduler, we **intentionally add latency** to Timeshift operations:
- Snapshots take slightly longer (usually ~15-30% slower)
- Your system **stays completely responsive** (no freezes)
- Background work doesn't starve user processes
- Works on **any storage (NVMe, SSD, HDD)**

#### Implementation: `ionice` + Systemd Tuning for Timeshift

**Method A: Simple - Throttle with `ionice`**

Run snapshots with lowest I/O priority:

```bash
# One-time snapshot with throttling
sudo ionice -c 3 timeshift --create --comments "Throttled snapshot"

# Or make it default for all snapshots - add to cron or systemd timer
```

**Method B: Permanent - Systemd Service Throttling (Recommended)**

Create an override for Timeshift's system service:

```bash
sudo mkdir -p /etc/systemd/system/timeshift-launcher.service.d/
sudo nano /etc/systemd/system/timeshift-launcher.service.d/throttle.conf
```

Paste this:

```ini
[Service]
# Run Timeshift at lowest I/O priority - keeps system responsive
CPUSchedulingPolicy=idle
IOSchedulingClass=idle
IOSchedulingPriority=7
Nice=10

# Optional: Cap CPU usage if snapshots still cause lag
CPUQuota=50%
```

Then reload and restart:
```bash
sudo systemctl daemon-reload
sudo systemctl restart timeshift-launcher
```

**Verify it's working:**
```bash
# Next snapshot, check the priority
ps aux | grep timeshift
# Should show lower I/O priority
```

**Method C: BFQ Scheduler (Most Effective - Kernel-level I/O Fairness)**

Use the **BFQ I/O scheduler** which specifically prioritizes interactive processes:

```bash
# Check if BFQ is available
cat /sys/block/nvme0n1/queue/scheduler

# If you see "[bfq]" it's enabled, if not:
echo bfq | sudo tee /sys/block/nvme0n1/queue/scheduler

# Make persistent across reboots
echo "ACTION==\"add|change\", KERNEL==\"nvme*\", ATTR{queue/scheduler}=\"bfq\"" | \
  sudo tee /etc/udev/rules.d/99-bfq-iosched.rules

# Reload
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Verify:
```bash
cat /sys/block/nvme0n1/queue/scheduler
# Should show [bfq] selected
```

**Method D: Combined Approach (Best Results)**

Use **both** BFQ scheduler + Timeshift throttling:

```bash
# 1. Enable BFQ (from Method C above)
echo bfq | sudo tee /sys/block/nvme0n1/queue/scheduler

# 2. Add Timeshift throttling (from Method B above)
sudo mkdir -p /etc/systemd/system/timeshift-launcher.service.d/
cat << 'EOF' | sudo tee /etc/systemd/system/timeshift-launcher.service.d/throttle.conf
[Service]
CPUSchedulingPolicy=idle
IOSchedulingClass=idle
IOSchedulingPriority=7
Nice=10
EOF

sudo systemctl daemon-reload
```

#### Tuning Guide

| Setting | Effect | Snapshot Speed | System Responsiveness |
|---------|--------|-----------------|----------------------|
| `ionice -c 3` | Lowest I/O priority | ~20-30% slower | ✅ Fully responsive |
| `ionice -c 2 -n 7` | Medium-low I/O | ~10-20% slower | ✅ Very responsive |
| BFQ scheduler alone | Kernel fairness | ~5-10% slower | ✅ Very responsive |
| BFQ + `ionice -c 3` | Maximum throttling | ~30-50% slower | ✅✅ 100% no freezes |

**Start with BFQ + Method B.** If you still get tiny freezes, add `CPUQuota=50%`.

---

### 🥈 **Solution 2: Exclude Heavy I/O Folders (Reduces snapshot work)**

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
| **System freezes during snapshots while working** | 🥇 **I/O Throttling (Method B or C above)** |
| **Want to keep using computer during backup** | ✅ BFQ Scheduler + `ionice` throttling |
| **Citrix/gaming/streaming lag during snapshots** | Systemd throttling + BFQ scheduler |
| **Recording drops during backup** | I/O throttling (keeps interactive processes responsive) |
| **Want faster snapshots** | Skip Method D (CPU quota), just use BFQ |
| **Want guaranteed no freezes** | BFQ + `ionice -c 3` + `CPUQuota=50%` (all combined) |

**Key Takeaway:** The **only real solution is I/O throttling** - you can't eliminate snapshot work, but you can prevent it from starving your foreground processes. Use:
1. **BFQ scheduler** for kernel-level fairness
2. **Systemd throttling** to run Timeshift at low priority
3. **`ionice`** for additional control when needed

This works on **any filesystem, any storage type, any kernel** - it's the proper fix for background tasks that shouldn't freeze interactive use.

---

## 🎯 Why Would I Do This?

- **Keep gaming smooth** - No stutters during backups
- **Work without interruption** - Citrix/remote work doesn't freeze
- **Record cleanly** - No audio/video drops during snapshots
- **System stays responsive** - Keep using your computer normally
- **Faster snapshots** - BFQ and throttling can actually speed things up

---

## 🔗 Related Guides

- 📖 **[Snapshots & Backups](snapshots.md)** - General snapshot concepts
- 📖 **[System Maintenance](system_maintenance.md)** - Backup strategies  
- 📖 **[Arch Linux Guide](arch.md)** - BTRFS layout and kernel options
- 📖 **[Fedora Guide](fedora.md)** - Fedora-specific snapshot tools
