### BASH Configuration Guide

## Overview
Bash is configured as a fallback shell with zsh/fish-like features. While not as elegant as zsh/fish, it provides a comfortable Emacs-based interactive experience with modern CLI tool integrations.

## Framework

**Oh My Bash** (optional, not heavily used in this setup)
- Path: `~/.oh-my-bash`
- Provides theming and plugin system similar to Oh My Zsh

## Core Configuration Files

### ~/.bashrc
Primary configuration file for interactive bash sessions.

### ~/.inputrc
Readline configuration file (shared with other shells using readline).

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
### ~/.bashrc additions:

### HISTORY IMPROVEMENTS
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

### STARSHIP PROMPT
eval "$(starship init bash)"

### ZOXIDE (smart cd)
eval "$(zoxide init bash)"

### THEFUCK (fix typos)
eval "$(thefuck --alias)"

### FZF INTEGRATION
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='fd --type f --follow --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type f --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --follow --exclude .git'
```

## Keybindings

### Emacs Mode (Default)
Explicitly set in ~/.inputrc:
```
set editing-mode emacs
```

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

### Arrow Key History Search
Configured in ~/.inputrc:
```
"\e[A": history-search-backward
"\e[B": history-search-forward
```
- Press `Up arrow` to search backward through history
- Press `Down arrow` to search forward through history

### Vi Mode (Optional)
To enable vi keybindings instead:
```bash
### Uncomment in ~/.inputrc:
### set editing-mode vi

### Or in ~/.bashrc:
set -o vi
```

## Readline Configuration (~/.inputrc)

```bash
### Emacs keybindings (explicit)
set editing-mode emacs

### History search with arrow keys
"\e[A": history-search-backward
"\e[B": history-search-forward

### Better completion
set completion-ignore-case on
set bell-style none
set show-all-if-ambiguous on
set show-all-if-unmodified on
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
```

## Usage Examples

### Navigation
```bash
z /tmp          # Jump to /tmp (remembers visited directories)
z proj          # Fuzzy jump to any dir containing "proj"
cd ..           # Traditional cd (works normally)
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

## History Management

History settings in ~/.bashrc:
- **HISTSIZE**: 10000 (commands in memory)
- **HISTFILESIZE**: 20000 (commands saved to disk)
- **HISTCONTROL**: ignoredups:erasedups (no duplicates)
- **HISTTIMEFORMAT**: Records timestamp for each command

View full history with timestamps:
```bash
history | tail -20
```

## Prompt

**Starship** is used for the prompt:
```bash
eval "$(starship init bash)"
```

Configure via `~/.config/starship.toml`

## Sourcing Order (in ~/.bashrc)

1. Oh My Bash initialization (if used)
2. History configuration
3. Starship prompt initialization
4. zoxide initialization
5. thefuck initialization
6. FZF initialization and configuration
7. Aliases and custom functions

## POSIX Compliance

Bash config is **shell-specific only**. For portable scripts:

```bash
#!/bin/sh          # POSIX shell (portable, most compatible)
#!/bin/bash        # Bash (if bash-specific features needed)
```

Note: Many bash features (.sh scripts) are not POSIX-compliant. Use `#!/bin/sh` for maximum portability.

## Comparison with ZSH

| Feature | Bash | ZSH |
|---------|------|-----|
| Interactive features | Simpler | More advanced |
| Startup time | Faster | Slightly slower |
| Plugin ecosystem | Limited | Extensive (Oh My Zsh) |
| Syntax highlighting | None (native) | Built-in |
| Auto-suggestions | Via custom setup | Built-in |
| Scriptability | Industry standard | More powerful |
| POSIX compatibility | Better | Good |

**Note**: With this setup, bash provides 80% of zsh's interactive experience but remains more POSIX-compatible.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Ctrl+R not fuzzy searching | Ensure fzf is installed: `which fzf` |
| History search with arrows broken | Check ~/.inputrc has correct keybindings |
| Aliases not working | Verify they're in ~/.bashrc, not ~/.bash_profile |
| zoxide not working | Run `eval "$(zoxide init bash)"` in .bashrc |
| Slow startup | Remove unused plugins/aliases, profile with `time bash -i -c ''` |

## Performance Notes

- Startup time: ~100-150ms (faster than zsh)
- FZF queries use fd (fast, respects .gitignore)
- Good for scripting and system maintenance tasks
- Suitable as fallback when zsh unavailable

## References

- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [Readline Init File Syntax](https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File-Syntax.html)
- [Starship Prompt](https://starship.rs/)
- [fzf](https://github.com/junegunn/fzf)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
