<!-- 
    WIKI GUIDE: homebrew.md
    Guide to Homebrew package management on Linux - user-space package manager.
    Covers installation, basic usage, and comparison with system package managers.
-->

### Homebrew: The Linux "Brew"

Homebrew (originally for macOS) is a popular package manager for Linux that installs software into its own prefix (usually `/home/linuxbrew/.linuxbrew`). It's a great way to get the latest CLI tools without needing `sudo` or messing with your system's native package manager (Pacman/DNF).

---

## 🤔 Why use Homebrew on Linux?

1.  **User-Space Installs:** Everything lives in your home directory or `/home/linuxbrew`. No `sudo` required after initial setup.
2.  **Mac-Native CLI Tools:** If you follow many web-dev or DevOps tutorials, they often assume you have `brew`.
3.  **Consistent Experience:** If you switch between Arch and Fedora, your Homebrew packages and configurations remain exactly the same.
4.  **Cutting-Edge CLI:** Often has the absolute latest versions of CLI tools (like `fzf`, `gh`, `exa`, etc.) before they hit stable repos.

---

## 🚀 1. Installation

Homebrew requires some build essentials before it can be installed.

### On Arch Linux
```bash
sudo pacman -S --needed base-devel
```

### On Fedora
```bash
sudo dnf groupinstall "Development Tools"
sudo dnf install procps-ng curl file git
```

### Install Command
Run the official installer script:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

## ⚙️ 2. Post-Installation (Crucial)

After the script finishes, it will give you a few lines to add to your shell profile. **Don't skip this!**

**Shell (Bash/Zsh):**
```bash
### Add this to your ~/.bashrc or ~/.zshrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

**Shell (Fish):**
```fish
### Add this to your ~/.config/fish/config.fish
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
```

Then, verify the installation:
```bash
brew doctor
```

---

## 🛠️ 3. Basic Usage

| Task | Command |
| :--- | :--- |
| **Search** | `brew search package_name` |
| **Install** | `brew install package_name` |
| **Update Brew** | `brew update` |
| **Upgrade Apps** | `brew upgrade` |
| **Uninstall** | `brew uninstall package_name` |
| **List Installed** | `brew list` |

---

## 🧹 4. Maintenance

Homebrew doesn't delete old versions of packages automatically. Over time, this can eat up a lot of space in your home directory.

**Clean up old versions and cache:**
```bash
brew cleanup
```

---

## ⚖️ Homebrew vs. Nix vs. AUR

*   **AUR (Arch):** Best for system-deep integration and desktop apps. Fast, but Arch-only.
*   **Nix:** The most powerful and safest, but has a steeper learning curve.
*   **Homebrew:** The easiest "universal" package manager for CLI tools. Very user-friendly and familiar to macOS users.

---

## 🔗 Related Guides
*   📖 **[Nix Guide](nix.md)** - The functional alternative to Homebrew.
*   📖 **[Flatpak Guide](flatpak.md)** - Universal graphical applications.
*   📖 **[Arch Linux Guide](arch.md)** - Setting up build essentials for Brew on Arch.
*   📖 **[Fedora Guide](fedora.md)** - Setting up build essentials for Brew on Fedora.
