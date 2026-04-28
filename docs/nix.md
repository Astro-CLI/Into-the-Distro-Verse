<!-- 
    WIKI GUIDE: nix.md
    This file contains comprehensive information about Nix, the purely functional package manager.
    Nix operates independently of your distribution's native package manager.
-->

# Nix: Functional Package Management and Reproducible Environments

Nix represents a fundamentally different approach to package management through functional programming principles. Unlike imperative package managers (pacman, dnf, apt), Nix treats package definitions as pure functions, ensuring reproducibility and isolation. It provides access to **Nixpkgs**, the largest and most comprehensive software repository in the Linux ecosystem—encompassing over 80,000 packages with exceptional freshness and diversity.

---

## 🤔 Why use Nix?

Nix distinguishes itself through several architectural advantages that transcend distribution boundaries:

1.  **Unprecedented Package Diversity:** Nixpkgs often contains software unavailable through conventional repositories, including cutting-edge development tools and niche applications. Its scale and community contributions frequently exceed traditional distribution repositories.

2.  **Dependency Isolation:** Nix employs content-addressable storage in `/nix/store`, where each package occupies a unique cryptographic namespace. This design eliminates dependency conflicts entirely—installed packages maintain complete isolation from system libraries and one another.

3.  **Deterministic Rollbacks:** Package versions are immutable and referenced by cryptographic hash. Rolling back a broken update to a previous, known-working state requires a single command, with zero risk of partial state corruption.

4.  **Ephemeral Development Environments:** Nix shells create temporary, isolated development environments without modifying your system. These environments are fully reproducible across machines—the same dependencies, versions, and tools every time.

5.  **User-Level Package Installation:** Once the Nix daemon is initialized, individual users can install software without administrative privileges, following the principle of least privilege.

---

## 🚀 Installation & Setup

Nix provides multiple installation pathways depending on your distribution and requirements.

### Arch Linux Installation

Arch packages Nix in its official repositories, though deployment requires manual daemon initialization:

```bash
# 1. Install the Nix package
sudo pacman -S nix

# 2. Enable and start the Nix daemon service
sudo systemctl enable --now nix-daemon.service

# 3. Add your user to the nix-users group for unprivileged package operations
sudo usermod -aG nix-users $USER

# 4. Log out and back in for group membership to take effect
# Then, add the default package channel
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update
```

### Fedora and Generic Linux Installation

The **Determinate Systems Installer** represents the current industry standard for production Nix deployments on non-NixOS systems, providing automated installation, uninstall capabilities, and modern features:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

---

## 🛠️ Usage Patterns

Nix operates through multiple abstraction layers, each serving distinct use cases.

### Ephemeral Environments (nix-shell)

This pattern proves invaluable for development workflows. Rather than polluting your system with project-specific dependencies, nix-shell creates isolated temporary environments that dissolve upon exit:

```bash
# Enter a shell with Node.js available
nix-shell -p nodejs_20

# Within this shell, 'node' and 'npm' are accessible
# Type 'exit' to return to your normal environment
# The packages remain cached for rapid re-entry
```

### Persistent User Profiles (nix profile)

For long-term application management, Nix profiles provide user-level package installation with full version tracking:

```bash
# Search for available packages
nix search nixpkgs discord

# Install a package to your profile
nix profile install nixpkgs#discord

# List your profile's installed packages
nix profile list

# Upgrade all packages to their latest versions
nix profile upgrade '.*'
```

### Legacy Command Interface (nix-env)

Older documentation frequently references `nix-env`, which remains fully functional despite the migration toward declarative profiles:

```bash
nix-env -iA nixpkgs.hello
```

---

## 🧹 Maintenance & Storage Management

Because Nix maintains historical package versions for atomic rollback functionality, the `/nix/store` directory accumulates significant storage over time. Periodic garbage collection reclaims this space while preserving usable package caches:

```bash
# Remove unreferenced package versions and unused runtimes
nix-collect-garbage -d
```

---

## ⚠️ Desktop Integration

Nix-installed GUI applications may not automatically appear in your desktop environment's application launcher. This occurs because desktop entry files reside in non-standard paths. To integrate Nix applications into your launcher:

**For Bash/Zsh:**
```bash
# Add this line to ~/.bashrc or ~/.zshrc
export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"

# Then reload your shell configuration
source ~/.bashrc  # or source ~/.zshrc
```

**For Fish:**
```fish
# Add this line to ~/.config/fish/config.fish
set -gx XDG_DATA_DIRS $HOME/.nix-profile/share $XDG_DATA_DIRS

# Then reload your configuration
source ~/.config/fish/config.fish
```

This configuration ensures that desktop files from Nix packages are properly discovered during application menu initialization.

---

## 🔗 Related Guides

*   📖 **[Arch Linux Guide](arch.md)** - Native package management and system administration on Arch.
*   📖 **[Fedora Guide](fedora.md)** - DNF-based package management and Fedora-specific optimizations.
*   📖 **[Debian Guide](debian.md)** - APT repository management for stable-release systems.
*   📖 **[Flatpak Guide](flatpak.md)** - Containerized application deployment as an alternative to Nix.
*   📖 **[Homebrew Guide](homebrew.md)** - Cross-platform package manager with CLI-centric design.
