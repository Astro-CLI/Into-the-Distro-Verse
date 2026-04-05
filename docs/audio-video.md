# Audio & Video Production Setup 🎵🎬

A comprehensive guide for setting up professional audio and video workflows on Linux, covering audio servers, effects, recording, and content creation tools.

---

## 🔊 Audio Server Comparison: PipeWire vs PulseAudio

### PipeWire (Modern, Recommended)
**PipeWire** is the modern audio/video server for Linux, designed to replace both PulseAudio and JACK. It's now the default on most major distributions.

**Advantages:**
- **Low Latency:** Professional-grade audio latency comparable to JACK
- **Universal Routing:** Handles audio AND video streams
- **Compatibility:** Works with both PulseAudio and JACK applications
- **Screen Sharing:** Better Wayland support for screen capture
- **Bluetooth:** Superior Bluetooth codec support (LDAC, aptX HD)

**When to Use PipeWire:**
- Modern systems (Fedora 34+, Ubuntu 22.10+, Arch Linux)
- Pro-audio work requiring low latency
- Wayland desktop environments
- Modern Bluetooth devices

### PulseAudio (Legacy, Still Widely Used)
**PulseAudio** is the traditional audio server, stable and well-tested.

**Advantages:**
- **Maturity:** Years of refinement and stability
- **Compatibility:** Works out-of-the-box on older systems
- **Documentation:** Extensive troubleshooting resources

**When to Use PulseAudio:**
- Older distributions or LTS releases
- Maximum stability over features
- Legacy hardware compatibility issues

### Checking Your Current Audio Server
```bash
# Check if PipeWire is running
pactl info | grep "Server Name"

# Or check processes
ps aux | grep -E "pipewire|pulseaudio"
```

---

## 🎛️ PipeWire Setup & Tools

### Installing PipeWire (Arch)
```bash
# Core PipeWire packages
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

# Optional but recommended
sudo pacman -S pipewire-audio pipewire-v4l2 pipewire-x11-bell

# Real-time priority (for pro-audio)
sudo pacman -S realtime-privileges
sudo usermod -aG realtime $USER
```

### Installing PipeWire (Fedora)
```bash
# Usually pre-installed, but to ensure everything:
sudo dnf install pipewire pipewire-alsa pipewire-pulseaudio wireplumber
```

### Installing PipeWire (Debian/Ubuntu)
```bash
# Ubuntu 22.10+ and Debian 12+
sudo apt install pipewire pipewire-audio-client-libraries wireplumber

# Replace PulseAudio with PipeWire
sudo apt install pipewire-pulse
```

### PipeWire Control Tools

#### Helvum (Visual Patchbay)
A beautiful GTK patchbay for routing audio/video streams graphically.
```bash
# Arch
sudo pacman -S helvum

# Fedora
sudo dnf install helvum

# Flatpak (all distros)
flatpak install flathub org.pipewire.Helvum
```

#### qpwgraph (Qt Alternative)
Similar to Helvum but using Qt, inspired by QjackCtl.
```bash
# Arch
sudo pacman -S qpwgraph

# Flatpak
flatpak install flathub org.rncbc.qpwgraph
```

#### WirePlumber Configuration
WirePlumber is the session/policy manager for PipeWire.
```bash
# View current configuration
wpctl status

# Set default sink (output)
wpctl set-default <SINK_ID>

# Adjust volume
wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%
```

### Low-Latency Configuration
Create or edit `~/.config/pipewire/pipewire.conf.d/10-low-latency.conf`:
```conf
context.properties = {
    default.clock.rate = 48000
    default.clock.quantum = 256
    default.clock.min-quantum = 128
    default.clock.max-quantum = 512
}
```

Restart PipeWire:
```bash
systemctl --user restart pipewire pipewire-pulse wireplumber
```

---

## 🎚️ PulseAudio Tools (Legacy)

