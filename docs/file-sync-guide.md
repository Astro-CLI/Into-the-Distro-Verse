<!-- 
    WIKI GUIDE: file-sync-guide.md
    Comprehensive guide to syncing files, projects, and code across multiple machines.
    Covers Git, Syncthing, rsync, rclone, and other synchronization strategies.
-->

### Syncing Files & Projects Across Your Machines

Need your files on multiple computers? Whether it's code, documents, or media, this guide covers the right tool for every situation. We'll start with simple approaches and work up to complex multi-machine workflows.

---

## 🤔 Why Would I Need This?

- **Work on multiple devices** - Code on laptop, test on desktop
- **Backup automatically** - Never lose important files again
- **Keep teams in sync** - Collaborate with others seamlessly
- **Access from anywhere** - Your files follow you
- **Version control** - Track changes and revert if needed

---

## 📊 1. Tool Comparison: Picking the Right One

| Tool | Purpose | Best For | Real-time | Versioning | Setup |
|------|---------|----------|-----------|------------|-------|
| **Git** | Version control | Code, docs | No | Full history | Medium |
| **Syncthing** | P2P sync | Any files | Yes | Limited | Easy |
| **rsync** | File sync | Backups | No | No | Simple |
| **rclone** | Cloud sync | Cloud storage | No | No | Medium |
| **Restic** | Encrypted backup | Archival | No | Yes | Medium |
| **Nextcloud** | Team collaboration | Shared files | Yes | Yes | Complex |

---

## 💻 2. Git: For Code & Documents

Use Git when you need version control—tracking every change and who made it.

### When to Use Git

- Source code (primary use case)
- Documentation and markdown files
- Configuration files
- Any text project with history
- Team collaboration with branching

### Quick Setup

```bash
### Initialize a repository
git init my-project
cd my-project

### Configure your identity
git config user.name "Your Name"
git config user.email "you@example.com"

### Or globally (all projects)
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

### Basic Workflow

```bash
### Make changes
echo "content" > file.txt

### Stage changes
git add file.txt

### Commit with message
git commit -m "Add file"

### View history
git log --oneline

### Create a branch
git branch feature-x
git switch feature-x

### Merge back to main
git switch main
git merge feature-x
```

### Sync Across Machines

```bash
### Add remote (GitHub, GitLab, etc.)
git remote add origin https://github.com/user/repo.git

### Push to remote
git push -u origin main

### Pull latest changes
git pull origin main

### On another machine - clone it
git clone https://github.com/user/repo.git
```

### SSH Keys (Passwordless Access)

```bash
### Generate key (one time)
ssh-keygen -t ed25519 -C "your@email.com"

### Add to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

### Copy public key to GitHub/GitLab
cat ~/.ssh/id_ed25519.pub

### Test it works
ssh -T git@github.com
```

---

## 📁 3. Syncthing: Real-Time File Sync

Use Syncthing when you want files to stay in sync automatically across your devices, without a central server.

### When to Use Syncthing

- Bidirectional sync across personal machines
- Real-time updates (watch for changes)
- Decentralized (no cloud server needed)
- Large binary files (media, databases)
- Privacy-focused peer-to-peer

### Installation

```bash
### Arch Linux
sudo pacman -S syncthing

### Ubuntu/Debian
sudo apt install syncthing

### Fedora
sudo dnf install syncthing
```

### Start & Enable

```bash
### As a user service
systemctl --user enable --now syncthing.service

### Check status
systemctl --user status syncthing.service

### View logs
journalctl --user -u syncthing.service -f
```

### Setup

1. Open browser → `http://localhost:8384`
2. Add a folder to sync (choose a local path)
3. Go to Settings > Show ID to get your Device ID
4. Share the folder with other devices using their Device IDs
5. On other device: Accept the share

### What Folders to Sync

```bash
~/Documents          # Personal documents
~/.config            # Configuration backups
~/Projects           # Large project files
~/Media              # Photos and videos
```

---

## 🔄 4. rsync: One-Way Backups

Use rsync for scheduled backups to external drives or servers.

### When to Use rsync

- Backup to external drive
- One-way sync (source → destination)
- Incremental updates only
- Scheduled backups via cron
- Efficient (only changed files)

### Basic Usage

```bash
### Backup local folder to external drive
rsync -av ~/Documents /media/backup/

### To remote server
rsync -av ~/Documents user@remote.host:/backups/

### With compression (slow networks)
rsync -avz ~/Documents user@remote.host:/backups/

### Dry-run (see what would sync)
rsync -av --dry-run ~/Documents /media/backup/
```

