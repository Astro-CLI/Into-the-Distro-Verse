### Video Streaming Without Paywalls

Stream movies, TV shows, and live content across all your devices—legally and ad-free. This guide covers **Stremio**, **Debrid services**, and open-source alternatives.

---

## Table of Contents

1. [Stremio Overview](#stremio-overview)
2. [Debrid Services](#debrid-services)
3. [Stremio + Debrid Setup](#stremio--debrid-setup)
4. [Alternative Video Streaming](#alternative-video-streaming)
5. [Troubleshooting](#troubleshooting)

---

## Stremio Overview

**Stremio** is an open-source media center app that aggregates content from multiple sources—movies, TV shows, live channels, YouTube, and more.

### Why Stremio?

- ✅ Free, open-source media player
- ✅ Unified interface for all your content
- ✅ Addon ecosystem (200+ community addons)
- ✅ Cross-platform (Windows, macOS, Linux, Android, iOS, Fire TV, Raspberry Pi)
- ✅ Syncs watchlist & progress across devices
- ✅ No ads (unless addon provides them)
- ✅ Legal alternative to traditional piracy (with right addons)

### Requirements

- Stremio account (free)
- Stremio app (desktop, mobile, or web)
- Optional: Debrid subscription ($2-8/month)
- Optional: VPN (for extra privacy)

### Installation

#### Linux

**Via APT (Ubuntu/Debian):**
```bash
sudo apt install stremio
stremio &
```

**Via Snap:**
```bash
sudo snap install stremio
stremio &
```

**Via Flatpak:**
```bash
flatpak install flathub com.stremio.Stremio
flatpak run com.stremio.Stremio
```

**Via Arch:**
```bash
yay -S stremio
stremio &
```

#### macOS

```bash
brew install stremio
# or
brew install --cask stremio
```

#### Windows

Download from: https://www.stremio.com/downloads

#### Android/iOS

Download from Google Play Store or Apple App Store (free)

#### Fire TV / Raspberry Pi

Available on Amazon Appstore and community builds.

### First Launch Setup

1. **Create free Stremio account** at https://www.stremio.com
2. **Open Stremio app** → Sign in
3. **Browse catalog** (built-in content from YouTube, official services, etc.)
4. **Install addons** (see [Popular Addons](#popular-addons) section)
5. **Enjoy!**

---

## Debrid Services

**Debrid** services are cloud storage providers that let you download and stream content—think of them as the backbone for modern streaming.

### What is Debrid?

Debrid services like **Real-Debrid** and **Alldebrid** work by:
1. You upload/point to a video file
2. Service downloads it to their cloud servers
3. You stream it directly (fast, since it's on their servers)
4. Never need to store files locally
5. All content is already on their servers (instant access)

### Popular Debrid Services

| Service | Price | Speed | Support | Best For |
|---------|-------|-------|---------|----------|
| **Real-Debrid** | €3.99-16/mo | ⭐⭐⭐⭐⭐ Very fast | Excellent | Best all-around; VPN, torrent support |
| **Alldebrid** | €1.99-14/mo | ⭐⭐⭐⭐ Fast | Good | Budget option; good speed |
| **Premiumize.me** | €9.99-120/mo | ⭐⭐⭐⭐ Very fast | Excellent | Premium option; VIP support |
| **Offcloud** | $9.99-40/mo | ⭐⭐⭐⭐ Fast | Good | Cloud storage + streaming |

### Real-Debrid (Best Value)

**Installation:**

1. Create account at https://real-debrid.com (free trial available)
2. Choose plan: €3.99/month (minimum)
3. Verify email
4. Get API key from settings

**Setup with Stremio:**

In Stremio → Settings → Addons → Search for "Real-Debrid" addon
- Install "Stremio Real-Debrid Addon"
- Paste your API key
- Done!

### Alldebrid (Budget Option)

**Installation:**

1. Create account at https://alldebrid.com
2. Choose plan: €1.99/month (minimum)
3. Verify email
4. Generate API key

**Setup with Stremio:**

In Stremio → Settings → Addons → Search for "Alldebrid"
- Install addon
- Paste API key
- Done!

---

## Stremio + Debrid Setup

### Complete Setup Guide (15 minutes)

#### Step 1: Install Stremio

```bash
# Linux
sudo apt install stremio

# macOS
brew install stremio

# Then launch
stremio &
```

#### Step 2: Create Free Stremio Account

- Visit https://www.stremio.com
- Click "Sign Up"
- Enter email + password
- Verify email
- Log in to Stremio app

#### Step 3: Get Debrid (Optional but Recommended)

Choose one:

**Option A: Real-Debrid** (fastest, best support)
```
1. Go to https://real-debrid.com
2. Click "Sign Up"
3. Choose €3.99/month plan (or try free trial)
4. Verify email
5. Go to Settings → API Token
6. Copy your token
```

**Option B: Alldebrid** (budget option)
```
1. Go to https://alldebrid.com
2. Sign up
3. Choose €1.99/month plan
4. Generate API key from dashboard
5. Copy key
```

#### Step 4: Install Stremio Addons

In Stremio, go to **Addons** (top menu)

**Install these essential addons:**

1. **Real-Debrid or Alldebrid** (for streaming)
   - Search: "Real-Debrid" or "Alldebrid"
   - Click install
   - Paste your API key
   - ✅ Enable

2. **Torrentio** (for torrent streaming)
   - Search: "Torrentio"
   - Install
   - ✅ Enable
   - (Works best with Debrid service)

3. **OpenSubtitles** (for subtitles)
   - Search: "OpenSubtitles"
   - Install
   - ✅ Enable

4. **YTS** (for movies)
   - Search: "YTS"
   - Install
   - ✅ Enable

5. **EZTV** (for TV shows)
   - Search: "EZTV"
   - Install
   - ✅ Enable

#### Step 5: Browse & Watch

1. Go to **Discover** or **Search**
2. Find a movie or show
3. Click to see available streams
4. Click **Play** on any stream
5. Enjoy!

### Popular Addons Explained

| Addon | Type | Content | Quality |
|-------|------|---------|---------|
| **Torrentio** | Torrent | Movies, TV, Anime | ⭐⭐⭐⭐⭐ Best quality |
| **YTS** | Movies | Movies | ⭐⭐⭐⭐ Good quality |
| **EZTV** | TV Shows | TV Shows | ⭐⭐⭐⭐ Good quality |
| **Movie-Web** | Scraper | Movies, TV | ⭐⭐⭐ Streaming |
| **CinemaPlus** | Scraper | Movies, TV | ⭐⭐⭐ Streaming |
| **StreamRepay** | Torrent | Movies, TV | ⭐⭐⭐⭐ Good |
| **OpenSubtitles** | Subtitles | Multi-language | ✅ Essential |
| **YouTube** | Built-in | Trailers, music | ✅ Included |

### Best Addon Combinations

**🎬 Movie Watcher:**
- Torrentio + Real-Debrid
- YTS
- OpenSubtitles

**📺 TV Show Binger:**
- Torrentio + Real-Debrid
- EZTV
- Movie-Web
- OpenSubtitles

**🌍 Anime Enthusiast:**
- Torrentio + Real-Debrid
- AniList (anime catalog)
- OpenSubtitles (for JP audio)

**💰 Budget Setup** (no paid Debrid):
- Movie-Web
- CinemaPlus
- StreamRepay
- OpenSubtitles

---

## Alternative Video Streaming

### Jellyfin (Self-Hosted)

**What:** Open-source media server. Host your own movies/shows on a home server.

**Installation (Ubuntu/Debian):**

```bash
# Add repository
curl https://repo.jellyfin.org/ubuntu/jellyfin_ubuntu_amd64.keyring.gpg | sudo apt-key add -
echo "deb [arch=amd64] https://repo.jellyfin.org/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/jellyfin.list

# Install
sudo apt update
sudo apt install jellyfin

# Start service
sudo systemctl start jellyfin
sudo systemctl enable jellyfin

# Access at http://localhost:8096
```

**Linux (Docker):**

```bash
docker run -d \
  --name jellyfin \
  -p 8096:8096 \
  -v /path/to/media:/media \
  -v jellyfin-config:/config \
  jellyfin/jellyfin
```

**macOS (Homebrew):**

```bash
brew install jellyfin
brew services start jellyfin
```

**Features:**
- ✅ Self-hosted (full control)
- ✅ No ads
- ✅ Organize your own content
- ✅ Stream to any device
- ✅ Multi-user support
- ✅ Free, open-source

**Best For:** Storing personal movies, home media library, family media server

---

### Plex (Freemium)

**What:** Media server + streaming platform. Free or Premium ($5.99/month).

**Installation:**

Visit https://www.plex.tv/downloads

- Download for your OS
- Create account
- Point to media folder
- Stream to devices

**Free Features:**
- Self-hosted media server
- Stream to your devices
- Basic organization

**Premium Features:** ($5.99/month)
- Remote access (outside home network)
- Premium plugins
- Early access to features

**Best For:** Home media + some cloud streaming

---

### Kaleidescape (Premium)

**What:** Ultra-premium home theater solution ($25,000+).

**Features:**
- Unlimited legal movie streaming
- 4K/8K support
- No DRM headaches
- Perfect lossless image/audio
- Theater-grade system

**Best For:** Serious home theater enthusiasts with budget

---

### Open Source Alternatives

| Service | Type | Install | Best For |
|---------|------|---------|----------|
| **Jellyfin** | Self-hosted | apt/Docker/brew | Personal media library |
| **Emby** | Self-hosted | Download | Home server (freemium) |
| **Kodi** | Media Center | Download | TV/HTPC setup |
| **TVHeadend** | PVR/DVR | apt/Docker | Live TV + recording |

---

## Troubleshooting

### Stremio: No Streams Available

**Problem:** Search shows movie, but no streams available.

**Solutions:**
1. Install addons (Torrentio, YTS, EZTV)
2. Get a Debrid subscription (Real-Debrid recommended)
3. Check addon is enabled (Settings → Addons)
4. Wait a few seconds (indexing takes time)

```bash
# Restart Stremio
pkill stremio
stremio &
```

### Real-Debrid: API Key Not Working

```
1. Go to https://real-debrid.com/settings
2. Scroll to "API Token"
3. Generate new token
4. Copy full token (with quotes if present)
5. Paste in Stremio addon
```

### Stremio: Streams Buffering

**Causes:**
- Internet speed too low (need 5+ Mbps for 1080p)
- Debrid service slow
- Add-on quality setting too high

**Solutions:**
- Lower video quality in Stremio player
- Try different stream source
- Switch Debrid service
- Use VPN (sometimes faster)

### Stremio: Not Finding Content

**Problem:** Search doesn't show popular movies/shows.

**Solutions:**
1. Check addon is installed + enabled
2. Refresh Stremio (restart app)
3. Wait (takes ~5 seconds to index)
4. Try alternative addon (YTS for movies, EZTV for TV)
5. Search by exact title

### Jellyfin: Slow Performance

```bash
# Hardware acceleration (if GPU available)
# In Jellyfin web UI:
# Admin → Dashboard → Playback
# Enable "Enable Hardware Encoding"

# Or restart with GPU support
docker run -d \
  --name jellyfin \
  -p 8096:8096 \
  --device /dev/dri:/dev/dri \  # GPU access
  -v /media:/media \
  jellyfin/jellyfin
```

### Plex: Remote Access Not Working

```
1. Go to https://app.plex.tv
2. Sign in
3. Go to Settings → Remote Access
4. Click "Enable Remote Access"
5. Check if green (enabled)
```

---

## Streaming Quality Comparison

| Service | Video Quality | Startup | Ads | Cost |
|---------|---------------|---------|-----|------|
| **Stremio + Debrid** | Up to 4K | ⚡ 1-5s | None | $4-8/mo |
| **Jellyfin** | Up to 4K | ⚡ 1-2s | None | Free |
| **Plex Free** | Up to 1080p | ⚡ 2-5s | None* | Free |
| **Plex Premium** | Up to 4K | ⚡ 2-5s | None | $5.99/mo |
| **Netflix** | Up to 4K | ⚡ 2-3s | None | $6.99-22/mo |
| **Disney+** | Up to 4K | ⚡ 2-3s | None | $7.99-13.99/mo |

*Plex Premium content may have ads unless you upgrade

---

## Legal Note

**⚠️ Important:**

- **Stremio itself is legal.** It's an open-source media player.
- **Addons vary in legality:**
  - ✅ Legal: YTS, EZTV, OpenSubtitles, official YouTube addon
  - ⚠️ Gray Area: Torrentio (depends on content source & local laws)
  - ❌ Illegal: Streaming pirated content knowingly

**Recommendations:**
- Use **Real-Debrid** (legitimate cloud streaming service)
- Choose **legal addon sources** (official repos)
- Check your **local laws** before using torrent addons
- Consider **VPN** for extra privacy
- Support creators by paying for official services

---

## Quick Start

### Stremio (10 minutes)

```bash
# Install
sudo apt install stremio

# Launch
stremio &

# Then:
# 1. Create free account at stremio.com
# 2. Install Real-Debrid addon (Settings → Addons)
# 3. Install Torrentio addon
# 4. Browse & watch!
```

### Jellyfin (15 minutes)

```bash
# Via Docker (easiest)
docker run -d \
  --name jellyfin \
  -p 8096:8096 \
  -v /path/to/movies:/media \
  -v jellyfin-config:/config \
  jellyfin/jellyfin

# Access at http://localhost:8096
# Create account, add media library, enjoy!
```

---

## Resources

- **Stremio:** https://www.stremio.com
- **Real-Debrid:** https://real-debrid.com
- **Alldebrid:** https://alldebrid.com
- **Torrentio Addon:** https://torrentio.strem.fun
- **Jellyfin:** https://jellyfin.org
- **Plex:** https://www.plex.tv
- **Kodi:** https://kodi.tv

---

**Last Updated:** April 2026  
**Difficulty:** Beginner-Friendly (Stremio), Intermediate (Jellyfin)  
**Time to Setup:** 10-15 minutes for Stremio, 20 minutes for Jellyfin
