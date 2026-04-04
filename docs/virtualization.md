# Virtual Machines: The Complete GUI Guide 🖥️

A practical, GUI-focused guide to KVM/QEMU/libvirt virtualization on Linux. Learn to create VMs, pass through GPUs and physical disks, install Windows with proper drivers, and build powerful virtualized workstations.

---

## 🚀 1. Quick Start: Installation

### The Stack We're Using

- **KVM:** Linux's native hypervisor (built into kernel)
- **QEMU:** The actual virtualizer that uses KVM
- **Virt-Manager:** Your main GUI control panel
- **libvirt:** Background service managing everything

---

## 🛠️ 2. Install Everything You Need

### Arch Linux

⚠️ **Update your system first:**
```bash
sudo pacman -Syu
```

**Install QEMU/KVM packages:**

```bash
# Complete virtualization stack
sudo pacman -S qemu-full libvirt virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ebtables nftables libguestfs edk2-ovmf
```

💡 **Note:** If prompted to REMOVE `iptables`, select **YES**. `nftables` is the modern replacement.

**Configure libvirt permissions:**

Edit `/etc/libvirt/libvirtd.conf`:
```bash
sudo nano /etc/libvirt/libvirtd.conf
```

Find and uncomment/change these lines:
```
unix_sock_group = "libvirt"
unix_sock_rw_perms = "0770"
```

**Add your user to libvirt group:**
```bash
sudo usermod -a -G libvirt $(whoami)
newgrp libvirt
```

**Start and enable libvirtd:**
```bash
sudo systemctl enable --now libvirtd.service
```

**Reboot your system:**
```bash
sudo reboot
```

After reboot, launch virt-manager:
```bash
virt-manager
```

---

### Fedora

⚠️ **Update your system first:**
```bash
sudo dnf upgrade --refresh
```

**Install virtualization group:**

```bash
# One-liner that installs everything
sudo dnf install @virtualization

# Or install packages individually:
sudo dnf install qemu-kvm libvirt virt-manager virt-install virt-viewer bridge-utils libguestfs-tools
```

**Configure libvirt permissions:**

Edit `/etc/libvirt/libvirtd.conf`:
```bash
sudo nano /etc/libvirt/libvirtd.conf
```

Find and uncomment/change these lines:
```
unix_sock_group = "libvirt"
unix_sock_rw_perms = "0770"
```

**Add your user to libvirt group:**
```bash
sudo usermod -a -G libvirt $(whoami)
newgrp libvirt
```

**Start and enable libvirtd:**
```bash
sudo systemctl enable --now libvirtd.service
```

**Reboot your system:**
```bash
sudo reboot
```

After reboot, launch virt-manager:
```bash
virt-manager
```

---

### Debian/Ubuntu

⚠️ **Update your system first:**
```bash
sudo apt update && sudo apt upgrade
```

**Install QEMU/KVM packages:**

```bash
# Complete virtualization stack
sudo apt install qemu-kvm libvirt-daemon-system libvirt-daemon libvirt-clients bridge-utils virt-manager virt-viewer libguestfs-tools ovmf
```

**Configure libvirt permissions:**

Edit `/etc/libvirt/libvirtd.conf`:
```bash
sudo nano /etc/libvirt/libvirtd.conf
```

Find and uncomment/change these lines:
```
unix_sock_group = "libvirt"
unix_sock_rw_perms = "0770"
```

**Add your user to libvirt and kvm groups:**
```bash
sudo usermod -a -G libvirt,kvm $(whoami)
newgrp libvirt
```

**Restart libvirtd:**
```bash
sudo systemctl restart libvirtd
```

**Reboot your system:**
```bash
sudo reboot
```

After reboot, launch virt-manager:
```bash
virt-manager
```

---

### ✅ Verify Everything Works

```bash
# Check for KVM support
lsmod | grep kvm
# Should show: kvm_intel OR kvm_amd

# Verify virtualization is enabled in CPU
LC_ALL=C lscpu | grep Virtualization

# Check libvirt service is running
sudo systemctl status libvirtd

# Verify you're in the libvirt group
groups | grep libvirt

# Test virsh connection
virsh list --all

# Launch virt-manager GUI
virt-manager
```

⚠️ **IMPORTANT BIOS/UEFI Settings:** 
1. Enable **Intel VT-x** or **AMD-V** (required for KVM)
2. Enable **Intel VT-d** or **AMD-Vi** (required for GPU/device passthrough)
3. **Disable Secure Boot** if you have issues booting VMs