### Useful Flags

```bash
-a      # Archive mode (preserves permissions)
-v      # Verbose
-z      # Compress during transfer
--delete # Remove from dest if deleted in source
--exclude '*.log' # Skip matching files
--progress # Show progress
```

### Automated Backup with Cron

```bash
### Edit your crontab
crontab -e

### Daily backup at 2 AM
0 2 * * * rsync -av ~/Documents /media/backup/ >> ~/backup.log 2>&1

### Weekly backup
0 3 * * 0 rsync -av ~/Documents user@remote.host:/backups/
```

---

## ☁️ 5. rclone: Cloud Storage Sync

Use rclone to sync with cloud providers like Google Drive, Dropbox, or AWS S3.

### When to Use rclone

- Sync with cloud providers
- Backup to cloud with encryption
- Move files between clouds
- Bandwidth control for slow connections

### Installation

```bash
### Arch Linux
sudo pacman -S rclone

### Ubuntu/Debian
sudo apt install rclone

### Or universal installer
curl https://rclone.org/install.sh | sudo bash
```

### Setup

```bash
### Interactive configuration
rclone config

### Follow prompts to authenticate with Google Drive, Dropbox, etc.
### List configured remotes
rclone listremotes
```

### Common Commands

```bash
### List files on cloud
rclone ls mycloud:

### Upload to cloud
rclone copy ~/Documents mycloud:/backups/

### Download from cloud
rclone copy mycloud:/backups/ ~/Documents/

### Sync both ways (be careful!)
rclone bisync ~/Documents mycloud:/backups/

### With bandwidth limit (e.g., 1MB/s)
rclone copy --bwlimit 1M ~/Documents mycloud:/backups/
```

---

## 🔐 6. Restic: Encrypted Backups

Use Restic for encrypted, versioned backups with deduplication.

### When to Use Restic

- Encrypted backups (local or cloud)
- Deduplication (efficient storage)
- Point-in-time recovery
- Automatic pruning

### Installation

```bash
### Arch Linux
sudo pacman -S restic

### Ubuntu/Debian
sudo apt install restic

### Homebrew
brew install restic
```

### Local Backup

```bash
### Initialize repository
restic init -r /mnt/backup

### First backup
restic -r /mnt/backup backup ~/Documents

### Restore files
restic -r /mnt/backup restore latest --target ~/restore/

### View backup history
restic -r /mnt/backup snapshots
```

### Cloud Backup (S3)

```bash
### Set credentials
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"

### Initialize on S3
restic init -r s3:s3.amazonaws.com/bucket-name

### Backup to S3
restic -r s3:s3.amazonaws.com/bucket-name backup ~/Documents
```

---

## 📋 7. Choosing the Right Setup

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

### 3-2-1 Backup Rule

```
3 copies of important data
2 different media types (SSD + HDD)
1 offsite (cloud)
```

---

## 🔒 Security Best Practices

1. **Use SSH keys** for Git and rsync
2. **Enable 2FA** on GitHub/GitLab
3. **Encrypt cloud backups** with Restic
4. **Syncthing:** Verify Device IDs before connecting
5. **rclone:** Use `--crypt` for sensitive data
6. **.gitignore:** Never commit secrets, passwords, API keys
7. **Permissions:** Restrict backup folders (`chmod 700`)

---

## 🆘 Troubleshooting

### Git: "Permission denied" on push

```bash
### Test SSH key
ssh -T git@github.com

### Or use HTTPS with personal token
git remote set-url origin https://github.com/user/repo.git
```

### Syncthing: Folder not syncing

```bash
### Check logs
journalctl --user -u syncthing.service -n 50

### Verify firewall allows connections
sudo ufw allow syncthing
```

### rsync: Files not updating

```bash
### Dry-run to debug
rsync -av --dry-run ~/source /dest

### Check destination permissions
ls -la /dest
```

---

## 🎯 Why Would I Use This?

- **Never lose work again** - Automatic backups across devices
- **Collaborate smoothly** - Version control with your team
- **Work from anywhere** - Files follow you everywhere
- **Disaster recovery** - 3-2-1 backup keeps you safe
- **Peace of mind** - Know your files are secure and synced

---

## 🔗 Related Guides

- 📖 **[Security Hardening](security.md)** - Secure your backups
- 📖 **[System Maintenance](system_maintenance.md)** - Backup strategies
- 📖 **[Arch Linux Guide](arch.md)** - Package management
