# Music Streaming Without Ads

Get premium music experiences without the ads, paywalls, or bloat. This guide covers **Spicetify** for Spotify and **YouTube Music** setup.

---

## Table of Contents

1. [Spicetify + Spotify](#spicetify--spotify)
2. [YouTube Music (Web + Desktop)](#youtube-music-web--desktop)
3. [Comparison & Recommendations](#comparison--recommendations)
4. [Troubleshooting](#troubleshooting)

---

## Spicetify + Spotify

**Spicetify** is a command-line tool that customizes the Spotify client, removes ads, and adds powerful extensions.

### Why Spicetify?

- ✅ Remove ads from Spotify client
- ✅ Unlimited skips (on Free tier)
- ✅ Custom themes & visual tweaks
- ✅ UI improvements & extensions
- ✅ Keyboard shortcuts customization
- ✅ Lyrics display
- ✅ Works with Spotify Free or Premium

### Requirements

- Spotify account (Free or Premium)
- Spotify desktop client installed
- Python 3.7+ (for installation)
- curl or git

### Installation

#### Ubuntu/Debian/Arch (Linux)

```bash
# Install Spicetify
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh

# Add to PATH
export PATH="$HOME/.spicetify:$PATH"

# Verify installation
spicetify --version
```

Add to `~/.bashrc` or `~/.zshrc`:
```bash
export PATH="$HOME/.spicetify:$PATH"
```

#### macOS

```bash
brew install spicetify-cli

# Verify
spicetify --version
```

#### Windows (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/spicetify/cli/main/install.ps1 | iex
```

### Initial Setup

1. **Close Spotify completely**
   ```bash
   pkill spotify
   ```

2. **Initialize Spicetify** (first-time setup)
   ```bash
   spicetify init
   spicetify config-dir
   ```

   This creates `~/.config/spicetify/` with configuration files.

3. **Apply the first time**
   ```bash
   spicetify backup apply
   ```

4. **Restart Spotify** and you should see improvements!

### Install Themes

Themes customize Spotify's appearance. Popular options:

#### Theme: Dribbblish (Modern, Sleek)

```bash
cd ~/.config/spicetify/Themes

# Clone the Dribbblish theme
git clone https://github.com/spicetify/spicetify-themes.git

cp -r spicetify-themes/Dribbblish .

# Set the theme
spicetify config current_theme Dribbblish
spicetify config color_scheme dark  # or: light

# Apply
spicetify apply
```

#### Theme: Comfy (Clean, Comfortable)

```bash
cd ~/.config/spicetify/Themes
cp -r spicetify-themes/Comfy .
spicetify config current_theme Comfy
spicetify apply
```

#### Theme: Onepunch (VS Code-inspired)

```bash
cd ~/.config/spicetify/Themes
cp -r spicetify-themes/Onepunch .
spicetify config current_theme Onepunch
spicetify config color_scheme dark
spicetify apply
```

### Install Extensions

Extensions add functionality to Spotify. Install from the marketplace:

```bash
# Navigate to extensions directory
cd ~/.config/spicetify/Extensions

# Clone community extensions
git clone https://github.com/spicetify/spicetify-extensions.git

# Copy desired extensions
cp spicetify-extensions/fullAppDisplay/fullAppDisplay.js .
cp spicetify-extensions/showQueueDuration/showQueueDuration.js .
cp spicetify-extensions/groupSession/groupSession.js .
```

Edit `~/.config/spicetify/config-xpui.ini` and add to `[extensions]`:

```ini
[extensions]
fullAppDisplay.js
showQueueDuration.js
groupSession.js
```

Then apply:
```bash
spicetify apply
```

#### Popular Extensions Explained

| Extension | Purpose |
|-----------|---------|
| **fullAppDisplay** | Show full album art behind player |
| **showQueueDuration** | Display total queue duration |
| **groupSession** | Listen together with friends |
| **keyboardShortcuts** | Custom keyboard shortcuts |
| **hidePodcasts** | Hide podcast recommendations |
| **NowPlayingThumbnail** | Show album art in system tray |

### Remove Ads (Spotify Free)

Edit `~/.config/spicetify/config-xpui.ini`:

```ini
[Patch]
xpui = true
```

Then add to custom apps to block ads:

```bash
spicetify config prevent_ui_themes true
spicetify config expose_apis true
spicetify apply
```

> **Note:** Spicetify modifies the Spotify client locally. Spotify may update and break modifications (rare, but Spicetify updates quickly).

### Custom Keybindings

Create `~/.config/spicetify/Extensions/customKeybinds.js`:

```javascript
// Custom keybindings for Spicetify
Spicetify.Keyboard.registerShortcut({
  key: 'Ctrl+Shift+P',
  callback: () => {
    Spicetify.showNotification('Custom shortcut triggered!');
  }
});
```

Apply:
```bash
spicetify apply
```

### Common Spicetify Commands

```bash
# Show current config
spicetify config-dir

# Apply changes
spicetify apply

# Restore original Spotify (undo Spicetify)
spicetify restore

# Backup before major changes
spicetify backup

# Update Spicetify to latest
spicetify upgrade

# Check status
spicetify status
```

---

## YouTube Music (Web + Desktop)

YouTube Music is Google's Spotify competitor. Free tier includes ads; Premium removes them.

### Why YouTube Music?

- ✅ Free tier available (with ads)
- ✅ Massive music library + music videos
- ✅ Upload your own music
- ✅ Podcasts integrated
- ✅ Works on web, Android, iOS, desktop
- ✅ Cross-device sync (phone → desktop)
- ✅ Cheaper Premium than Spotify in some regions

### Option 1: Web Player (Best Free Alternative)

Simply visit **https://music.youtube.com**

**Ad-blocking on web:**
- Use browser extension: **uBlock Origin** or **Adblock Plus**
- Install and enable on `music.youtube.com`
- Ads will be blocked (mostly)

### Option 2: Desktop App (Linux/macOS/Windows)

#### Linux Installation

**Via Package Manager:**
```bash
# Ubuntu/Debian
sudo apt install youtube-music

# Arch
yay -S youtube-music-desktop-app
# or
paru -S youtube-music-desktop-app

# Fedora
sudo dnf install youtube-music
```

**Via Snap:**
```bash
sudo snap install youtube-music-desktop-app
```

**Via Flatpak:**
```bash
flatpak install flathub com.github.th-ch.YouTubeMusic
flatpak run com.github.th-ch.YouTubeMusic
```

#### macOS Installation

```bash
brew install youtube-music
# or
brew install --cask youtube-music
```

#### Windows Installation

Download from: https://github.com/th-ch/YouTubeMusic/releases

### Desktop App Features

The YouTube Music desktop app (`youtube-music-desktop-app`) includes:

- ✅ Standalone app (doesn't need browser tab)
- ✅ System media controls (play/pause from taskbar)
- ✅ Rich presence (Discord shows what you're listening)
- ✅ Built-in ad blocker (on some versions)
- ✅ Keyboard shortcuts
- ✅ Lyrics display (on hover)
- ✅ Dark mode
- ✅ Tray icon (minimize to system tray)

### Remove Ads on Web

**Easiest: Browser Extension**

1. Install **uBlock Origin**: https://ublockorigin.com/
2. Go to `music.youtube.com`
3. Open uBlock Origin settings
4. Add this filter to "My filters":

```
music.youtube.com##.ytmusic-ad-frame
music.youtube.com##.yt-simple-endpoint.style-scope.ytmusic-desktop-player-header
||adservice.google.com^
```

5. Refresh YouTube Music

**Alternative: Premium (Honest Option)**

If you use YouTube Music regularly, YouTube Premium ($14.99/month) removes ads across YouTube + YouTube Music + supports creators.

### YouTube Music Tips & Tricks

#### Create Playlists

1. Click **Create** → **New playlist**
2. Add songs via **+ Add songs**
3. Share playlist link

#### Upload Your Own Music

1. Go to **Library** → **Uploads**
2. Click **Upload songs**
3. Upload up to 100,000 personal songs
4. Use in playlists & recommendations

#### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Space` | Play/Pause |
| `J` | Next song |
| `K` | Previous song |
| `L` | Like (thumbs up) |
| `D` | Dislike (thumbs down) |
| `+` | Volume up |
| `-` | Volume down |
| `M` | Mute |

#### Use on Mobile

- **Android:** YouTube Music app (free, with ads; Premium removes them)
- **iOS:** YouTube Music app (free, with ads; Premium removes them)
- Sync playlists across devices automatically

---

## Comparison & Recommendations

| Feature | Spotify | YouTube Music |
|---------|---------|---------------|
| **Ad removal (Free)** | ❌ No | ⚠️ Browser extensions |
| **Unlimited skips (Free)** | ✅ With Spicetify | ✅ Yes |
| **Video content** | ❌ No | ✅ Music videos |
| **Upload own music** | ❌ No | ✅ Yes (100k limit) |
| **Podcasts** | ✅ Yes | ⚠️ Limited |
| **UI customization** | ✅ Spicetify | ⚠️ Limited |
| **Lyrics** | ✅ Yes | ✅ Yes |
| **Premium price** | $12.99/mo | $14.99/mo (YouTube Premium) |
| **Desktop app** | ✅ Native | ✅ Third-party app |
| **Linux support** | ✅ Native | ✅ Via third-party app |

### Best Setup for Each User

**🎵 Most Control:**
- **Spotify + Spicetify**: Customize everything, ad-free experience, unlimited skips

**🎬 Music Video Fan:**
- **YouTube Music Premium** or **YouTube Music + uBlock Origin**: Watch music videos, vast library

**💰 Budget-Conscious:**
- **YouTube Music + uBlock Origin**: Free music streaming with no ads (needs browser extension)

**🌍 Everywhere:**
- **Spotify Premium**: Works perfectly on desktop, mobile, web, Alexa, smart speakers

---

## Troubleshooting

### Spicetify: Spotify Doesn't Start After Apply

```bash
# Restore to original
spicetify restore

# Restart Spotify
spotify &

# Check logs
cat ~/.config/spicetify/config-xpui.ini
```

### Spicetify: Extensions Not Loading

```bash
# Verify extensions folder
ls -la ~/.config/spicetify/Extensions/

# Ensure extensions are listed in config
cat ~/.config/spicetify/config-xpui.ini | grep extensions

# Reapply
spicetify apply
```

### YouTube Music: Videos Not Playing

- Clear browser cache: `Ctrl+Shift+Delete`
- Disable extensions temporarily
- Try Incognito mode: `Ctrl+Shift+N`
- Restart the app

### YouTube Music Desktop: No Sound

```bash
# Check audio output
pactl list sinks

# Restart app and try again
pkill youtube-music
youtube-music &
```

### Spicetify: Not Found After Install

Make sure PATH is updated:

```bash
# Check if installed
ls ~/.spicetify/

# Add to PATH manually
export PATH="$HOME/.spicetify:$PATH"

# Make permanent (add to ~/.bashrc or ~/.zshrc)
echo 'export PATH="$HOME/.spicetify:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## Quick Start

### Spicetify (5 minutes)

```bash
# Install
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
export PATH="$HOME/.spicetify:$PATH"

# Setup
spicetify init
spicetify backup apply

# Install theme
cd ~/.config/spicetify/Themes
git clone https://github.com/spicetify/spicetify-themes.git
cp -r spicetify-themes/Dribbblish .
spicetify config current_theme Dribbblish
spicetify apply

# Restart Spotify → Done!
```

### YouTube Music (2 minutes)

```bash
# Install desktop app
sudo apt install youtube-music  # Linux
# or
brew install youtube-music  # macOS

# Open
youtube-music &

# Install uBlock Origin in browser
# Visit music.youtube.com → Enjoy ad-free music!
```

---

## Resources

- **Spicetify GitHub:** https://github.com/spicetify/cli
- **Spicetify Themes:** https://github.com/spicetify/spicetify-themes
- **Spicetify Extensions:** https://github.com/spicetify/spicetify-extensions
- **YouTube Music Desktop:** https://github.com/th-ch/YouTubeMusic
- **uBlock Origin:** https://ublockorigin.com/
- **Spotify Forum:** https://community.spotify.com/

---

**Last Updated:** April 2026  
**Difficulty:** Beginner-Friendly  
**Time to Setup:** 10 minutes total
