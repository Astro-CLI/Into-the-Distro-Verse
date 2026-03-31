# Linux Security: AppArmor vs. SELinux

Security modules are essential for hardening your system. This guide covers how to set up **AppArmor** on Arch Linux and provides a reference for **SELinux** on Fedora.

---

## 🛡️ AppArmor (Recommended for Arch Linux)

AppArmor is a Mandatory Access Control (MAC) system that is easy to manage and highly effective. It is the preferred security module for Arch Linux users.

### 1. Installation
Install the core AppArmor packages:
```bash
sudo pacman -S apparmor
```

### 2. Enable in Kernel
You must tell the Linux kernel to initialize AppArmor at boot.
1.  Edit your GRUB configuration: `sudo nano /etc/default/grub`
2.  Add the following to `GRUB_CMDLINE_LINUX_DEFAULT`:
    ```text
    apparmor=1 lsm=lockdown,yama,apparmor,bpf
    ```
3.  Regenerate the GRUB config:
    ```bash
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ```

### 3. Enable the Service
```bash
sudo systemctl enable --now apparmor.service
```

### 4. Advanced Profiles: `apparmor.d-git`
For a comprehensive set of profiles (covering almost every common app), use the `apparmor.d` project from the AUR.
```bash
paru -S apparmor.d-git
```
This package provides hundreds of pre-configured profiles, significantly hardening your system with minimal manual effort.

---

## 🔒 SELinux (Recommended for Fedora)

SELinux (Security-Enhanced Linux) is the default security module for Fedora, RHEL, and CentOS. While extremely powerful, it is **not recommended for Arch Linux** because it requires a custom kernel and can easily break an Arch system if not perfectly configured.

### Using SELinux on Fedora

#### 1. Check Status
To see if SELinux is active and what mode it's in:
```bash
sestatus
```

#### 2. SELinux Modes
-   **Enforcing**: Security policy is enforced. (Default and Recommended)
-   **Permissive**: Security policy is not enforced, but actions are logged. Useful for troubleshooting.
-   **Disabled**: SELinux is completely off.

To temporarily switch to Permissive mode:
```bash
sudo setenforce 0
```

#### 3. Common Fixes (Labeling)
Most SELinux issues on Fedora come from incorrect file labels. To fix the labels on your entire system:
```bash
sudo touch /.autorelabel
# Then reboot
```
Or for a specific directory:
```bash
sudo restorecon -Rv /path/to/directory
```

### ⚠️ Arch Linux Warning
**Do not attempt to install SELinux on your main Arch setup.** 
Arch is designed with AppArmor in mind. SELinux on Arch is a niche use-case that usually results in a non-bootable system for most users. Stick to AppArmor!