💡 **Troubleshooting:**
- If `virt-manager` won't connect: Make sure you logged out and back in after adding yourself to groups
- If you see "KVM not found": Check BIOS virtualization settings
- If permission errors: Verify libvirtd.conf was edited correctly

---

## 🖥️ 3. Creating Your First VM (GUI Method)

### Launch Virt-Manager

```bash
virt-manager
```

### Step-by-Step VM Creation

1. **Click "Create a new virtual machine" (top-left)**

2. **Choose installation source:**
   - **Local install media (ISO):** Most common - browse to your downloaded ISO
   - **Import existing disk image:** For pre-made VM disks (qcow2, raw, etc.)
   - **Network Install (HTTP/FTP):** Advanced users
   - **Manual install:** When you want to configure everything yourself

3. **Select your ISO file**
   - Click "Browse" → "Browse Local"
   - Navigate to your ISO (e.g., `~/Downloads/archlinux.iso`)
   - Virt-Manager will auto-detect the OS (or type to search)

4. **Allocate RAM and CPUs**
   - **RAM:** Minimum 2GB for Linux, 4GB+ for Windows, 8GB+ for heavy workloads
   - **CPUs:** 2-4 cores for most tasks, more for gaming/rendering

5. **Create virtual disk**
   - **Size:** 40GB minimum for Linux, 60GB+ for Windows
   - **Enable storage:** Check this box
   - Click "Manage" to change disk location if needed

6. **Ready to begin installation - BUT WAIT!**
   - ✅ **CHECK "Customize configuration before install"** (IMPORTANT!)
   - Click "Finish"

### ⚙️ Customize Before Starting (Critical!)

**You're now in the VM hardware configuration screen. Here's what to change:**

#### Overview Tab
- **Chipset:** Q35 (modern, required for PCIe passthrough)
- **Firmware:** UEFI (for modern OSes) or BIOS (legacy)
  - For Windows: Use UEFI
  - For GPU passthrough: MUST use UEFI

#### CPUs Tab
- **Configuration:** Click "Copy host CPU configuration" for best performance
- **Topology:** Manually set sockets/cores/threads for better scheduling
  - Example: 1 socket, 4 cores, 2 threads = 8 vCPUs

#### Boot Options Tab
- **Enable boot menu:** Check this for multi-boot options

#### SATA Disk 1 Tab
- **Disk bus:** Change from SATA to **VirtIO** for 3-5x better performance
  - ⚠️ Windows needs virtio drivers (see Windows section below)
  - Linux works automatically with VirtIO

#### NIC Tab (Network)
- **Device model:** Change to **virtio** for best network performance

Now click **"Begin Installation"** in the top-left!

---

## 💾 4. Windows VMs: The VirtIO Driver Setup

### Why VirtIO Matters

**Without VirtIO drivers:** Windows will be SLOW (disk speeds ~50MB/s, bad network)
**With VirtIO drivers:** FAST (disk speeds ~1GB/s+, native network performance)

### Download VirtIO Drivers

```bash
# Download the latest stable VirtIO ISO
cd ~/Downloads
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
```

Or download from: [https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md](https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md)

### Installing Windows with VirtIO

**Step 1: Create Windows VM (customize before install as shown above)**

**Step 2: Add the VirtIO ISO as a second CD drive**

In the VM configuration screen (before starting):
1. Click **"Add Hardware"** (bottom-left)
2. Select **"Storage"**
3. **Device type:** CDROM device
4. Click **"Manage"** → Browse to `virtio-win.iso`
5. Click **"Finish"**

**Step 3: Start Windows Installation**

When you reach "Where do you want to install Windows?" and see **no drives:**

1. Click **"Load driver"**
2. Click **"Browse"**
3. Navigate to CD drive (E: or D:) → **`viostor`** folder
4. Select your Windows version folder (e.g., `w10` or `w11`)
5. Select `amd64` folder
6. Click **OK**
7. Windows will find "Red Hat VirtIO SCSI controller"
8. Click **Next**

Now your disk appears! Continue Windows installation normally.

**Step 4: Install Remaining Drivers After Windows Boots**

Once Windows is installed and running:

1. Open File Explorer
2. Navigate to the VirtIO CD drive
3. Run **`virtio-win-guest-tools.exe`**
4. Install all drivers (network, balloon, SPICE guest tools, etc.)
5. Reboot

✅ **Done!** Your Windows VM now runs at native speeds.

