# Linux Security: Hardening & Protection

Security is about layers. This guide covers the "Defense in Depth" strategy implemented on this system, including Mandatory Access Control (AppArmor), Firewall (UFW), Antivirus (ClamAV), and Network Privacy.

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
