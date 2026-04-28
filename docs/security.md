<!-- 
    WIKI GUIDE: security.md
    Defense-in-depth security hardening guide for Linux including AppArmor,
    firewalls, sandboxing, and privacy tools.
-->

# Linux Security: Hardening & Protection

Security is about layers. This guide covers the "Defense in Depth" strategy for Linux systems, including Mandatory Access Control (AppArmor), Application Sandboxing (Firejail), Application Firewall (OpenSnitch), Network Firewall (UFW), Antivirus (ClamAV), and Network Privacy (DNS-over-TLS).

---

## 🛡️ AppArmor (MAC)

AppArmor is a Mandatory Access Control (MAC) system that restricts programs' capabilities.

### 1. Installation
```bash
sudo pacman -S apparmor
```

### 2. Enable in Kernel
Add to `GRUB_CMDLINE_LINUX_DEFAULT` in `/etc/default/grub`:
```text
apparmor=1 lsm=landlock,lockdown,yama,integrity,apparmor,bpf
```
Then run: `sudo grub-mkconfig -o /boot/grub/grub.cfg`

### 3. Service
```bash
sudo systemctl enable --now apparmor.service
```

### 4. Performance & Logging (Fixing "Slowness")
AppArmor can severely slow down your system if it logs too many "ALLOWED" actions. This typically happens when profiles are in **Complain** mode.

**The Fix:** Move profiles to **Enforce** mode. This allows the actions but stops the noisy logging to your disk.

1. **Resolve Profile Conflicts:**
   Duplicate profiles (e.g., `brave` and `brave.apparmor.d`) will cause errors. Backup and remove duplicates.
   
   **Shell (Bash/Zsh/Fish):**
   ```bash
   sudo mkdir -p /etc/apparmor.d/backup
   sudo mv /etc/apparmor.d/*.apparmor.d /etc/apparmor.d/backup/
   ```

2. **Switch to Enforce Mode:**
   
   **Shell (Bash/Zsh/Fish):**
   ```bash
   sudo find /etc/apparmor.d/ -maxdepth 1 -type f -exec aa-enforce {} +
   ```

3. **Silence Audit Logging (If needed):**
   If the system is still slow due to kernel auditing, you can temporarily silence it:
   
   **Shell (Bash/Zsh/Fish):**
   ```bash
   sudo auditctl -e 0
   ```
   Or permanently by adding `audit=0` to your GRUB kernel parameters.

---

## 🧱 Firewall: UFW vs. Firewalld

A firewall controls network traffic. This system uses **UFW** for its simplicity, but **firewalld** is a great alternative for mobile users.

### Option A: UFW (Simple & Static - Current Choice)
Best for desktops that stay on one network.
```bash
# Install and Enable
sudo pacman -S ufw
sudo systemctl enable --now ufw.service

# Standard "Gaming" Policy
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
```
*   **KDE Integration:** Managed via **System Settings > Firewall**.

### Option B: Firewalld (Dynamic & Zones)
Best for laptops or users who need different rules for "Home" vs "Public" Wi-Fi.
```bash
# Install and Enable
sudo pacman -S firewalld
sudo systemctl enable --now firewalld.service

# Change zones based on network trust
sudo firewall-cmd --set-default-zone=home
sudo firewall-cmd --reload
```

---

## 🦠 Antivirus & Rootkit Detection

Linux malware exists, but it's often aimed at servers or used for data theft.

### ClamAV (Antivirus)
Standard FOSS antivirus. Used for on-demand scanning.
*   **Install:** `sudo pacman -S clamav clamtk`
*   **Database Updates:** `sudo systemctl enable --now clamav-freshclam.service`
*   **GUI:** Open **ClamTk** from the application menu.
*   **CLI Scan:** `clamscan -r ~/Downloads`

### rkhunter (Rootkit Hunter)
Scans for "rootkits" (hidden backdoors) and suspicious system changes.
*   **Install:** `sudo pacman -S rkhunter`
*   **Baseline:** `sudo rkhunter --propupd` (Run this after every major system update).
*   **Check:** `sudo rkhunter --check`

---

## 🔒 Application Sandboxing: Firejail

**Firejail** is a SUID sandbox that restricts applications using Linux namespaces and seccomp-bpf. It's a lightweight way to isolate untrusted applications from your system.

### What is Firejail?

Firejail creates isolated environments for applications, restricting:
- **File system access** - Apps can't access your entire home directory
- **Network access** - Optionally disable networking entirely
- **System resources** - Limit CPU, memory, and capabilities
- **X11/Wayland** - Isolate GUI applications

### Installation

**Shell (Bash/Zsh/Fish):**
```bash
# Arch
sudo pacman -S firejail

# Fedora
sudo dnf install firejail

# Debian/Ubuntu
sudo apt install firejail
```

### Basic Usage

