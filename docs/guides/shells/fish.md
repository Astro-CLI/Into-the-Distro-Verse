# FISH Configuration Guide

## Overview
Fish (Friendly Interactive Shell) is configured as an alternative interactive shell with user-friendly defaults. It provides syntax highlighting, auto-suggestions, and tab completion out of the box, now enhanced with modern CLI tool integrations.

## Installation

```bash
# Install fish
sudo pacman -S fish

# Set as default shell (optional)
chsh -s /usr/bin/fish
```

## Framework & Plugins

### Plugin Manager
**Fisher** - Minimal plugin manager
```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.install.fish | source
```

### Installed Plugins

| Plugin | Purpose |
|--------|---------|
| **ilancosman/tide** | Modern prompt theme |
| **jethrokuan/fzf.fish** | Fuzzy finder integration |

### Plugin Installation
```bash
# Install new plugins
fisher install ilancosman/tide@v6
fisher install jethrokuan/fzf.fish
```

## Core Configuration

### ~/.config/fish/config.fish
Main configuration file for fish shell.

### Key Defaults (Out of Box)
- **Syntax highlighting** - Colors commands as you type
- **Tab completion** - Intelligent context-aware completions
- **History search** - `Up/Down arrows` navigate history
- **Abbreviations** - Expand typed abbreviations
- **Command suggestions** - Similar to zsh-autosuggestions

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
# ~/.config/fish/config.fish additions:

# ZOXIDE (smart cd)
zoxide init fish | source

# THEFUCK (fix typos)
thefuck --alias | source

# FZF + FD INTEGRATION
set -gx FZF_DEFAULT_COMMAND 'fd --type f --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND 'fd --type f --follow --exclude .git'
set -gx FZF_ALT_C_COMMAND 'fd --type d --follow --exclude .git'
```

## Keybindings

### Default (Emacs Mode)
Explicitly enabled via:
```fish
fish_default_key_bindings
```

| Key Binding | Action |
|-------------|--------|
| `Ctrl+A` | Start of line |
| `Ctrl+E` | End of line |
| `Ctrl+K` | Delete to end of line |
| `Ctrl+U` | Delete to start of line |
| `Ctrl+W` | Delete word backward |
| `Alt+D` | Delete word forward |
| `Up/Down` | Navigate history (with prefix search) |
| `Ctrl+R` | Fuzzy history search (fzf) |
| `Ctrl+T` | Fuzzy file finder |
| `Ctrl+Alt+C` | Fuzzy directory finder |

### Vi Mode (Optional)
To enable vi keybindings:
```fish
# In config.fish:
fish_vi_key_bindings
```

## Auto-Suggestions

Fish's **built-in auto-suggestions** show previous commands matching your prefix:

Example:
```
> paru
paru -Syu;flatpak upgrade    # Grayed suggestion from history
```

- **Accept suggestion**: Press `→` (right arrow) or `End` key
- **Dismiss**: Press `Escape` or `Ctrl+C`
- **Continue typing**: Filters the suggestion

This is **automatic** - no plugin needed.

## Aliases

Modern tool replacements (automatic if installed):
```fish
alias ls='eza --icons --git'
alias la='eza -a --icons --git'
alias ll='eza -al --icons --git'
alias lt='eza --tree --icons'
alias cat='bat --paging=never'
```

Standard navigation:
```fish
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
```

Git shortcuts:
```fish
alias gst='git status'
alias ga='git add'
alias gc='git commit -v'
alias gcb='git checkout -b'
alias gp='git push'
alias gl='git pull'
```

## Colorful Man Pages

Configured in config.fish:
```fish
if type -q bat
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx MANROFFOPT "-c"
end
```

## Usage Examples

### Navigation
```fish
z /tmp          # Jump to /tmp (remembers visited directories)
z proj          # Fuzzy jump to any dir containing "proj"
cd ..           # Traditional cd
```

### Command Fixing
```fish
paru -Syy       # Typo
fuck            # Fixes to: pacman -Syu or your common pattern
```

### Fuzzy Finding
```fish
Ctrl+R          # Search command history with preview
Ctrl+T          # Find and insert files
Ctrl+Alt+C      # Navigate to directories
```

### Documentation
```fish
tldr ls         # Quick manual page for ls
rg "pattern"    # Search files with ripgrep
fd "filename"   # Find files with fd
```

## Custom Functions

Define custom functions in config.fish:

```fish
# Create directory and enter it
function mkcd
    if test -n "$argv[1]"
        mkdir -p $argv[1]; and cd $argv[1]
    end
