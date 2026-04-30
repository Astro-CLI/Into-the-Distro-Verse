# Shell Configurations

This directory contains backup configurations for **ZSH**, **Bash**, and **Fish** shells.

## Directory Structure

```
shells/
├── zsh/
│   └── zshrc              # ZSH main config
├── bash/
│   ├── bashrc             # Bash main config
│   └── inputrc            # Readline config (shared with bash, zsh)
├── fish/
│   └── config.fish        # Fish main config
├── starship.toml          # Starship prompt config (all shells)
└── README.md              # This file
```

## Quick Restore

### ZSH
```bash
cp configs/shells/zsh/zshrc ~/.zshrc
exec zsh
```

### Bash
```bash
cp configs/shells/bash/bashrc ~/.bashrc
cp configs/shells/bash/inputrc ~/.inputrc
exec bash
```

### Fish
```bash
mkdir -p ~/.config/fish
cp configs/shells/fish/config.fish ~/.config/fish/config.fish
exec fish
```

### Starship (all shells)
```bash
mkdir -p ~/.config
cp configs/shells/starship.toml ~/.config/starship.toml
```

### Restore All
```bash
# ZSH
cp configs/shells/zsh/zshrc ~/.zshrc

# Bash
cp configs/shells/bash/bashrc ~/.bashrc
cp configs/shells/bash/inputrc ~/.inputrc

# Fish
mkdir -p ~/.config/fish
cp configs/shells/fish/config.fish ~/.config/fish/config.fish

# Starship (all shells)
mkdir -p ~/.config
cp configs/shells/starship.toml ~/.config/starship.toml

# Reload shell
exec $SHELL
```

## Prerequisites

Before restoring, ensure these are installed:

### Core Tools
```bash
paru -S zsh bash fish
```

### Oh My Zsh (for ZSH)
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### CLI Tools
```bash
paru -S zoxide thefuck tealdeer ripgrep fd fzf bat eza
```

### ZSH Plugins
```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# zsh-completions
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

# forgit
git clone https://github.com/wfxr/forgit.git ~/.oh-my-zsh/custom/plugins/forgit
```

### Fish Plugins
```bash
# Fisher (plugin manager)
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.install.fish | source

# Tide prompt
fisher install ilancosman/tide@v6

# FZF integration
fisher install jethrokuan/fzf.fish
```

### Starship Prompt (all shells)
```bash
paru -S starship
```

## Configuration Highlights

### ZSH
- **Framework**: Oh My Zsh
- **Plugins**: git, fzf, zsh-syntax-highlighting, zsh-autosuggestions, zsh-completions, forgit
- **Prompt**: Starship
- **CLI integrations**: zoxide, thefuck, fzf, fd, eza, bat
- **Keybindings**: Emacs mode (Ctrl+A, Ctrl+E, etc.)

### Bash
- **Prompt**: Starship
- **Readline**: Emacs mode with arrow key history search
- **CLI integrations**: zoxide, thefuck, fzf, fd, eza, bat
- **History**: 10000 commands with timestamps

### Fish
- **Prompt**: Starship
- **Built-in features**: Syntax highlighting, auto-suggestions, tab completion
- **Plugins**: Tide, fzf.fish
- **CLI integrations**: zoxide, thefuck, fzf, fd, eza, bat
- **Keybindings**: Emacs mode (default)

## Notes

- All shells use **Emacs keybindings** for consistency
- All shells have **FZF integration** (Ctrl+R, Ctrl+T, Ctrl+Alt+C)
- All shells support **zoxide** for smart cd (`z <dir>`)
- **Fish is NOT POSIX-compliant** - use `#!/bin/sh` for portable scripts
- **ZSH and Bash** are POSIX-safe for scripts (when configured correctly)

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Plugin not found after restore | Ensure Oh My Zsh plugins are cloned (see Prerequisites) |
| Prompt not showing | Ensure starship is installed: `which starship` |
| FZF not working | Check fzf is installed and in PATH |
| Slow shell startup | Profile with: `time bash -i -c ''` or `time zsh -i -c ''` |

## Updates

When you modify your shell configuration, update the backups:

```bash
# After modifying ~/.zshrc
cp ~/.zshrc configs/shells/zsh/zshrc

# After modifying ~/.bashrc
cp ~/.bashrc configs/shells/bash/bashrc
cp ~/.inputrc configs/shells/bash/inputrc

# After modifying ~/.config/fish/config.fish
cp ~/.config/fish/config.fish configs/shells/fish/config.fish

# After modifying ~/.config/starship.toml
cp ~/.config/starship.toml configs/shells/starship.toml

# Commit to git
git add configs/shells/
git commit -m "Update shell configs"
```

## References

See the parent directory for detailed documentation:
- `zsh.md` - Complete ZSH setup guide
- `bash.md` - Complete Bash setup guide
- `fish.md` - Complete Fish setup guide
