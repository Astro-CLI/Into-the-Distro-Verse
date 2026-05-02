# Lenovo ThinkBook 15 G4 IAP: The Definitive Trackpad Fix

**Date:** May 2, 2026  
**Hardware:** Lenovo ThinkBook 15 G4 IAP (Intel 12th Gen Alder Lake)  
**Device ID:** `MSFT0001` (I2C HID Touchpad)  
**OS:** CachyOS (Arch-based) - Kernel 7.0.3

---

## 1. The Problem
The trackpad worked perfectly on Windows and Ubuntu but was dead on almost all other Linux distributions (Arch, Fedora, etc.).  
**Key Log Errors identified:**
- `i2c_designware i2c_designware.0: controller timed out`
- `i2c_hid_acpi i2c-MSFT0001:01: can't add hid device: -110`
- `i2c_hid_acpi i2c-MSFT0001:01: probe with driver i2c_hid_acpi failed with error -110`

---

## 2. Thinking Process & Attempts

### Phase 1: The "Standard" HID Fix (Failed)
**Hypothesis:** The ACPI resources were being mismanaged by the kernel, or the legacy PS/2 driver was interfering.  
**Action:** Added `pci=nocrs` and `i8042.nopnp=1`.  
**Reasoning:** `pci=nocrs` tells the kernel to ignore BIOS resource settings that often conflict with I2C devices. `i8042.nopnp=1` prevents the system from trying to treat the modern I2C pad as an old PS/2 mouse.  
**Result:** No change. The timeout error persisted.

### Phase 2: The Lenovo Quirk (Failed)
**Hypothesis:** Lenovo's `ideapad_laptop` module was sending a "touchpad disabled" signal to the kernel, and the I2C clocks weren't initializing fast enough for the 12th Gen CPU.  
**Action:** Added `i2c_designware.clks_pre_pci=1`, `acpi_osi=Linux`, and blacklisted `ideapad_laptop`.  
**Reasoning:** 
- `clks_pre_pci=1` forces early clock initialization for Intel serial buses.
- `acpi_osi=Linux` tricks the BIOS into using the Linux-optimized hardware path.
- Blacklisting `ideapad_laptop` stops a known bug where Lenovo's extra buttons driver accidentally disables the touchpad.  
**Result:** Still nothing. The logs showed the same timeout.

### Phase 3: The Breakthrough - IRQ #27 (The "Smoking Gun")
**Analysis:** Deep inspection of the `journalctl` logs after the second failure revealed a critical line hidden just before the timeout:
> `Disabling IRQ #27`

**Discovery:** On Alder Lake (12th Gen) PCH, the I2C controller and the DMA controller share IRQ 27. The kernel was seeing "spurious interrupts" (noise) on that line and disabling it as a safety measure. This effectively cut the wire to the trackpad.

---

## 3. The Final Solution (The "Golden" Parameters)

To fix this, we had to implement a multi-layered approach to ensure the interrupt line stayed open and the drivers claimed the hardware before the conflict could occur.

### A. The Kernel Command Line
We updated `GRUB_CMDLINE_LINUX_DEFAULT` with:
- `irqpoll`: Forces the kernel to poll for interrupts if the line is noisy.
- `intremap=off`: Disables interrupt remapping, which is often buggy on certain Intel PCH revisions.
- `i2c_designware.clks_pre_pci=1`: Ensures timing is correct.
- `i8042.nopnp=1`: Disables legacy PNP.
- `acpi_osi=Linux`: Enables the correct ACPI path.

### B. Early Initramfs Loading
We modified `/etc/mkinitcpio.conf` to load the drivers at the "Absolute Early Boot" stage:
```bash
MODULES=(pinctrl_alderlake i2c_designware_platform i2c_hid_acpi)
```
This ensures the trackpad driver is active before the system switches from the bootloader to the real OS.

### C. Module Blacklisting
We permanently blacklisted the `ideapad_laptop` module in `/etc/modprobe.d/ideapad-blacklist.conf`.

---

## 4. Summary of Implementation Script
The final fix was automated via a script `fix_trackpad.sh` that:
1. Updated `/etc/default/grub`.
2. Modified `/etc/mkinitcpio.conf`.
3. Added entries to `/etc/modules-load.d/`.
4. Regenerated the boot images using `mkinitcpio -P` and `grub-mkconfig`.

---

## 5. Sources & References
- **Intel LPSS Documentation:** Regarding I2C controller behavior on Alder Lake PCH.
- **Kernel.org Bugzilla:** Reports regarding `INTC1055` and `MSFT0001` IRQ sharing.
- **Arch Wiki:** "Touchpad not detected" section for Lenovo IdeaPad/ThinkBook.
- **System Logs:** `journalctl -b` analysis of IRQ disablement events.

**Status:** FIXED. Trackpad is now fully functional in the "Distro-Verse".
