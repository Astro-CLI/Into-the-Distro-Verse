# File & Project Synchronization Guide

A comprehensive guide to syncing files, projects, and repositories across multiple machines using Git, Syncthing, rsync, rclone, and other tools. Includes best practices and tool comparisons.

---

## 📊 Tool Comparison

| Tool | Purpose | Best For | Real-time | Versioning | Setup |
|------|---------|----------|-----------|------------|-------|
| **Git** | Version control | Code, docs, text | ❌ No | ✅ Full history | Medium |
| **Syncthing** | P2P sync | Any files | ✅ Yes | ⚠️ Limited | Easy |
| **rsync** | File sync | Backups, one-way | ❌ No | ❌ No | Simple |
| **rclone** | Cloud sync | Cloud storage | ❌ No | ❌ No | Medium |
| **Restic** | Backup | Archival | ❌ No | ✅ Dedup | Medium |
| **Nextcloud** | Cloud + sync | Team files | ✅ Yes | ✅ Versioning | Complex |

---

## 🌐 Git: Version Control & Collaboration

### When to Use Git
- **Source code** (primary use case)
- **Documentation** and markdown files
- **Configuration files**
- **Any text-based project** that benefits from history
- **Team collaboration** with branching workflows
- **Distributed backup** (every clone is a backup)

### Local Setup

```bash
# Initialize a repository
git init my-project
cd my-project

# Configure user
git config user.name "Your Name"
git config user.email "you@example.com"

# Or globally
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

### Basic Workflow

```bash
# Make changes
echo "content" > file.txt

# Stage changes
git add file.txt

# Commit with message
git commit -m "Add file"

# View history
git log --oneline

# Create a branch
git branch feature-x
git checkout feature-x
# or: git switch feature-x

# Merge back to main
git checkout main
git merge feature-x
```

### Remote Repositories

```bash
# Add remote (GitHub, GitLab, Gitea, etc.)
git remote add origin https://github.com/user/repo.git

# Push to remote
git push -u origin main

# Pull latest changes
git pull origin main

# Fetch without merging
git fetch origin
```

### Multi-Machine Setup

**Clone on other machines:**
```bash
git clone https://github.com/user/repo.git
cd repo
```

**Keep in sync:**
```bash
# Before work: pull latest
git pull origin main

# After work: push changes
git push origin main
```

### SSH Keys (Passwordless Access)

```bash
# Generate key
ssh-keygen -t ed25519 -C "your@email.com"

# Add to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Add public key to GitHub/GitLab
cat ~/.ssh/id_ed25519.pub
# Paste in Settings > SSH Keys

# Test connection
ssh -T git@github.com
```

### .gitignore Best Practices

```bash
# Common patterns to ignore
echo "
.DS_Store
*.log
*.tmp
node_modules/
dist/
build/
*.swp
.vscode/
.env
secrets/
" > .gitignore

git add .gitignore
git commit -m "Add gitignore"
```

---

## 🔄 Syncthing: Real-Time File Sync

### When to Use Syncthing
- **Bidirectional sync** across personal machines
- **Real-time updates** (watch for file changes)
- **Decentralized** (no cloud server needed)
- **Large binary files** (media, backups)
- **Privacy-focused** (peer-to-peer, encrypted)
- **Not suitable** for collaboration (no conflict resolution)

### Installation

```bash
# Arch Linux
sudo pacman -S syncthing

# Ubuntu/Debian
sudo apt install syncthing

# Fedora
sudo dnf install syncthing
```

### Start & Enable

```bash
# Start manually
syncthing

# Or as systemd service (user)
systemctl --user enable --now syncthing.service

# Check status
systemctl --user status syncthing.service

# View logs
journalctl --user -u syncthing.service -f
```

### Web UI Configuration

1. Open browser → `http://localhost:8384`
2. Add folder to sync (local path)
3. Get Device ID from Settings > Show ID
4. Share folder with other devices by their Device ID
5. On other device: Accept the share

### Common Folders to Sync

```bash
# Personal documents
~/Documents

# Configuration backups
~/.config

# Projects (faster than Git for huge files)
~/Projects

# Shared media
~/Media
```

### Conflict Resolution

When both machines edit the same file:
```bash
# Syncthing keeps both versions
file.txt
file.txt.sync-conflict-20240423-123456

# Manually choose which one to keep
# Or merge them, then delete the conflict file
```