**Shell (Bash/Zsh/Fish):**
```bash
# Run any application in a sandbox
firejail firefox

# Disable network access
firejail --net=none firefox

# Private /tmp and home directory
firejail --private firefox

# Combine restrictions
firejail --net=none --private --noroot chromium
```

### Default Integration (Automatic Sandboxing)

Make Firejail the default for all supported applications:

**Shell (Bash/Zsh/Fish):**
```bash
# Create symlinks for all supported apps
sudo firecfg

# Now when you launch Firefox, Chromium, etc., they automatically run sandboxed
```

**To undo:**
```bash
sudo firecfg --clean
```

### Common Profiles

Firejail includes pre-made security profiles for hundreds of applications:

```bash
# List available profiles
ls /etc/firejail/*.profile | wc -l

# View a specific profile
less /etc/firejail/firefox.profile

# Override a profile
cp /etc/firejail/firefox.profile ~/.config/firejail/firefox.local
nano ~/.config/firejail/firefox.local
```

### Custom Profiles

Create custom sandboxes for applications:

**Shell (Bash/Zsh/Fish):**
```bash
# Create a custom profile
nano ~/.config/firejail/myapp.profile
```

**Example profile:**
```conf
# Include the default template
include /etc/firejail/default.profile

# Restrict filesystem access
private-bin myapp
private-tmp
private-dev

# Disable network
net none

# Whitelist only specific directories
whitelist ~/Documents
whitelist ~/Downloads
```

### Security vs Usability Trade-offs

| Level | Description | Command Example |
|-------|-------------|-----------------|
| **Minimal** | Basic isolation, full home access | `firejail app` |
| **Standard** | Most apps work, good protection | `firejail --private=~/app-data app` |
| **Strict** | High security, may break features | `firejail --net=none --private app` |
| **Paranoid** | Maximum isolation, limited function | `firejail --net=none --private --nosound --no3d app` |

### GUI: Firetools

**Firetools** provides a graphical interface for Firejail.

```bash
# Arch
sudo pacman -S firetools

# Launch
firetools &
```

### When to Use Firejail

✅ **Good for:**
- Web browsers (Firefox, Chromium, Brave)
- Media players (VLC, mpv)
- PDF readers (Evince, Okular)
- Torrent clients (Transmission, qBittorrent)
- Office applications (LibreOffice)
- Running untrusted binaries

❌ **Not recommended for:**
- System utilities (terminal, file manager)
- Development tools (IDE, compilers) - can break functionality
- Applications that need full system access

### Troubleshooting

**Application won't start:**
```bash
# Run with debugging
firejail --debug app

# Disable specific restrictions
firejail --noprofile app
```

**Sound doesn't work:**
```bash
# Allow PulseAudio/PipeWire
firejail --keep-config-pulse app
```

**Can't access files:**
```bash
# Whitelist specific directories
firejail --whitelist=~/Documents app
```

---

## 🚨 Application Firewall: OpenSnitch

**OpenSnitch** is a GNU/Linux port of the Little Snitch application firewall. It provides **per-application network control** with a user-friendly GUI.

### What is OpenSnitch?

OpenSnitch monitors every network connection attempt and lets you:
- **Block/allow per application** - Control which apps can access the network
- **Domain-based filtering** - Allow/block specific websites or IPs
- **Real-time alerts** - Get notified when apps try to connect
- **Rule persistence** - Save decisions permanently
- **System-wide visibility** - See exactly what's connecting where

### Installation

**Shell (Bash/Zsh/Fish):**
```bash
# Arch (AUR)
paru -S opensnitch

# Fedora
sudo dnf copr enable @opensnitch/opensnitch
sudo dnf install opensnitch opensnitch-ui

# Debian/Ubuntu
# Add repository from: https://github.com/evilsocket/opensnitch
```

### Starting OpenSnitch

**Shell (Bash/Zsh/Fish):**
```bash
# Enable and start the daemon
sudo systemctl enable --now opensnitch

# Launch the GUI (runs in system tray)
opensnitch-ui
```

### First-Time Setup

1. **Launch opensnitch-ui** - Icon appears in system tray
2. **Click the icon** - Opens the control panel
3. **Set default action:**
   - **Allow (monitor mode)** - Learn what apps normally do
   - **Deny (lockdown mode)** - Block everything by default

### Creating Rules

When an application tries to connect, OpenSnitch shows a popup:

**Options:**
- **Allow once** - Temporary permission for this connection
- **Deny once** - Block this connection only
- **Allow always** - Create permanent rule
- **Deny always** - Permanently block

**Rule criteria:**
- By process (e.g., `/usr/bin/firefox`)
- By domain (e.g., `google.com`)
- By IP address
- By port

### GUI Overview

**Statistics Tab:**
- See which apps are connecting
- View connection history
- Monitor active connections

