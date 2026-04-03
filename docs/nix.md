# Nix: The "Universal" Package Manager

Nix is a powerful, functional package manager that can run on top of any Linux distribution (like Arch or Fedora). It provides access to **Nixpkgs**, the largest and most up-to-date software repository in the Linux world (over 80,000 packages).

---

## 🤔 Why use Nix on Arch or Fedora?

1.  **Massive Selection:** Often has packages that aren't even in the AUR or COPR.
2.  **No "Dependency Hell":** Every package is installed in its own unique directory in `/nix/store`. They never conflict with your system libraries (Pacman/DNF).
3.  **Atomic Rollbacks:** If an update breaks a Nix-installed app, you can roll back to the previous working version instantly.
4.  **Reproducible Shells:** Create a temporary environment with specific tools without actually "installing" them to your system.
5.  **Multi-User:** Users can install software without `sudo` once Nix is set up.

---

## 🚀 1. Installation

### On Arch Linux
Arch has Nix in the official repositories, but it requires a bit of manual setup for the daemon.

```bash
# 1. Install the package
sudo pacman -S nix

# 2. Enable the Nix daemon
sudo systemctl enable --now nix-daemon.service

# 3. Add your user to the nix-users group
sudo usermod -aG nix-users $USER
# (Log out and back in for this to take effect)

# 4. Add the standard channel
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update
```

### On Fedora (Recommended Method)
For Fedora (and any non-NixOS system), the **Determinate Systems Installer** is widely considered the best and safest way to set up Nix with proper uninstall support and modern features enabled.

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

---

## 🛠️ 2. How to Use Nix

Nix has two main ways of being used: **Imperative** (like pacman) and **Declarative/Temporary** (the Nix way).

### A. The Temporary Way (nix-shell)
This is perfect for developers. Need `nodejs` just for one project?
```bash
nix-shell -p nodejs_20
```
This drops you into a shell where `node` is available. Once you type `exit`, it's gone from your path (though still in your store for next time).

### B. The Permanent Way (nix profile)
This is the modern way to "install" an app permanently for your user.
```bash
# Search for a package
nix search nixpkgs discord

# Install a package
nix profile install nixpkgs#discord

# List installed Nix packages
nix profile list

# Upgrade all Nix packages
nix profile upgrade '.*'
```

### C. The Legacy Way (nix-env)
You will see many guides using `nix-env`. It's older but still works:
```bash
nix-env -iA nixpkgs.hello
```

---

## 🧹 3. Maintenance

Since Nix keeps old versions of packages to allow for rollbacks, the `/nix` folder can grow large over time.

**Clean up old versions and unused packages:**
```bash
nix-collect-garbage -d
```

---

## ⚠️ Important Note
Nix packages are usually located in `/nix/store` and linked to your profile. If you are using a GUI app installed via Nix on KDE, you may need to add the Nix desktop files to your path so they show up in your application menu:

```bash
# Add this to your ~/.zshrc or ~/.bashrc if apps don't show in menu
export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
```

---

## 🔗 Related Guides
*   📖 **[Arch Linux Guide](arch.md)** - Native package management on Arch.
*   📖 **[Fedora Guide](fedora.md)** - Native package management on Fedora.
*   📖 **[Flatpak Guide](flatpak.md)** - Another universal app solution.
*   📖 **[Homebrew Guide](homebrew.md)** - CLI-focused universal package manager.