### Advanced: Sync Filters

Exclude large/temporary files in folder settings:
```
(?d)\.git
(?d)node_modules
(?d)\.venv
*.tmp
*.log
*.swp
```

### Performance: Ignore Patterns

For large projects, tell Syncthing to skip:
```
# In folder Advanced settings > Ignore Patterns
(?d).git
(?d).__pycache__
(?d)node_modules
(?d)venv
*.o
*.pyc
.DS_Store
```

---

## 📦 rsync: One-Way File Sync

### When to Use rsync
- **Backup to external drive** or remote server
- **One-way sync** (source → destination)
- **Incremental updates** (only changed files)
- **Scheduled backups** (cron jobs)
- **Bandwidth-efficient** (delta sync)
- **Not suitable** for real-time or bidirectional

### Basic Usage

```bash
# Backup local folder to external drive
rsync -av ~/Documents /media/backup/

# Backup to remote server
rsync -av ~/Documents user@remote.host:/backups/

# With compression (over slow networks)
rsync -avz ~/Documents user@remote.host:/backups/

# Dry-run (see what would be synced)
rsync -av --dry-run ~/Documents /media/backup/
```

### Useful Flags

```bash
-a      # Archive mode (preserves permissions, timestamps)
-v      # Verbose
-z      # Compress during transfer
--delete # Remove files from dest if deleted in source
--exclude '*.log' # Skip matching files
--progress # Show transfer progress
```

### Automated Backup with Cron

```bash
# Edit crontab
crontab -e

# Daily backup at 2 AM
0 2 * * * rsync -av ~/Documents /media/backup/ >> ~/backup.log 2>&1

# Weekly backup
0 3 * * 0 rsync -av ~/Documents user@remote.host:/backups/
```

### Remote Backup Over SSH

```bash
# Ensure SSH key auth is set up first
ssh-copy-id user@remote.host

# Then use rsync over SSH
rsync -avz -e ssh ~/Documents user@remote.host:/backups/
```

---

## ☁️ rclone: Cloud Storage Sync

### When to Use rclone
- **Sync with cloud providers** (Google Drive, AWS S3, Dropbox, etc.)
- **Backup to cloud** with encryption
- **Move files between clouds**
- **Bandwidth control** (useful for slow connections)
- **Not suitable** for real-time sync

### Installation

```bash
# Arch Linux
sudo pacman -S rclone

# Ubuntu/Debian
sudo apt install rclone

# Or universal installer
curl https://rclone.org/install.sh | sudo bash
```

### Configure Cloud Storage

```bash
# Interactive setup
rclone config

# Follow prompts to authenticate with cloud provider
# (Google Drive, Dropbox, AWS S3, etc.)

# List configured remotes
rclone listremotes
```

### Common Operations

```bash
# List files on cloud
rclone ls mycloud:

# Upload local folder to cloud
rclone copy ~/Documents mycloud:/backups/

# Download from cloud
rclone copy mycloud:/backups/ ~/Documents/

# Bidirectional sync (careful!)
rclone bisync ~/Documents mycloud:/backups/

# With encryption (crypt)
rclone copy ~/Documents myencrypted:/ --crypt-key mysecretkey

# Bandwidth limit (e.g., 1MB/s)
rclone copy --bwlimit 1M ~/Documents mycloud:/backups/
```

---

## 🔐 Restic: Encrypted Backup

### When to Use Restic
- **Encrypted backups** (local or cloud)
- **Deduplication** (efficient storage)
- **Point-in-time recovery** (restore any previous state)
- **Versioning** with automatic pruning
- **Cross-platform** (Linux, macOS, Windows)

### Installation

```bash
# Arch Linux
sudo pacman -S restic

# Ubuntu/Debian
sudo apt install restic

# Homebrew
brew install restic
```

### Local Backup

```bash
# Initialize repository
restic init -r /mnt/backup

# First backup
restic -r /mnt/backup backup ~/Documents

# Restore files
restic -r /mnt/backup restore latest --target ~/restore-location

# View backup history
restic -r /mnt/backup snapshots
```

### Cloud Backup (S3 example)

```bash
# Set environment variables
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"

# Initialize on S3
restic init -r s3:s3.amazonaws.com/bucket-name

# Backup to S3
restic -r s3:s3.amazonaws.com/bucket-name backup ~/Documents
```

