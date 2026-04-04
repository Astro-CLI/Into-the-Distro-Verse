# Virtual Machines: KVM/QEMU/Libvirt Stack 🖥️

A comprehensive guide to setting up and managing virtual machines on Linux using the native KVM hypervisor, QEMU emulator, and libvirt management layer. Perfect for testing distros, development environments, and isolated workloads.

---

## 🚀 1. Understanding the Stack

### The Three Components

| Component | Purpose | Role |
| :--- | :--- | :--- |
| **KVM** | Kernel-based Virtual Machine | Hardware virtualization kernel module |
| **QEMU** | Quick Emulator | System emulator and virtualizer |
| **libvirt** | Virtualization API | Management layer with CLI/GUI tools |

**How they work together:** KVM provides hardware acceleration → QEMU uses KVM for fast virtualization → libvirt provides user-friendly management tools.

---

## 🛠️ 2. Installation & Setup

### Arch Linux

```bash
# Install core virtualization packages
sudo pacman -S qemu-full libvirt virt-manager virt-viewer dnsmasq bridge-utils

# Install optional but recommended packages
sudo pacman -S edk2-ovmf iptables-nft ebtables

# Enable and start libvirtd service
sudo systemctl enable --now libvirtd.service

# Add your user to libvirt group (logout/login required)
sudo usermod -aG libvirt $USER
```

### Fedora

```bash
# Install virtualization group
sudo dnf install @virtualization

# Or install individual packages
sudo dnf install qemu-kvm libvirt virt-manager virt-install virt-viewer

# Enable and start libvirtd
sudo systemctl enable --now libvirtd.service

# Add user to libvirt group
sudo usermod -aG libvirt $USER
```

### Debian/Ubuntu

```bash
# Install KVM and libvirt
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# Install management tools
sudo apt install virt-manager virt-viewer virtinst

# Enable and start libvirtd
sudo systemctl enable --now libvirtd

# Add user to groups (logout/login required)
sudo usermod -aG libvirt,kvm $USER
```

### Verify Installation

```bash
# Check if KVM modules are loaded
lsmod | grep kvm

# Expected output: kvm_intel or kvm_amd
# Verify virtualization support
LC_ALL=C lscpu | grep Virtualization

# Check libvirt is running
sudo systemctl status libvirtd

# Test virsh connection
virsh list --all
```

⚠️ **CPU Requirement:** Your CPU must support hardware virtualization (Intel VT-x or AMD-V). Enable it in BIOS/UEFI if not already active.

---

## 🖥️ 3. Creating Virtual Machines

### Option A: Using Virt-Manager (GUI)

**Virt-Manager** is the easiest way to create and manage VMs with a graphical interface:

```bash
# Launch virt-manager
virt-manager
```

**Steps:**
1. Click "Create a new virtual machine"
2. Choose installation method:
   - **Local install media:** Use ISO file
   - **Network install:** PXE boot
   - **Import existing disk:** Use existing qcow2/raw disk
3. Configure memory and CPU allocation
4. Set up storage (create new or use existing disk)
5. Review and customize before installation

### Option B: Using virsh (CLI)

**Creating a VM with virt-install:**

```bash
# Create a VM from ISO
virt-install \
  --name archlinux-vm \
  --ram 4096 \
  --vcpus 4 \
  --disk size=40 \
  --os-variant archlinux \
  --cdrom /path/to/archlinux.iso \
  --network network=default \
  --graphics spice \
  --console pty,target_type=serial

# Get list of supported OS variants
osinfo-query os
```

**Common virt-install options:**

| Option | Purpose | Example |
| :--- | :--- | :--- |
| `--name` | VM name | `--name myvm` |
| `--ram` | Memory in MB | `--ram 8192` |
| `--vcpus` | CPU cores | `--vcpus 4` |
| `--disk` | Storage config | `--disk size=50,format=qcow2` |
| `--os-variant` | OS optimization | `--os-variant fedora39` |
| `--cdrom` | ISO path | `--cdrom ~/Downloads/fedora.iso` |
| `--network` | Network type | `--network bridge=virbr0` |

