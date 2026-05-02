<!-- 
    WIKI GUIDE: terminal-emulators.md
    Configuration and setup for modern terminal emulators: Ghostty and Kitty.
    Both share a unified keybinding philosophy with Catppuccin Frappe theme.
-->

# Terminal Emulators: Ghostty & Kitty

Modern terminal emulators optimized for speed, aesthetics, and consistency.

---

## 🎨 Theming: Catppuccin Frappe

Both Ghostty and Kitty use **Catppuccin Frappe**, a soothing pastel color scheme.

**Theme Details:**
- **Foreground:** `#C6D0F5` (soft white)
- **Background:** `#303446` (deep blue-black)
- **Accent:** `#CA9EE6` (lavender)

This theme is:
- Built-in to both emulators
- Automatically loaded via config
- Consistent across shells (bash, zsh, fish)

---

## 🐭 Ghostty

Ghostty is a GPU-accelerated, modern terminal with minimal configuration overhead.

### Location
```
~/.config/ghostty/config
```

### Configuration

```conf
theme = Catppuccin Frappe
cursor-style = bar
cursor-style-blink = true
```

**Features:**
- Minimal, clean defaults
- GPU rendering for smooth performance
- Native Wayland support
- Single-file config (no plugins needed)

### Keybindings (Shared with Kitty)

See [Unified Keybindings](#-unified-keybindings) below.

**Ghostty-specific:**
- `ctrl+shift+,` = Open config editor
- `ctrl+shift+i` = Inspector toggle

---

## 🐱 Kitty

Kitty is a GPU-based terminal with powerful extensibility and the **cursor trail** effect Ghostty lacks.

### Location
```
~/.config/kitty/kitty.conf
```

### Configuration

```conf
# Theme
include /tmp/catppuccin-frappe.conf

# Font
font_family      JetBrains Mono Nerd Font
font_size        11

# Cursor (Kitty-specific feature)
cursor_shape     beam
cursor_trail     1

# Shell
shell            /usr/bin/fish

# No close confirmation
confirm_os_window_close 0
```

**Key Features:**
- **Cursor Trail:** Visual feedback when typing (Kitty exclusive!)
- Scriptable with Python
- Advanced color palette management
- Extensive keybinding customization

---

## 🎯 Unified Keybindings

Both emulators share a consistent keybinding philosophy inspired by modern terminal design.

### Font Size Control

| Keybinding | Action |
| :--- | :--- |
| `ctrl+plus` or `ctrl+equal` | Increase font size |
| `ctrl+minus` or `ctrl+underscore` | Decrease font size |
| `ctrl+0` | Reset font size to default |

### Split Management

| Keybinding | Action |
| :--- | :--- |
| `ctrl+shift+e` | Split terminal down (vertical) |
| `ctrl+shift+o` | Split terminal right (horizontal) |
| `ctrl+shift+d` | Close current split |
| `ctrl+shift+z` | Zoom/maximize split focus |
| `ctrl+alt+arrow` | Navigate between splits |

### Tab Management

| Keybinding | Action |
| :--- | :--- |
| `ctrl+shift+t` | New tab |
| `ctrl+shift+w` | Close tab |
| `ctrl+tab` | Next tab |
| `ctrl+shift+tab` | Previous tab |
| `ctrl+page_down` | Next tab |
| `ctrl+page_up` | Previous tab |

### Window Management

| Keybinding | Action |
| :--- | :--- |
| `ctrl+shift+n` | New window |
| `ctrl+shift+q` | Quit |
| `alt+f4` | Close window |
| `ctrl+enter` | Toggle fullscreen |

### Copy/Paste

| Keybinding | Action |
| :--- | :--- |
| `ctrl+shift+c` | Copy to clipboard |
| `ctrl+shift+v` | Paste from clipboard |
| `shift+insert` | Paste from selection |

### Search & Selection

| Keybinding | Action |
| :--- | :--- |
| `ctrl+shift+f` | Open search |
| `ctrl+shift+a` | Select all text |

### Config Management

| Keybinding | Action |
| :--- | :--- |
| `ctrl+shift+,` | Reload config (Ghostty: open editor, Kitty: reload) |

---

## ⚡ Performance Tips

### Ghostty
- Uses GPU acceleration by default
- Minimal startup overhead
- Excellent Wayland performance

### Kitty
- GPU rendering enabled by default
- Consider disabling rarely-used features if performance is critical
- The `cursor_trail` effect is performant even at high scroll speeds

---

## 🔗 Configuration Files

All configs are symlinked from this repository:

```bash
# Ghostty
~/.config/ghostty/config → .../Into-the-Distro-Verse/configs/ghostty/config

# Kitty
~/.config/kitty/kitty.conf → .../Into-the-Distro-Verse/configs/kitty/kitty.conf
```

This allows you to:
- Version control your terminal configs
- Sync settings across machines
- Quickly revert to known-good states

---

## 🛠️ Customization

### Adding Custom Keybindings

**Ghostty:**
Edit `~/.config/ghostty/config` and add:
```conf
keybind = YOUR_KEY=ACTION
```

**Kitty:**
Edit `~/.config/kitty/kitty.conf` and add:
```conf
map YOUR_KEY  ACTION_NAME
```

### Adjusting Font

**Ghostty:**
```conf
font-family = Your Font Name
font-size = 12
```

**Kitty:**
```conf
font_family      Your Font Name
font_size        12
```

### Theme Switching

**Ghostty:**
```conf
theme = Your Theme Name
```

**Kitty:**
```conf
include /path/to/theme.conf
```

---

## 🎓 Why These Two?

| Feature | Ghostty | Kitty |
| :--- | :---: | :---: |
| Cursor Trail | ❌ | ✅ |
| GPU Rendering | ✅ | ✅ |
| Wayland Support | ✅ | ✅ |
| Config Complexity | Low | Medium |
| Extensibility | Native | Python |
| Startup Time | Fast | Fast |

**Choose Ghostty** for minimalism and speed.  
**Choose Kitty** for the cursor trail effect and advanced customization.

---

## 📚 Resources

- **Catppuccin:** https://catppuccin.com
- **Ghostty Docs:** https://ghostty.org
- **Kitty Docs:** https://sw.kovidgoyal.net/kitty/
- **Shell Integration:** See `docs/shells.md`