**Rules Tab:**
- View/edit all rules
- Enable/disable rules
- Delete rules
- Import/export rules

**Events Tab:**
- Real-time connection log
- Filter by app, domain, or action
- Search connection history

### Example Rules

**Allow Firefox to access everything:**
```
Process: firefox
Action: allow
Duration: always
```

**Block a specific domain for all apps:**
```
Process: *
Domain: telemetry.mozilla.org
Action: deny
Duration: always
```

**Allow Steam only to Steam servers:**
```
Process: steam
Domain: *.steampowered.com
Action: allow
Duration: always
```

### Configuration Tips

**Recommended setup:**
1. **Start in "Allow" mode** for 1-2 days to learn normal behavior
2. **Review the Statistics** to see what's connecting
3. **Switch to "Deny" mode** and whitelist known-good applications
4. **Create domain rules** for telemetry/tracking domains

**Essential whitelists:**
- Web browsers (Firefox, Chromium, Brave)
- Package managers (pacman, dnf, apt)
- System services (systemd-resolved, NetworkManager)
- Update services (your distribution's update daemon)

### Advanced: CLI Rules

**Shell (Bash/Zsh/Fish):**
```bash
# List all rules
opensnitchd-rulesctl list

# Export rules to JSON
opensnitchd-rulesctl export > my-rules.json

# Import rules
opensnitchd-rulesctl import my-rules.json
```

### Performance Impact

OpenSnitch uses eBPF and netfilter, so performance impact is **minimal**:
- **CPU:** ~1-2% under normal use
- **RAM:** ~50-100 MB
- **Latency:** <1ms per connection

### Comparison: OpenSnitch vs UFW

| Feature | OpenSnitch | UFW |
|---------|-----------|-----|
| **Level** | Per-application | System-wide |
| **Granularity** | Process, domain, IP, port | IP, port only |
| **GUI** | Yes (real-time popups) | Yes (settings panel) |
| **Complexity** | Medium | Low |
| **Use case** | Application control | Network perimeter |

**Best practice:** Use **both** - UFW for perimeter defense, OpenSnitch for application control.

### Troubleshooting

**Daemon won't start:**
```bash
# Check status
sudo systemctl status opensnitch

# View logs
sudo journalctl -u opensnitch -f
```

**GUI not showing popups:**
```bash
# Restart the UI
pkill opensnitch-ui
opensnitch-ui &

# Check notification settings in your desktop environment
```

**Too many popups:**
```bash
# Switch to "Allow by default" temporarily
# Create broad rules for common apps (browser, email, etc.)
# Then switch back to "Deny by default"
```

---

## 🌐 Network Privacy: DNS-over-TLS (DoT)

Encrypt your DNS queries to prevent your ISP from tracking your browsing habits.

### Recommended Provider: AdGuard DNS
Provides both privacy (encryption) and network-level ad blocking.

**KDE GUI Setup:**
1.  **System Settings > Network > Connections**.
2.  Select your connection (`wlan0`/`Ethernet`).
3.  **IPv4 Tab:** Set DNS to `94.140.14.14, 94.140.15.15`.
4.  **IPv6 Tab:** Set DNS to `2a10:50c0::ad1:ff, 2a10:50c0::ad2:ff`.
5.  **DNS-over-TLS:** Set to **Required**.
6.  **Hostname:** `dns.adguard-dns.com`.

---

## 🔒 SELinux (Reference for Fedora)
SELinux is the default on Fedora. **Do not attempt on Arch.**
*   **Check status:** `sestatus`
*   **Relabel system:** `sudo touch /.autorelabel && reboot`

---

## 🔗 Related Guides
*   📖 **[Arch Linux Guide](arch.md)** - Package management and Arch-specific security.
*   📖 **[Fedora Guide](fedora.md)** - SELinux and Fedora Workstation hardening.
*   📖 **[Debian Guide](debian.md)** - Stable-release security and safe repo management.
*   📖 **[Snapshots Guide](snapshots.md)** - Essential for system recovery.

---

## 🎯 Why Would I Use This?

- **Protect your privacy** - Prevent tracking and data collection
- **Defend against malware** - Sandbox and firewall protection
- **Control what apps access** - Determine who sees your data
- **Comply with security standards** - Meet organizational requirements
- **Peace of mind** - Know your system is protected
- **Learn security** - Understand how to secure systems

---

## 🔗 Related Guides

- 📖 **[Snapshots & Backups](snapshots.md)** - Recovery from security incidents
- 📖 **[System Maintenance](system_maintenance.md)** - Keeping your system healthy
- 📖 **[Wayland Privilege Escalation](wayland-privilege-escalation.md)** - Safe elevated privileges
- 📖 **[Arch Linux Guide](arch.md)** - Arch-specific hardening
- 📖 **[Fedora Guide](fedora.md)** - Fedora SELinux configuration