### Scheduled Backups

```bash
# Create backup script
cat > ~/backup.sh << 'EOF'
#!/bin/bash
export RESTIC_REPOSITORY=/mnt/backup
export RESTIC_PASSWORD="your-secure-password"
restic backup ~/Documents ~/Projects
restic forget --keep-daily 7 --keep-monthly 12
EOF

chmod +x ~/backup.sh

# Add to crontab
crontab -e
# 0 3 * * * ~/backup.sh >> ~/backup.log 2>&1
```

---

## 🌐 Nextcloud: Team Collaboration + Sync

### When to Use Nextcloud
- **Team file sharing** with permissions
- **Real-time collaboration** (files + calendar + contacts)
- **Self-hosted control** (optional)
- **Desktop + mobile sync**
- **Versioning and sharing**
- **Complex setup** but powerful

### Installation (Self-Hosted)

```bash
# Docker (easiest)
docker run -d \
  -p 8080:80 \
  -v nextcloud-data:/var/www/html \
  --name nextcloud \
  nextcloud

# Then access http://localhost:8080
```

### Desktop Sync

```bash
# Install Nextcloud Desktop Client
sudo pacman -S nextcloud-client

# Open app and configure server
# Choose local folder to sync
```

---

## 🎯 Recommended Setups by Use Case

### Single Machine: Local Backups
```
rsync (daily) → External SSD
+ Restic (weekly) → Cloud
```

### Personal Multi-Machine
```
Git (code/docs) → GitHub
+ Syncthing (large files) → P2P between machines
```

### Team Collaboration
```
Git (code) → GitHub/GitLab
+ Nextcloud (shared files) → Server
+ rclone (archives) → Cloud backup
```

### Backup Strategy (3-2-1 Rule)
```
3 copies:
  - Original (local SSD)
  - Backup 1 (rsync → external drive)
  - Backup 2 (Restic → cloud)

2 different media types:
  - SSD (fast access)
  - HDD or cloud (archival)

1 offsite:
  - Cloud backup (disaster recovery)
```

---

## ⚡ Quick Start: Popular Combinations

### Git + Syncthing (Developers)
```bash
# Code in Git
git clone https://github.com/user/project.git

# Large files / media in Syncthing
# Configure Syncthing to sync ~/Projects
# Add folder on secondary machine
```

### rsync + Cron (System Admins)
```bash
# Daily incremental backup
0 2 * * * rsync -av ~/important /backup/

# Monthly cloud backup
0 3 1 * * rsync -av /backup user@cloud:/archives/
```

### Restic + S3 (Security-Conscious)
```bash
# Encrypted cloud backups
restic init -r s3:bucket
restic backup ~/sensitive-data
# Automatic pruning keeps space efficient
```

---

## 🛡️ Security Best Practices

1. **Use SSH keys** for Git and remote rsync
2. **Enable 2FA** on GitHub/GitLab
3. **Encrypt sensitive backups** with Restic
4. **Syncthing:** Verify Device IDs before connecting
5. **rclone:** Use `--crypt` for sensitive cloud data
6. **.gitignore:** Never commit secrets, passwords, API keys
7. **Permissions:** Restrict backup folders (`chmod 700`)

---

## 📋 Troubleshooting

### Git: "Permission denied" on push
```bash
# Verify SSH key is set up
ssh -T git@github.com

# Or use HTTPS with personal access token
git remote set-url origin https://github.com/user/repo.git
```

### Syncthing: Folder not syncing
```bash
# Check logs
journalctl --user -u syncthing.service -n 50

# Verify firewall allows connections
sudo ufw allow syncthing
```

### rsync: Files not updating
```bash
# Use dry-run to debug
rsync -av --dry-run ~/source /dest

# Check destination permissions
ls -la /dest
```

### rclone: Connection timeout
```bash
# Increase timeout
rclone --timeout 30s copy ~/Documents mycloud:/

# Check authentication
rclone config
```

---

## 📚 References

- [Git Documentation](https://git-scm.com/doc)
- [Syncthing Docs](https://docs.syncthing.net/)
- [rsync Man Page](https://linux.die.net/man/1/rsync)
- [rclone Documentation](https://rclone.org/docs/)
- [Restic Backup](https://restic.readthedocs.io/)
- [3-2-1 Backup Strategy](https://www.backblaze.com/blog/the-3-2-1-backup-strategy/)
