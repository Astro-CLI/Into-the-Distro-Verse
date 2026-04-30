# ZSH Configuration Guide

## Overview
ZSH is configured with **Oh My Zsh** framework, providing a feature-rich interactive shell experience with POSIX compliance for scripts.

## Installation & Framework

### Oh My Zsh
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Core Plugins Enabled

| Plugin | Purpose |
|--------|---------|
| **git** | Git shortcuts and helpers |
| **fzf** | Fuzzy finder integration (Ctrl+R, Ctrl+T, Ctrl+Alt+C) |
| **zsh-syntax-highlighting** | Colors commands as you type |
| **zsh-autosuggestions** | Shows history suggestions (fish-like) |
| **zsh-completions** | Enhanced completion system |
| **forgit** | Interactive git with fzf (gi, glo, gd aliases) |

## CLI Tools Integration

### Installed Tools
- **zoxide** - Smart cd replacement (`z <dir>`)
- **thefuck** - Command typo fixer (`fuck`)
- **tealdeer** - Fast manual pages (`tldr <cmd>`)
- **ripgrep (rg)** - Fast grep replacement
- **fd** - Fast find replacement
- **fzf** - Fuzzy finder
- **bat** - Colored cat replacement
- **eza** - Modern ls replacement (with icons/git)

### Integration Configuration

```bash
# ~/.zshrc additions:

# ZOXIDE (smart cd)
eval "$(zoxide init zsh)"

# THEFUCK (fix typos)
eval "$(thefuck --alias)"

# FZF + FD integration
export FZF_DEFAULT_COMMAND='fd --type f --follow --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type f --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --follow --exclude .git'
```

## Keybindings

### Default (Emacs Mode)
Explicitly enabled via `bindkey -e`

| Key Binding | Action |
|-------------|--------|
| `Ctrl+A` | Start of line |
| `Ctrl+E` | End of line |
| `Ctrl+K` | Delete to end of line |
| `Ctrl+U` | Delete to start of line |
| `Ctrl+W` | Delete word backward |
| `Alt+D` | Delete word forward |
| `Ctrl+R` | Fuzzy history search (fzf) |
| `Ctrl+T` | Fuzzy file finder |
| `Ctrl+Alt+C` | Fuzzy directory finder |

### History Suggestions
- Type command prefix (e.g., `paru`)
- Gray suggestion appears (from history)
- Press `→` (right arrow) or `End` to accept
- Press `Escape` to dismiss

### Git Aliases (via forgit)
- `gi` - Interactive gitignore
- `glo` - Interactive git log
- `gd` - Interactive git diff

## Usage Examples

### Navigation
```bash
z /tmp          # Jump to /tmp (remembers visited directories)
z proj          # Fuzzy jump to any dir containing "proj"
..              # cd ..
...             # cd ../..
```

### Command Fixing
```bash
paru -Syy       # Typo
fuck            # Fixes to: pacman -Syu or your common pattern
```

### Fuzzy Finding
```bash
Ctrl+R          # Search command history with preview
Ctrl+T          # Find and insert files
Ctrl+Alt+C      # Navigate to directories
```

### Documentation
```bash
tldr ls         # Quick manual page for ls
rg "pattern"    # Search files with ripgrep
fd "filename"   # Find files with fd
```

## Aliases

Modern tool replacements (automatic if installed):
```bash
ls              # → eza --icons --git
la              # → eza -a --icons --git
ll              # → eza -al --icons --git
cat             # → bat --paging=never
```

Standard navigation:
```bash
..              # cd ..
...             # cd ../..
....            # cd ../../..
.....           # cd ../../../..
```

## Prompt

**Starship** is used for the prompt. Configure via:
```bash
starship init zsh
```

## Sourcing Order (in ~/.zshrc)

1. Oh My Zsh initialization
2. Starship prompt
3. zoxide init
4. thefuck init
5. FZF configuration

## POSIX Compliance

ZSH config is **shell-specific only**. For portable scripts:

```bash
#!/bin/sh          # POSIX shell (portable)
#!/bin/bash        # Bash (if bash-specific features needed)
```

Use `.sh` extension for POSIX scripts to indicate portability.

## Performance Notes

- All plugins are lazy-loaded by Oh My Zsh
- History suggestions (zsh-autosuggestions) are instant
- FZF queries use fd (fast, respects .gitignore)
- Total startup time: ~200-300ms (acceptable for interactive shell)

## Customization Points

- **Theme**: Change via `starship` configuration (~/.config/starship.toml)
- **History**: Modify `HISTSIZE`, `HISTFILESIZE` in .zshrc
- **Aliases**: Add to ~/.zshrc or Oh My Zsh custom folder

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Suggestions not showing | Check zsh-autosuggestions plugin is in plugins list |
| FZF not working | Verify fzf is installed: `which fzf` |
| Slow startup | Run `zsh -x ~/.zshrc` to debug |
| History search broken | Check .inputrc doesn't conflict (it shouldn't for zsh) |

## References

- [Oh My Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [Starship Prompt](https://starship.rs/)
- [fzf](https://github.com/junegunn/fzf)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