### Pro Tip: SPICE Guest Tools

After installing virtio drivers, install SPICE guest tools for:
- Auto-resize VM window
- Copy/paste between host and VM
- Shared folders
- Better graphics performance

---

## 🔌 5. Attaching Physical Disks (/dev/sda, /dev/nvme0n1, etc.)

### Why Attach Physical Disks?

- **Dual-boot OS access:** Mount your Windows partition in a Linux VM
- **Data drives:** Give VM direct access to storage drives
- **Pass-through performance:** Near-native disk speeds
- **Recovery:** Boot failed installations in a VM

### GUI Method: Add Physical Disk to VM

**⚠️ WARNING:** VM must be **SHUT DOWN** (not running) to add hardware!

1. **Identify your disk:**
   ```bash
   lsblk
   # Example output:
   # sda      8:0    0   1TB  0 disk
   # ├─sda1   8:1    0   500M 0 part  /boot/efi
   # ├─sda2   8:2    0   200G 0 part  /
   # └─sda3   8:3    0   799G 0 part  /home
   # sdb      8:16   0   2TB  0 disk
   # └─sdb1   8:17   0   2TB  0 part
   ```

2. **Open VM in virt-manager** (must be powered off)

3. **Click "Add Hardware"** (bottom-left or top-left icon)

4. **Select "Storage"**
   - **Device type:** Disk device
   - **Storage format:** Select **"Select or create custom storage"**
   - **Manage:** Type the device path manually
     - For entire disk: `/dev/sdb`
     - For partition: `/dev/sdb1`
   - **Bus type:** VirtIO (for Linux guests) or SATA (for Windows without drivers)
   - **Cache mode:** none (safest for physical disks)

5. **Click "Finish"**

6. **Start the VM** - the disk now appears inside!

### Giving Yourself Permission

By default, libvirt might not have permission to access `/dev/sdb`:

```bash
# Check current permissions
ls -l /dev/sdb

# Add yourself to the disk group
sudo usermod -aG disk $USER

# OR change libvirt user permissions (in /etc/libvirt/qemu.conf)
sudo nano /etc/libvirt/qemu.conf

# Uncomment and set:
user = "your-username"
group = "your-username"

# Restart libvirtd
sudo systemctl restart libvirtd
```

### ⚠️ CRITICAL WARNINGS

**DO NOT:**
- ❌ Mount a disk in both host AND VM simultaneously (data corruption!)
- ❌ Pass through your root partition (`/`) while booted from it
- ❌ Write to disks without backups first

**SAFE PRACTICES:**
- ✅ Unmount partitions on host before passing to VM
- ✅ Use read-only mode if just accessing data
- ✅ Pass entire disks (`/dev/sdb`) rather than partitions when possible
- ✅ Test with non-critical disks first

### Read-Only Mode (Safe Exploration)

To mount a disk as read-only:

1. Add the disk as described above
2. Before finishing, go to **XML tab**
3. Add `<readonly/>` inside the `<disk>` block:
   ```xml
   <disk type='block' device='disk'>
     <driver name='qemu' type='raw' cache='none'/>
     <source dev='/dev/sdb1'/>
     <target dev='vdb' bus='virtio'/>
     <readonly/>
   </disk>
   ```

---

## 🎮 6. GPU Passthrough: Ultimate Performance

### What is GPU Passthrough?

**Give your VM exclusive access to a dedicated GPU** for:
- Near-native gaming performance in Windows VMs
- CUDA/compute workloads
- GPU-accelerated rendering
- Machine learning in VMs

### Requirements

✅ **CPU:** Intel VT-d or AMD-Vi support (enable in BIOS)
✅ **GPU:** Second GPU (or iGPU + dedicated GPU)
✅ **Motherboard:** IOMMU support
✅ **Bootloader:** IOMMU enabled in kernel parameters

⚠️ **You need 2 GPUs:** One for host, one to pass to VM (or use iGPU for host + dGPU for VM)

### Step 1: Enable IOMMU

**Edit GRUB configuration:**

```bash
sudo nano /etc/default/grub
```

**For Intel CPUs, add:**
```
GRUB_CMDLINE_LINUX_DEFAULT="... intel_iommu=on iommu=pt"
```

**For AMD CPUs, add:**
```
GRUB_CMDLINE_LINUX_DEFAULT="... amd_iommu=on iommu=pt"
```