### Installing PulseAudio
```bash
# Arch
sudo pacman -S pulseaudio pulseaudio-alsa

# Fedora
sudo dnf install pulseaudio pulseaudio-utils

# Debian/Ubuntu
sudo apt install pulseaudio pavucontrol
```

### PulseAudio Control Tools

#### pavucontrol (Essential GUI)
The standard volume and device manager for PulseAudio.
```bash
# Arch
sudo pacman -S pavucontrol

# Debian/Ubuntu
sudo apt install pavucontrol
```

#### Command-Line Controls
```bash
# List sinks (outputs)
pactl list sinks short

# Set default sink
pactl set-default-sink <SINK_NAME>

# Adjust volume
pactl set-sink-volume @DEFAULT_SINK@ 50%

# Mute/unmute
pactl set-sink-mute @DEFAULT_SINK@ toggle
```

---

## ✨ EasyEffects (Audio Enhancement)

**EasyEffects** (formerly PulseEffects) provides professional audio effects for your desktop: equalization, compression, reverb, and more.

### Installation
```bash
# Arch
sudo pacman -S easyeffects

# Fedora
sudo dnf install easyeffects

# Debian/Ubuntu
sudo apt install easyeffects

# Flatpak (all distros)
flatpak install flathub com.github.wwmm.easyeffects
```

### Essential Plugins
```bash
# Arch - LSP (Linux Studio Plugins)
sudo pacman -S lsp-plugins lv2 calf

# Additional effects
sudo pacman -S zam-plugins
```