---

## 💾 4. Importing Existing OS Disks

### Converting Disk Images

**Convert various disk formats to qcow2:**

```bash
# VirtualBox VDI to qcow2
qemu-img convert -f vdi -O qcow2 existing.vdi output.qcow2

# VMware VMDK to qcow2
qemu-img convert -f vmdk -O qcow2 existing.vmdk output.qcow2

# Raw IMG to qcow2
qemu-img convert -f raw -O qcow2 existing.img output.qcow2

# Check disk info
qemu-img info output.qcow2
```

### Importing an Existing Disk

**Method 1: virt-install with existing disk**

```bash
virt-install \
  --name imported-vm \
  --ram 4096 \
  --vcpus 2 \
  --disk path=/var/lib/libvirt/images/output.qcow2,format=qcow2 \
  --os-variant linux2020 \
  --network network=default \
  --graphics spice \
  --import
```

**Method 2: virt-manager GUI**

1. Open virt-manager
2. Click "Create a new virtual machine"
3. Select "Import existing disk image"
4. Browse to your converted qcow2 file
5. Configure RAM, CPUs, and complete setup

### Cloning Physical Installations

**Using dd to clone a physical drive:**

```bash
# Clone entire physical disk to image (DANGEROUS - verify device!)
sudo dd if=/dev/sdX of=~/physical-clone.img bs=4M status=progress

# Convert to qcow2 for space efficiency
qemu-img convert -f raw -O qcow2 physical-clone.img physical-clone.qcow2

# Import as described above
```

⚠️ **WARNING:** Double-check device names with `lsblk` before using `dd`. Wrong device = data loss!

---

## 🌐 5. Networking Configuration

### Network Types Overview

| Type | Use Case | VM-to-Internet | VM-to-Host | VM-to-VM | Host-to-VM |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **NAT (default)** | Basic isolation | ✅ | ✅ | ✅ | ❌ |
| **Bridge** | VM acts like physical machine | ✅ | ✅ | ✅ | ✅ |
| **Host-Only** | Isolated network | ❌ | ✅ | ✅ | ✅ |

### Default NAT Network

The **default** network provides NAT with DHCP:

```bash
# Check default network status
virsh net-list --all

# Start default network if inactive
virsh net-start default

# Enable autostart
virsh net-autostart default

# View network configuration
virsh net-dumpxml default
```

### Creating a Bridge Network

**Bridge Mode** connects VMs directly to your physical network:

```bash
# Create bridge interface (example for Arch/Fedora)
# Edit /etc/systemd/network/br0.netdev
sudo tee /etc/systemd/network/br0.netdev > /dev/null <<EOF
[NetDev]
Name=br0
Kind=bridge
EOF

# Edit /etc/systemd/network/br0.network
sudo tee /etc/systemd/network/br0.network > /dev/null <<EOF
[Match]
Name=br0

[Network]
DHCP=yes
EOF

# Bind physical interface to bridge
sudo tee /etc/systemd/network/bind.network > /dev/null <<EOF
[Match]
Name=enp3s0

[Network]
Bridge=br0
EOF

# Restart networking
sudo systemctl restart systemd-networkd
```

**Using bridge in libvirt:**

```bash
# Define bridge network for libvirt
cat > bridge-network.xml <<EOF
<network>
  <name>bridge-network</name>
  <forward mode="bridge"/>
  <bridge name="br0"/>
</network>
EOF

virsh net-define bridge-network.xml
virsh net-start bridge-network
virsh net-autostart bridge-network
```

### Port Forwarding with NAT

**Forward host ports to VM:**

```bash
# Get VM IP address
virsh domifaddr vm-name

# Add port forward using iptables
sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 192.168.122.10:80
sudo iptables -A FORWARD -d 192.168.122.10 -p tcp --dport 80 -j ACCEPT
```

---

## 💿 6. Storage Management

### Storage Pool Types

```bash
# List storage pools
virsh pool-list --all

# View default pool details
virsh pool-info default

# Default pool location: /var/lib/libvirt/images/
```