**Update GRUB and reboot:**
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot
```

**Verify IOMMU is enabled:**
```bash
dmesg | grep -i iommu
# Should show IOMMU enabled
```

### Step 2: Find Your GPU's PCI IDs

```bash
lspci -nnk | grep -i nvidia
# OR
lspci -nnk | grep -i amd
# OR
lspci -nnk | grep -i vga

# Example output:
# 01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GA104 [GeForce RTX 3070] [10de:2484]
# 01:00.1 Audio device [0403]: NVIDIA Corporation GA104 High Definition Audio Controller [10de:228b]
```

**Note the IDs in brackets:** `10de:2484` and `10de:228b`

### Step 3: Isolate the GPU from Host

**Create vfio config:**

```bash
sudo nano /etc/modprobe.d/vfio.conf
```

**Add (use YOUR IDs from above!):**
```
options vfio-pci ids=10de:2484,10de:228b
softdep nvidia pre: vfio-pci
softdep nouveau pre: vfio-pci
```

**Update initramfs:**

**Arch:**
```bash
sudo mkinitcpio -P
```

**Fedora:**
```bash
sudo dracut --force
```

**Debian/Ubuntu:**
```bash
sudo update-initramfs -u
```

**Reboot:**
```bash
sudo reboot
```

**Verify GPU is bound to vfio:**
```bash
lspci -nnk -d 10de:2484
# Should show: Kernel driver in use: vfio-pci
```

### Step 4: Configure VM for GPU Passthrough

**In virt-manager:**

1. **Shut down your VM** (if running)

2. **Open VM configuration**

3. **Overview tab:**
   - **Chipset:** Q35
   - **Firmware:** UEFI (required!)

4. **CPUs tab:**
   - Enable **"Copy host CPU configuration"**

5. **Click "Add Hardware"**

6. **Select "PCI Host Device"**
   - Find your GPU (will show the PCI address)
   - Add the **VGA controller** (01:00.0)
   - Click "Finish"

7. **Repeat "Add Hardware"** for GPU audio device (01:00.1)

8. **XML tab** (for advanced config):
   - Click **XML** tab at top
   - Find `<domain type='kvm'>` and change to:
   ```xml
   <domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
   ```
   
   - Add before `</domain>`:
   ```xml
   <qemu:commandline>
     <qemu:arg value='-cpu'/>
     <qemu:arg value='host,kvm=off,hv_vendor_id=null'/>
   </qemu:commandline>
   ```

9. **Optional:** Remove Spice/QXL display if GPU is primary display

10. **Apply and start VM**

### Step 5: Install GPU Drivers in Guest

**Windows:**
- Download NVIDIA/AMD drivers as normal
- Install and reboot
- GPU should appear in Device Manager

**Linux:**
- Install drivers via package manager
- Configure Xorg if needed

### Troubleshooting GPU Passthrough

**Error: "device is already in use"**
```bash
# Check what's using it
lspci -k -s 01:00.0

# Make sure host drivers are blacklisted
```

**Black screen / Code 43 error:**
- Add KVM hiding: `kvm=off,hv_vendor_id=null`
- Ensure UEFI firmware, not BIOS
- Update GPU VBIOS (advanced)

**VM won't start:**
```bash
# Check libvirt logs
sudo journalctl -u libvirtd -f
```

### Chris Titus Tech GPU Passthrough Script

For automated GPU passthrough setup on Arch:

```bash
git clone https://github.com/ChrisTitusTech/gpu-passthrough
cd gpu-passthrough
./install.sh
```

---

## 💿 7. Converting & Importing Existing VM Disks

### From VirtualBox (VDI)

```bash
# Convert VDI to qcow2
qemu-img convert -f vdi -O qcow2 ~/VirtualBox\ VMs/myvm/disk.vdi ~/vm-disk.qcow2

# Import in virt-manager:
# 1. Create new VM → "Import existing disk image"
# 2. Browse to ~/vm-disk.qcow2
# 3. Select OS type
# 4. Configure RAM/CPU → Finish
```

### From VMware (VMDK)

```bash
# Convert VMDK to qcow2
qemu-img convert -f vmdk -O qcow2 ~/vmware/myvm/disk.vmdk ~/vm-disk.qcow2

# Import as above
```

### From Hyper-V (VHD/VHDX)

```bash
# Convert VHD to qcow2
qemu-img convert -f vpc -O qcow2 ~/hyperv/disk.vhd ~/vm-disk.qcow2

