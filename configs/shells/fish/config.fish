if status is-interactive
    # --- Aliases ---
    alias ls='ls --color=auto'
    alias la='ls -A'
    alias ll='ls -alF'
    alias l='ls -CF'
    
    # Modern replacements (only work if installed)
    if type -q eza
        alias ls='eza --icons --git'
        alias la='eza -a --icons --git'
        alias ll='eza -al --icons --git'
        alias lt='eza --tree --icons'
    end

    if type -q bat
        alias cat='bat --paging=never'
    end

    # Utility
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    # Git Aliases (OMZ style)
    alias gst='git status'
    alias ga='git add'
    alias gc='git commit -v'
    alias gcb='git checkout -b'
    alias gp='git push'
    alias gl='git pull'

    # Directory navigation
    alias ..='cd ..'
    alias ...='cd ../..'
    alias ....='cd ../../..'
    alias .....='cd ../../../..'

    # --- Functions ---
    # Create directory and enter it
    function mkcd
        if test -n "$argv[1]"
            mkdir -p $argv[1]; and cd $argv[1]
        end
    end

    # --- FZF configuration ---
    # (Requires fzf.fish plugin)
    if type -q fzf_configure_bindings
        fzf_configure_bindings --directory=\ct --git_log=\cl --git_status=\cs --history=\cr --processes=\cp --variables=\cv
    end

    # --- Colorful Man Pages (via bat) ---
    if type -q bat
        set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
        set -gx MANROFFOPT "-c"
    end
end
starship init fish | source
export PATH="$HOME/.local/bin:$PATH"

# ===== ZOXIDE (smarter cd) =====
zoxide init fish | source

# ===== THEFUCK (fix commands) =====
thefuck --alias | source

# ===== FZF + FD INTEGRATION =====
set -gx FZF_DEFAULT_COMMAND 'fd --type f --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND 'fd --type f --follow --exclude .git'
set -gx FZF_ALT_C_COMMAND 'fd --type d --follow --exclude .git'

# ===== EMACS KEYBINDINGS (explicit) =====
# Fish defaults to emacs, but here it is explicitly
fish_default_key_bindings