end

# Quick edit config
function fishconfig
    $EDITOR ~/.config/fish/config.fish
end
```

## Prompt

**Starship** is used for the prompt:
```fish
starship init fish | source
```

Configure via `~/.config/starship.toml`

## Sourcing Order (in ~/.config/fish/config.fish)

1. Interactive session check (`if status is-interactive`)
2. Aliases
3. Custom functions
4. zoxide initialization
5. thefuck initialization
6. FZF configuration
7. Starship prompt initialization
8. Colorful man pages setup

## Variables in Fish

Fish uses `set` instead of `export`:

```fish
# Local variable (function-scoped)
set myvar "value"

# Global variable (session-wide)
set -g myvar "value"

# Universal variable (persistent across sessions)
set -U myvar "value"

# Export to child processes (environment)
set -gx PATH $PATH /new/path
```

## Abbreviations vs Aliases

Fish supports both - abbreviations are better for frequently used commands:

```fish
# Abbreviation (expands when you press space)
abbr -a gc git commit

# Alias (always expands)
alias gc 'git commit -v'
```

## Tab Completion

Fish's tab completion is **context-aware**:
- Press `Tab` to see all options
- Tab completion suggests subcommands, file paths, git branches
- Customize completions via `~/.config/fish/completions/`

Example:
```fish
# Suggest git branches for git checkout
git checkout [Tab]
```

## Comparison with ZSH/BASH

| Feature | Fish | ZSH | Bash |
|---------|------|-----|------|
| Out-of-box UX | Excellent | Good | Basic |
| Auto-suggestions | Built-in | Plugin | Custom |
| Syntax highlighting | Built-in | Plugin | None |
| Tab completion | Excellent | Plugin | Basic |
| POSIX compliance | Poor | Good | Excellent |
| Learning curve | Easy | Medium | Easy |
| Script compatibility | Low | Medium | High |

**Note**: Fish is best for interactive use. For scripts, use POSIX shell.

## POSIX Compliance

Fish is **not POSIX-compliant** by design. For portable scripts:

```bash
#!/bin/sh          # POSIX shell (portable)
#!/bin/bash        # Bash (if bash-specific features needed)
```

Fish syntax (e.g., `if`, `and`, `or`, string handling) is **incompatible** with POSIX shells.

**Best practice**: Use fish as your interactive shell, but write scripts in POSIX shell.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Auto-suggestions not showing | Check config.fish is sourced properly |
| Colors look wrong | Try `set -U fish_color_normal normal` to reset colors |
| Slow startup | Remove unused plugins: `fisher list`, `fisher rm <plugin>` |
| Tide prompt issues | Run `tide configure` to reconfigure |
| FZF not working | Verify fzf is installed: `which fzf` |

## Performance Notes

- Startup time: ~150-200ms (acceptable for interactive shell)
- Tab completion is instant (pre-computed)
- Syntax highlighting is real-time
- FZF queries use fd (fast, respects .gitignore)

## Configuration Persistence

Fish saves configuration in multiple places:
- `~/.config/fish/config.fish` - Manual config
- `~/.config/fish/conf.d/` - Auto-sourced configs
- `~/.config/fish/functions/` - Function definitions
- `~/.local/share/fish/` - Universal variables and history

## References

- [Fish Documentation](https://fishshell.com/docs/current/)
- [Fisher Plugin Manager](https://github.com/jorgebucaran/fisher)
- [Tide Prompt Theme](https://github.com/IlanCosman/tide)
- [fzf.fish Plugin](https://github.com/PatrickF1/fzf.fish)
- [Starship Prompt](https://starship.rs/)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
