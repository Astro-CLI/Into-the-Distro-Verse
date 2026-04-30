### 🎬 Streaming Services Guide

Get premium content without ads or paywalls. Everything you need to stream music, movies, and TV shows across all your devices.

---

## 📚 Guides

### [🎵 Music Streaming](music.md)
Stream music ad-free: Spotify with Spicetify customization and YouTube Music.

**Covers:**
- **Spicetify:** Customize Spotify, remove ads, unlimited skips (Free tier)
- **YouTube Music:** Music videos, upload your own songs, $14.99/mo Premium
- Theme installation (Dribbblish, Comfy, Onepunch)
- Desktop apps for Linux/macOS/Windows
- Keyboard shortcuts & troubleshooting

**Best for:** Music lovers who want to customize or go ad-free

---

### [🎬 Video Streaming](video.md)
Watch movies & TV shows: Stremio with Debrid services, self-hosted alternatives.

**Covers:**
- **Stremio:** Open-source media center with addon ecosystem
- **Real-Debrid & Alldebrid:** Cloud streaming for instant access
- Complete setup guide (15 minutes)
- Popular addons (Torrentio, YTS, EZTV, OpenSubtitles)
- Self-hosted alternatives (Jellyfin, Plex, Kodi)
- Troubleshooting & legal considerations

**Best for:** Movie/TV show watchers wanting unified interface & fast streams

---

## 🚀 Quick Comparison

| Service | Type | Price | Ads | Setup Time |
|---------|------|-------|-----|------------|
| **Spicetify** | Music customization | Free | ✅ Removes | 5 min |
| **YouTube Music** | Music streaming | $14.99/mo | Free tier has ads | 2 min |
| **Stremio + Debrid** | Video streaming | $4-8/mo | None | 15 min |
| **Jellyfin** | Self-hosted video | Free | None | 20 min |
| **Plex** | Self-hosted video | Free / $5.99/mo | None | 15 min |

---

## 🎯 Choose Your Path

**🎵 I want to listen to music ad-free:**
→ [Music Streaming Guide](music.md)

**🎬 I want to watch movies & TV instantly:**
→ [Video Streaming Guide](video.md) (Stremio section)

**🏠 I have my own media collection:**
→ [Video Streaming Guide](video.md) (Jellyfin/Plex section)

**💰 I want everything for free:**
→ See each guide's "Budget Setup" section

---

## 🔧 Recommended Setups

### 🎵 The Music Lover
- **Primary:** Spotify + Spicetify (customized experience)
- **Backup:** YouTube Music (for music videos)
- **Cost:** $12.99/mo (Spotify) + Free (YT Music) = $12.99/mo

### 🎬 The Movie Binger
- **Primary:** Stremio + Real-Debrid (fast, best quality)
- **Addons:** Torrentio, YTS, EZTV, OpenSubtitles
- **Cost:** $3.99/mo (Real-Debrid) = $3.99/mo

### 🏠 The Home Theater
- **Primary:** Jellyfin (self-hosted, free)
- **Backup:** Plex (remote access, freemium)
- **Cost:** Free (if you have media) or storage costs

### 🌟 The All-In-One
- **Music:** Spicetify + YouTube Music
- **Movies/TV:** Stremio + Debrid
- **Backup:** Jellyfin for personal media
- **Cost:** ~$17-22/mo total

---

## 📖 Features at a Glance

### Music

| Feature | Spicetify | YouTube Music |
|---------|-----------|---------------|
| Ad removal | ✅ Yes | ⚠️ Needs uBlock |
| Customization | ✅ Themes/extensions | ❌ Limited |
| Music videos | ❌ No | ✅ Yes |
| Upload own music | ❌ No | ✅ Up to 100k |
| Cross-device sync | ✅ Yes | ✅ Yes |
| Offline | ✅ Yes (Premium) | ✅ Yes (Premium) |

### Video

| Feature | Stremio | Jellyfin | Plex |
|---------|---------|----------|------|
| Setup complexity | ⭐ Simple | ⭐⭐ Medium | ⭐⭐ Medium |
| Library | 200+ addons | Personal media | Personal media |
| Video quality | Up to 4K | Up to 4K | Up to 4K |
| Subtitles | ✅ Multi-language | ✅ Yes | ✅ Yes |
| Remote access | ✅ With account | ❌ Local only | ✅ Free |
| Cost | $4-8/mo | Free | Free/$5.99/mo |
| Open-source | ✅ Yes | ✅ Yes | ❌ Proprietary |

---

## 🛠️ Installation Reference

### Music

```bash
### Spicetify (5 minutes)
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
spicetify init && spicetify backup apply

### YouTube Music (2 minutes)
sudo apt install youtube-music  # or brew install youtube-music
```

### Video

```bash
### Stremio (5 minutes)
sudo apt install stremio
stremio &  # Then create account at stremio.com

### Jellyfin (15 minutes, Docker)
docker run -d --name jellyfin -p 8096:8096 \
  -v /path/to/media:/media \
  jellyfin/jellyfin
```

---

## 💡 Pro Tips

✅ **Use both music & video guides** for complete setup  
✅ **Get Debrid subscription** (Real-Debrid recommended) for best video quality  
✅ **Install OpenSubtitles addon** for any language subtitles  
✅ **Use VPN** with streaming for extra privacy  
✅ **Check local laws** before using torrent addons  
✅ **Support creators** by using official services when possible  

---

## 📝 Legal Considerations

- ✅ **Stremio, Jellyfin, Plex:** 100% legal (just software)
- ⚠️ **Real-Debrid:** Legal streaming service (cloud storage + streaming)
- ⚠️ **Addon content:** Depends on content source (check laws)
- ❌ **Knowingly streaming pirated content:** Illegal in most countries

**Recommendations:** Use legal addon sources, consider VPN, support creators via Premium subscriptions.

---

**Last Updated:** April 2026  
**Status:** Complete & Ready to Use  
**Reading Time:** ~30 minutes (combined)
