# Flatpak: The Universal App Store 📦

Flatpak is a next-generation technology for building and distributing desktop applications on Linux. It allows apps to run in an isolated "sandbox," making them more secure and compatible across any distribution.

---

## 🤔 Why Flatpak?

1.  **Universal Compatibility:** The same app runs exactly the same on Arch, Fedora, Debian, or NixOS.
2.  **Sandbox Security:** Apps are isolated from your system files unless you specifically grant them access.
3.  **Latest Versions:** Apps on Flathub are often updated faster than those in your distro's official repositories.
4.  **Runtime Independence:** Apps bundle their own dependencies, avoiding "dependency hell."

---

## 🚀 1. Installation

### On Arch Linux
```bash
sudo pacman -S flatpak
```

### On Fedora
Flatpak is installed by default.

---

## 📦 2. Setting Up Flathub (The Software Goldmine)

Flathub is the central repository for most Flatpak applications.

**Enable the Full Flathub Repo:**
Fedora often includes a "filtered" version of Flathub. To get access to everything (including proprietary apps like Discord, Steam, or Spotify), run:
```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

---

## 🛠️ 3. Basic Commands

| Task | Command |
| :--- | :--- |
| **Search** | `flatpak search app_name` |
| **Install** | `flatpak install flathub app_id` |
| **Update All** | `flatpak update` |
| **List Installed** | `flatpak list --app` |
| **Uninstall** | `flatpak uninstall app_id` |
| **Clean Unused** | `flatpak uninstall --unused` |

---

## 🔒 4. Permissions & Flatseal

Because Flatpaks are sandboxed, they sometimes need extra permissions (like access to your `~/Documents` or a USB drive).

### Option A: Flatseal (GUI)
The most user-friendly way to manage permissions.
```bash
flatpak install flathub com.github.tchx84.Flatseal
```

### Option B: CLI Overrides
You can manage permissions directly from the terminal.

*   **Grant folder access:**
    ```bash
    flatpak override com.example.App --filesystem=/path/to/folder
    ```
*   **Grant home directory access:**
    ```bash
    flatpak override com.example.App --filesystem=home
    ```
*   **Grant hardware/USB access:**
    ```bash
    flatpak override com.example.App --device=all
    ```
*   **Show current overrides:**
    ```bash
    flatpak override com.example.App --show
    ```
*   **Reset to defaults:**
    ```bash
    flatpak override com.example.App --reset
    ```

---

## 🎨 5. Theming & Aesthetics

Flatpaks sometimes look "out of place" because they don't always pick up your system theme automatically.

**Applying GTK Themes:**
Most popular themes (like Breeze, Adwaita-dark, or Dracula) are available as Flatpak runtimes.
```bash
# Example: Search for your theme
flatpak search org.gtk.Gtk3theme.Breeze
```

**Granting Access to Theme Folders:**
If your theme isn't on Flathub, you can give Flatpaks access to your local theme folders:
```bash
flatpak override --user --filesystem=$HOME/.themes
flatpak override --user --filesystem=$HOME/.icons
```

---

## 🧹 6. Maintenance

Flatpaks can take up a lot of space because they keep old runtimes.

**To free up space:**
```bash
# Removes runtimes that are no longer used by any installed app
flatpak uninstall --unused
```

---

## 🔗 Related Guides
*   📖 **[Snap Guide](snaps.md)** - Canonical's alternative to Flatpak.
*   📖 **[Nix Guide](nix.md)** - Declarative and universal package management.
*   📖 **[Fedora Guide](fedora.md)** - Fedora's deep integration with Flatpak.
*   📖 **[Arch Linux Guide](arch.md)** - Using Flatpak in the Arch ecosystem.