### Popular Presets
- **AutoEQ:** Headphone equalization based on measurements
  - GitHub: [AutoEQ Presets](https://github.com/jaakkopasanen/AutoEq)
- **Bass Boost:** Enhanced low-frequency response
- **Voice Clarity:** Noise reduction and compression for calls

### Pro Tips
- Enable **Crystal Gate** to reduce background noise during calls
- Use **Bass Enhancer** for music without distortion
- Create separate presets for music, gaming, and communication

---

## 🎙️ Pro-Audio Production

### Linux Audio Real-Time Setup
```bash
# Arch - Install realtime-privileges
sudo pacman -S realtime-privileges
sudo usermod -aG realtime $USER

# Edit limits
sudo nano /etc/security/limits.d/audio.conf
```

Add:
```conf
@realtime   -  rtprio     95
@realtime   -  memlock    unlimited
```

Reboot to apply changes.

### JACK Audio Connection Kit
While PipeWire replaces JACK for most users, pure JACK may still be preferred for specialized studio work.

```bash
# Arch
sudo pacman -S jack2 qjackctl

# Fedora
sudo dnf install jack-audio-connection-kit qjackctl

# Using JACK with PipeWire (recommended)
# PipeWire's JACK compatibility is usually sufficient
```

---

## 🎹 Digital Audio Workstations (DAWs)

### Ardour (Professional, Open Source)
Full-featured DAW for recording, editing, and mixing.
```bash
# Arch
sudo pacman -S ardour

# Flatpak
flatpak install flathub org.ardour.Ardour
```
**Best for:** Multi-track recording, professional mixing, post-production

### Reaper (Commercial, Linux-friendly)
Industry-standard DAW with excellent Linux support.
```bash
# Download from reaper.fm
# Extract and run the installer
./install-reaper.sh
```
**Best for:** Professional production, extensive plugin support, customization

### LMMS (Beginner-Friendly)
Free DAW focused on electronic music production.
```bash
# Arch
sudo pacman -S lmms

# Flatpak
flatpak install flathub io.lmms.LMMS
```
**Best for:** Beat making, EDM production, beginners

### Bitwig Studio (Commercial)
Modern DAW with innovative features and excellent Linux support.
```bash
# Download from bitwig.com
# .deb package for Debian/Ubuntu
# Flatpak also available
flatpak install flathub com.bitwig.BitwigStudio
```
**Best for:** Electronic music, modular synthesis, live performance

### Rosegarden (MIDI-focused)
MIDI sequencer and music composition tool.
```bash
# Arch
sudo pacman -S rosegarden

# Debian/Ubuntu
sudo apt install rosegarden
```
**Best for:** MIDI composition, notation, traditional scoring

### Audacity (Audio Editing)
The classic audio editor for quick edits and recording.
```bash
# Arch
sudo pacman -S audacity

# Flatpak
flatpak install flathub org.audacityteam.Audacity
```
**Best for:** Podcast editing, simple recording, audio cleanup

---

## 🎸 Audio Plugins & Virtual Instruments

### Plugin Formats
- **LV2:** Linux-native plugin standard (recommended)
- **VST2/VST3:** Proprietary but widely supported
- **LADSPA:** Legacy Linux plugin format

### Essential Plugin Collections
```bash
# Arch - Comprehensive plugin packages
sudo pacman -S lsp-plugins # Professional effects
sudo pacman -S calf        # Vintage-style effects
sudo pacman -S zam-plugins # Mastering tools
sudo pacman -S x42-plugins # Utility plugins
sudo pacman -S mda.lv2     # Classic synths and effects
```

### Virtual Instruments
```bash
# ZynAddSubFX - Powerful synthesizer
sudo pacman -S zynaddsubfx

# Yoshimi - Real-time software synthesizer
sudo pacman -S yoshimi

# Helm - Polyphonic synthesizer
paru -S helm-synth-git
```

### VST Support (Wine/LinVST)
For Windows VST plugins:
```bash
# Yabridge - Windows VST bridge
paru -S yabridge

# Configure yabridge
yabridgectl add "$HOME/.wine/drive_c/Program Files/VSTPlugins"
yabridgectl sync
```

---

## 🎬 Video Production & Streaming

### OBS Studio (Streaming & Recording)
The industry-standard for streaming and screen recording.

#### Installation
```bash
# Arch
sudo pacman -S obs-studio

# Fedora
sudo dnf install obs-studio

# Debian/Ubuntu (official PPA)
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install obs-studio

# Flatpak (all distros)
flatpak install flathub com.obsproject.Studio
```

#### Essential Plugins
```bash
# Arch - Popular OBS plugins
paru -S obs-plugin-input-overlay  # Show keyboard/mouse input
paru -S obs-plugin-looking-glass  # VM capture
paru -S obs-vkcapture             # Vulkan game capture
paru -S obs-backgroundremoval     # AI background removal

# obs-websocket (remote control)
sudo pacman -S obs-websocket
```

#### Wayland Screen Capture
```bash
# Install PipeWire screen capture support
sudo pacman -S xdg-desktop-portal xdg-desktop-portal-gtk

# For KDE Plasma
sudo pacman -S xdg-desktop-portal-kde

# For GNOME
sudo pacman -S xdg-desktop-portal-gnome
```

#### OBS Configuration Tips
1. **Settings → Output → Recording:**
   - Format: `mkv` or `mp4`
   - Encoder: `x264` (CPU) or `NVENC/VAAPI` (GPU)
   - Quality: `High` or `Indistinguishable`

2. **Settings → Video:**
   - Base Resolution: Your monitor resolution
   - Output Resolution: `1920x1080` for most use cases
   - FPS: `30` (talking head) or `60` (gaming)

3. **Settings → Audio:**
   - Sample Rate: `48000 Hz`
   - Channels: `Stereo`

### Kdenlive (Video Editing)
Professional non-linear video editor, KDE project.
```bash
# Arch
sudo pacman -S kdenlive

# Flatpak
flatpak install flathub org.kde.kdenlive
```

### DaVinci Resolve (Professional, Commercial)
Industry-standard color grading and editing suite.
```bash
# Download from blackmagicdesign.com
# Requires manual installation
# Works best on NVIDIA GPUs
```

### Blender (3D & Video Editing)
Excellent video sequence editor in addition to 3D capabilities.
```bash
# Arch
sudo pacman -S blender

# Flatpak
flatpak install flathub org.blender.Blender
```

### Shotcut (Beginner-Friendly)
Simple, cross-platform video editor.
```bash
# Arch
sudo pacman -S shotcut

# Flatpak
flatpak install flathub org.shotcut.Shotcut
```

---

## 🎥 Screen Recording & Capture

### SimpleScreenRecorder
Lightweight, efficient screen recorder.
```bash
# Arch
sudo pacman -S simplescreenrecorder

# Debian/Ubuntu
sudo apt install simplescreenrecorder
```

### GPU Screen Record
Minimal GPU-accelerated screen recorder.
```bash
# Arch (AUR)
paru -S gpu-screen-recorder-git
```

### Kooha (Wayland-native)
GNOME-style screen recorder for Wayland.
```bash
# Flatpak
flatpak install flathub io.github.seadve.Kooha
```

---

## 🎨 Additional Tools

### Video Converters
```bash
# FFmpeg (essential)
sudo pacman -S ffmpeg

# HandBrake (GUI converter)
sudo pacman -S handbrake

# Flatpak HandBrake
flatpak install flathub fr.handbrake.ghb
```

### Audio Converters
```bash
# SoundConverter
sudo pacman -S soundconverter

# fre:ac (comprehensive)
flatpak install flathub org.freac.freac
```

### Noise Reduction
```bash
# NoiseTorch (real-time noise suppression)
paru -S noisetorch

# Run NoiseTorch
noisetorch -i
```

---

## 🎯 Quick Start Guide

### For Music Production
1. Install **PipeWire** + **EasyEffects**
2. Configure **real-time privileges**
3. Install **Ardour** or **Reaper**
4. Add **LSP plugins** and **Calf**
5. Use **Helvum** for routing

### For Streaming/Recording
1. Install **OBS Studio**
2. Configure **PipeWire** for screen sharing
3. Install **EasyEffects** for mic processing
4. Add **OBS plugins** (input-overlay, etc.)
5. Test with **SimpleScreenRecorder** first

### For Podcast Production
1. Install **Audacity**
2. Set up **EasyEffects** with noise gate and compression
3. Use **PipeWire** loopback for recording system audio
4. Export with **FFmpeg** for final processing

---

## 🔧 Troubleshooting

### No Sound After Installing PipeWire
```bash
# Restart PipeWire services
systemctl --user restart pipewire pipewire-pulse wireplumber

# Check status
systemctl --user status pipewire
```

### High Latency in DAW
```bash
# Apply low-latency configuration (see PipeWire section)
# Ensure real-time privileges are configured
groups | grep realtime
```

### OBS Won't Capture Screen (Wayland)
```bash
# Ensure portals are installed
sudo pacman -S xdg-desktop-portal-kde  # or -gnome, -wlr

# Restart session or reboot
```

### Bluetooth Audio Quality Poor
```bash
# Check codec in use
pactl list | grep -A2 'Codec'

# Install PipeWire Bluetooth support
sudo pacman -S pipewire-pulse libldac
```

---

## 📚 Additional Resources

- **Arch Wiki - PipeWire:** [wiki.archlinux.org/title/PipeWire](https://wiki.archlinux.org/title/PipeWire)
- **Arch Wiki - Pro Audio:** [wiki.archlinux.org/title/Professional_audio](https://wiki.archlinux.org/title/Professional_audio)
- **OBS Project:** [obsproject.com](https://obsproject.com)
- **LinuxAudio.org:** [linuxaudio.org](https://linuxaudio.org)
- **Linux Musicians Forum:** [linuxmusicians.com](https://linuxmusicians.com)
- **Unfa on YouTube:** Excellent Linux audio production tutorials

---

**Pro Tip:** Most modern distributions ship with PipeWire by default. If you're unsure, stick with PipeWire—it's the future of Linux audio/video handling and provides the best overall experience for both casual users and professionals.