### Creating Additional Storage Pools

**Create directory-based pool:**

```bash
# Create directory
sudo mkdir -p /mnt/vms

# Define pool
virsh pool-define-as vm-storage dir --target /mnt/vms

# Build, start, and autostart pool
virsh pool-build vm-storage
virsh pool-start vm-storage
virsh pool-autostart vm-storage
```

### Managing Virtual Disks

**Common disk operations:**

```bash
# Create new disk image
qemu-img create -f qcow2 /var/lib/libvirt/images/newdisk.qcow2 50G

# Resize existing disk
qemu-img resize /var/lib/libvirt/images/disk.qcow2 +20G

# Check disk usage
qemu-img info /var/lib/libvirt/images/disk.qcow2

# Attach disk to running VM
virsh attach-disk vm-name \
  /var/lib/libvirt/images/newdisk.qcow2 \
  vdb --live --config

# Detach disk from VM
virsh detach-disk vm-name vdb --live --config
```

### Disk Performance Optimization

**Use virtio drivers for best performance:**

```bash
# When creating VM, specify virtio
virt-install \
  --disk path=/path/to/disk.qcow2,bus=virtio,cache=writeback \
  ... # other options
```

**Disk cache modes:**

| Cache Mode | Performance | Data Safety | Use Case |
| :--- | :--- | :--- | :--- |
| `none` | Slower | Safest | Production databases |
| `writethrough` | Medium | Safe | General purpose |
| `writeback` | Fastest | Risk on host crash | Development/testing |

---

## 📸 7. Snapshots & Backups

### Internal Snapshots (qcow2)

**Quick snapshots stored inside qcow2 disk:**

```bash
# Create snapshot
virsh snapshot-create-as vm-name snapshot1 "Before system update"

# List snapshots
virsh snapshot-list vm-name

# Restore snapshot
virsh snapshot-revert vm-name snapshot1

# Delete snapshot
virsh snapshot-delete vm-name snapshot1

# View snapshot info
virsh snapshot-info vm-name snapshot1
```

### External Snapshots

**Better for production - separate snapshot files:**

```bash
# Create external snapshot
virsh snapshot-create-as vm-name snapshot-external \
  --disk-only --atomic

# List snapshot disk chain
qemu-img info --backing-chain /var/lib/libvirt/images/vm-disk.qcow2
```

### VM Backup Strategy

**Complete VM backup:**

```bash
# 1. Shutdown VM gracefully
virsh shutdown vm-name

# 2. Export VM configuration
virsh dumpxml vm-name > vm-name.xml

# 3. Copy disk image
cp /var/lib/libvirt/images/vm-name.qcow2 ~/backups/

# 4. Restart VM
virsh start vm-name
```

**Live backup (no downtime):**

```bash
# Create external snapshot for backup
virsh snapshot-create-as vm-name backup-snap --disk-only --atomic

# Copy the base image while VM uses snapshot
cp /var/lib/libvirt/images/vm-disk.qcow2 ~/backups/

# Commit snapshot back to base
virsh blockcommit vm-name vda --active --pivot
```

---

## ⚡ 8. Performance Tuning

### CPU Configuration

```bash
# Edit VM CPU settings
virsh edit vm-name

# Add CPU pinning and topology:
<cpu mode='host-passthrough'>
  <topology sockets='1' cores='4' threads='2'/>
</cpu>
```

**CPU pinning for dedicated cores:**

```xml
<vcpu placement='static' cpuset='2-5'>4</vcpu>
<cputune>
  <vcpupin vcpu='0' cpuset='2'/>
  <vcpupin vcpu='1' cpuset='3'/>
  <vcpupin vcpu='2' cpuset='4'/>
  <vcpupin vcpu='3' cpuset='5'/>
</cputune>
```

### Memory Optimization

**Enable hugepages for better performance:**

