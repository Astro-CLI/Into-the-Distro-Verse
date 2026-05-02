#!/bin/bash

# Trackpad Fix Script for ThinkBook 15 G4 IAP (MSFT0001)
# This script adds kernel parameters to fix I2C controller timeouts.

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

echo "--- Starting Trackpad Fix ---"

# 1. Backup GRUB config
echo "[1/4] Backing up /etc/default/grub to /etc/default/grub.bak"
cp /etc/default/grub /etc/default/grub.bak

# 2. Add kernel parameters
echo "[2/5] Adding kernel parameters: irqpoll intremap=off i2c_designware.clks_pre_pci=1 i8042.nopnp=1 acpi_osi=Linux"
# Clean up old attempts
sed -i 's/pci=nocrs i8042.nopnp=1 i2c_designware.clks_pre_pci=1 acpi_osi=Linux //g' /etc/default/grub
sed -i 's/irqpoll intremap=off //g' /etc/default/grub

# Add new parameters
if ! grep -q "irqpoll" /etc/default/grub; then
    sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="irqpoll intremap=off i2c_designware.clks_pre_pci=1 i8042.nopnp=1 acpi_osi=Linux /' /etc/default/grub
    sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT='/GRUB_CMDLINE_LINUX_DEFAULT='irqpoll intremap=off i2c_designware.clks_pre_pci=1 i8042.nopnp=1 acpi_osi=Linux /" /etc/default/grub
fi

# 3. Early module loading in mkinitcpio
echo "[3/5] Adding modules to early initramfs (/etc/mkinitcpio.conf)"
sed -i 's/MODULES=()/MODULES=(pinctrl_alderlake i2c_designware_platform i2c_hid_acpi)/' /etc/mkinitcpio.conf

# 4. Configuring modules load/blacklist
echo "[4/5] Configuring modules-load.d and modprobe.d"
echo "i2c_hid_acpi" > /etc/modules-load.d/trackpad-fix.conf
echo "pinctrl_alderlake" >> /etc/modules-load.d/trackpad-fix.conf
echo "blacklist ideapad_laptop" > /etc/modprobe.d/ideapad-blacklist.conf

# 5. Update system images
echo "[5/5] Regenerating initramfs and GRUB..."
mkinitcpio -P
if command -v grub-mkconfig >/dev/null 2>&1; then
    grub-mkconfig -o /boot/grub/grub.cfg
elif command -v update-grub >/dev/null 2>&1; then
    update-grub
fi

echo "--- Fix Applied ---"
echo "Please REBOOT your laptop now to apply the changes."