# Convert VHDX to qcow2
qemu-img convert -f vhdx -O qcow2 ~/hyperv/disk.vhdx ~/vm-disk.qcow2
```

### From Physical Disk (Clone Entire Drive)

```bash
# Find your disk
lsblk

# Clone to image file (VERIFY DEVICE NAME!)
sudo dd if=/dev/sdb of=~/physical-disk.img bs=4M status=progress

# Convert to qcow2 for better compression
qemu-img convert -f raw -O qcow2 ~/physical-disk.img ~/vm-disk.qcow2

# Import in virt-manager
```

⚠️ **WARNING:** Triple-check device names! `if=/dev/sda` could wipe your host OS!

### Expand Disk Size After Import

```bash
# Resize the qcow2 file
qemu-img resize ~/vm-disk.qcow2 +50G

# Then inside the guest OS:
# Linux: Use gparted or fdisk + resize2fs
# Windows: Use Disk Management to extend partition
```

---

## 📸 8. Snapshots: Time Travel for VMs

### Creating Snapshots (GUI)

**In virt-manager:**

1. Open your VM (doesn't need to be running)
2. Click **"Manage VM Snapshots"** icon (camera/clock icon)
3. Click **"Create new snapshot"** (+ button)
4. Give it a name: "Before Windows Update" or "Clean Install"
5. Optional: Add description
6. Click **"Finish"**

### Restoring Snapshots

1. Open "Manage VM Snapshots"
2. Select the snapshot you want to restore
3. Click **"Run snapshot"** (play button)
4. Confirm → Your VM reverts instantly!

### When to Snapshot

✅ **Before:**
- Major system updates
- Installing new software
- Changing system configurations
- Experimenting with settings

✅ **After:**
- Fresh OS installation (clean slate)
- Getting software environment working
- Successful configurations

### Snapshot Tips

- **Name snapshots clearly:** "2024-04-04-before-nvidia-driver" not "snap1"
- **Don't rely on 50+ snapshots:** They eat disk space and slow down VMs
- **Delete old snapshots:** Keep 3-5 important ones max
- **External snapshots for production:** More reliable than internal

### Deleting Snapshots

1. Open "Manage VM Snapshots"
2. Select old snapshot
3. Click **"Delete snapshot"** (trash icon)
4. Confirm

**This merges the snapshot back into the base disk** - doesn't lose data from current state.

---

## ⚡ 9. Performance Tips

### In Virt-Manager (Easy Optimizations)

**CPUs Tab:**
- ✅ Check **"Copy host CPU configuration"** (huge performance boost!)
- ✅ Manually set topology: 1 socket, 4 cores, 1-2 threads

**Boot Options:**
- ✅ Enable boot menu for flexibility

**Disk:**
- ✅ Use **VirtIO** bus (not SATA/IDE)
- ✅ Cache mode: **writeback** for speed (dev), **none** for safety (production)
- ✅ Discard mode: **unmap** (for SSD trim support)

**Network:**
- ✅ Device model: **virtio**

**Video:**
- ✅ For Linux guests: **Virtio**
- ✅ For Windows (no GPU passthrough): **QXL** or **Virtio**
- ⚠️ Remove when using GPU passthrough

### XML Tweaks for Maximum Performance

**Edit VM (virt-manager → Open VM → Edit → Preferences → Enable XML editing)**

**Or via command line:**
```bash
virsh edit vm-name
```

**Add host-passthrough CPU mode:**
```xml
<cpu mode='host-passthrough' check='none'>
  <topology sockets='1' dies='1' cores='4' threads='2'/>
</cpu>
```

**Enable hugepages (if configured on host):**
```xml
<memoryBacking>
  <hugepages/>
</memoryBacking>
```

**Add CPU pinning for dedicated cores:**
```xml
<vcpu placement='static' cpuset='2-5'>4</vcpu>
<cputune>
  <vcpupin vcpu='0' cpuset='2'/>
  <vcpupin vcpu='1' cpuset='3'/>
  <vcpupin vcpu='2' cpuset='4'/>
  <vcpupin vcpu='3' cpuset='5'/>
</cputune>
```

**For VirtIO SCSI (better I/O):**
```xml
<controller type='scsi' index='0' model='virtio-scsi'>
  <driver queues='4' iothread='1'/>
</controller>
```

---

## 🔧 10. Useful Commands (Quick Reference)

### Starting/Stopping VMs

```bash
# List all VMs
virsh list --all

# Start VM
virsh start vm-name