```bash
# Configure hugepages (add 2GB of 2MB hugepages)
echo 1024 | sudo tee /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

# Make permanent in /etc/sysctl.d/99-hugepages.conf
echo "vm.nr_hugepages = 1024" | sudo tee /etc/sysctl.d/99-hugepages.conf

# Configure VM to use hugepages
virsh edit vm-name

# Add inside <domain>:
<memoryBacking>
  <hugepages/>
</memoryBacking>
```

### I/O Performance

**Use virtio-scsi for better performance:**

```bash
# When creating VM
virt-install \
  --disk path=/path/to/disk.qcow2,bus=scsi,io=threads,cache=writeback \
  --controller type=scsi,model=virtio-scsi \
  ... # other options
```

---

## 🎯 9. Essential virsh Commands

### VM Lifecycle

```bash
# List all VMs
virsh list --all

# Start VM
virsh start vm-name

# Shutdown VM gracefully
virsh shutdown vm-name

# Force stop VM
virsh destroy vm-name

# Suspend VM (pause)
virsh suspend vm-name

# Resume VM
virsh resume vm-name

# Reboot VM
virsh reboot vm-name

# Delete VM (keeps disks)
virsh undefine vm-name

# Delete VM with storage
virsh undefine vm-name --remove-all-storage
```

### VM Configuration

```bash
# Edit VM XML configuration
virsh edit vm-name

# View VM XML
virsh dumpxml vm-name

# Clone VM
virt-clone --original vm-name --name cloned-vm --auto-clone

# Autostart VM on boot
virsh autostart vm-name

# Disable autostart
virsh autostart vm-name --disable
```

### Monitoring & Info

```bash
# View VM info
virsh dominfo vm-name

# Show VM IP address
virsh domifaddr vm-name

# Monitor VM resources
virt-top

# View VM console
virsh console vm-name
```

---

## 🔧 10. Troubleshooting

### Common Issues

**Issue: "Failed to connect socket" error**

```bash
# Check libvirtd is running
sudo systemctl status libvirtd

# Restart service
sudo systemctl restart libvirtd

# Check user group membership
groups | grep libvirt
```

**Issue: VM won't start - "network default is not active"**

```bash
# Start and enable default network
virsh net-start default
virsh net-autostart default
```

**Issue: Poor VM performance**

```bash
# Install virtio drivers in guest OS
# For Windows: Download virtio-win ISO
# For Linux: Usually built-in

# Verify virtio in use
virsh dumpxml vm-name | grep virtio
```

**Issue: Cannot access VM from host**

```bash
# Switch from NAT to bridge network
# Or set up port forwarding (see Networking section)
```

---

## 📚 11. Additional Resources

### Chris Titus Tech Ultimate Arch Linux VM Script

**Automated VM setup for Arch Linux:**

```bash
# Clone the repository
git clone https://github.com/ChrisTitusTech/virtualization

# Follow the repository instructions for automated setup
cd virtualization
bash setup.sh
```

The script handles:
- KVM/QEMU/libvirt installation
- Optimal performance configurations
- Network setup with bridge
- Storage pool configuration

### Official Documentation

- **Arch Wiki - KVM:** [wiki.archlinux.org/title/KVM](https://wiki.archlinux.org/title/KVM)
- **Arch Wiki - Libvirt:** [wiki.archlinux.org/title/Libvirt](https://wiki.archlinux.org/title/Libvirt)
- **Libvirt Documentation:** [libvirt.org](https://libvirt.org)
- **QEMU Documentation:** [qemu.org/documentation/](https://qemu.org/documentation/)

---

## 🔗 Related Guides

*   📖 **[Arch Linux Setup](arch.md)** - Installing virtualization tools on Arch.
*   📖 **[Fedora Configuration](fedora.md)** - Virtualization group installation on Fedora.
*   📖 **[Debian Guide](debian.md)** - KVM setup on Debian/Ubuntu systems.
*   📖 **[System Snapshots](snapshots.md)** - Similar snapshot concepts for bare metal systems.
*   📖 **[Security Hardening](security.md)** - Securing your virtualization environment.
*   📖 **[System Maintenance](system_maintenance.md)** - Backup strategies for VMs and hosts.