# Shutdown gracefully
virsh shutdown vm-name

# Force stop (like pulling power)
virsh destroy vm-name

# Auto-start VM on boot
virsh autostart vm-name
```

### Getting VM Information

```bash
# Get VM IP address
virsh domifaddr vm-name

# View VM details
virsh dominfo vm-name

# Monitor resource usage
virt-top

# Check if default network is running
virsh net-list --all

# Start default network
virsh net-start default
```

### Cloning VMs

```bash
# Clone entire VM (auto-generates new disk)
virt-clone --original vm-name --name new-vm-name --auto-clone
```

### Deleting VMs

```bash
# Delete VM config (keeps disk)
virsh undefine vm-name

# Delete VM AND all disks
virsh undefine vm-name --remove-all-storage
```

---

## 🔧 11. Troubleshooting

### VM Won't Start

**Error: "network 'default' is not active"**
```bash
virsh net-start default
virsh net-autostart default
```

**Error: "Failed to connect socket"**
```bash
sudo systemctl restart libvirtd
# Check you're in libvirt group:
groups | grep libvirt
# If not, add yourself and logout/login
```

**Error: Permission denied accessing disk**
```bash
# Check disk ownership
ls -l /var/lib/libvirt/images/

# Fix permissions
sudo chown -R libvirt-qemu:kvm /var/lib/libvirt/images/
```

### Windows Won't Install (No Disk Found)

✅ **Solution:** Load VirtIO drivers during Windows installation (see Windows section above)

### Poor Performance

1. ✅ Enable **VirtIO** for disk and network
2. ✅ Set CPU mode to **host-passthrough**
3. ✅ Install guest tools (SPICE, VirtIO drivers)
4. ✅ Allocate enough RAM (4GB+ for Windows, 2GB+ for Linux)

### GPU Passthrough Not Working

**Black screen / Code 43:**
- ✅ Verify IOMMU is enabled: `dmesg | grep -i iommu`
- ✅ Check GPU is bound to vfio: `lspci -nnk -d YOUR:GPUID`
- ✅ Use UEFI firmware (not BIOS)
- ✅ Add KVM hiding in XML: `kvm=off,hv_vendor_id=null`

**VM crashes when starting with GPU:**
```bash
# Check logs
sudo journalctl -u libvirtd -f
```

### Can't Access VM from Host Network

**Using NAT (default):**
- VMs can access internet, but host can't reach VM directly
- Solution: Use bridge network or port forwarding

**Using Bridge:**
- VM gets IP from your router/DHCP
- Accessible from anywhere on your LAN

---

## 📚 12. Additional Resources

### Chris Titus Tech Guides

**Ultimate Arch Linux VM Installation:**
```bash
# Automated setup script
git clone https://github.com/ChrisTitusTech/virtualization
cd virtualization
./setup.sh
```

**Chris Titus GPU Passthrough Guide:**
- [YouTube: GPU Passthrough Tutorial](https://www.youtube.com/watch?v=h7SG7ccjn-g)
- [GitHub: GPU Passthrough Scripts](https://github.com/ChrisTitusTech/gpu-passthrough)

### Essential Reading

- **Arch Wiki - KVM:** [wiki.archlinux.org/title/KVM](https://wiki.archlinux.org/title/KVM)
- **Arch Wiki - PCI Passthrough:** [wiki.archlinux.org/title/PCI_passthrough_via_OVMF](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)
- **Arch Wiki - Libvirt:** [wiki.archlinux.org/title/Libvirt](https://wiki.archlinux.org/title/Libvirt)
- **VirtIO Drivers:** [github.com/virtio-win/virtio-win-pkg-scripts](https://github.com/virtio-win/virtio-win-pkg-scripts)
- **r/VFIO Community:** [reddit.com/r/VFIO](https://www.reddit.com/r/VFIO) - GPU passthrough help

---

## 🔗 Related Guides

*   📖 **[Arch Linux Setup](arch.md)** - Installing virtualization tools on Arch.
*   📖 **[Fedora Configuration](fedora.md)** - Virtualization group installation on Fedora.
*   📖 **[Debian Guide](debian.md)** - KVM setup on Debian/Ubuntu systems.
*   📖 **[System Snapshots](snapshots.md)** - Similar snapshot concepts for bare metal systems.
*   📖 **[Security Hardening](security.md)** - Securing your virtualization environment.
*   📖 **[System Maintenance](system_maintenance.md)** - Backup strategies for VMs and hosts.
