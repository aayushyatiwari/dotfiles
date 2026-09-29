# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# ----------------- Core Performance & History -----------------
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s checkwinsize

# ----------------- Environment Variables -----------------
export EDITOR='nvim'
export VISUAL='nvim'

# Hardware Development & ML Toolchain Paths
export CUDA_HOME=/usr/local/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# Tool paths (cargo, go, npm, opencode, ~/.local/bin) — all in one place
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$HOME/go/bin:$HOME/.opencode/bin:$PATH"

# Secrets (API keys) live outside the repo: ~/.secrets/env, chmod 600
[ -f "$HOME/.secrets/env" ] && . "$HOME/.secrets/env"

# ----------------- Prompts & Color Themes -----------------
# Pure, lightning-fast scannable prompt: [Current Directory] $
# Clean mint green accents for terminal clarity
# Classic high-visibility prompt: user@host:current_dir $
force_color_prompt=yes
if [ "$force_color_prompt" = yes ]; then
  # Green for user@host, Blue for full working directory path
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='\u@\h:\w\$ '
fi
unset force_color_prompt

# Ensure terminal windows update titles dynamically
case "$TERM" in
xterm* | rxvt* | alacritty | kitty)
  PS1="\[\e]0;\W\a\]$PS1"
  ;;
*) ;;
esac

# Enable core output coloring
if [ -x /usr/bin/dircolors ]; then
  eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# ----------------- Custom Global Aliases -----------------
alias vi=nvim
alias vim=nvim
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
# work
alias letswork='cd ~/work/sassy_lemon/sassy_lemon/'
alias cb='xclip -selection clipboard'

# Window Management Control
alias lock="i3-msg exit"
alias suspend="i3lock && systemctl suspend"
alias reload="source ~/.bashrc"
alias nvimi3config="vi ~/.config/i3/config"

# Connectivity Profiles
alias bluetooth='blueman-manager'
alias killbluetooth='killall blueman-applet'

# Task Tracking
alias dayplan='cat ~/schedule.txt'

# ----------------- System Completions -----------------
# Standard lightweight programmable completion hook for Arch
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  fi
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/imaayush/miniconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
else
  if [ -f "/home/imaayush/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/home/imaayush/miniconda3/etc/profile.d/conda.sh"
  else
    export PATH="/home/imaayush/miniconda3/bin:$PATH"
  fi
fi
unset __conda_setup
# <<< conda initialize <<<
#
conda deactivate

# ----------------- AtCoder Helpers -----------------
# Run a problem file against input.txt and print output
# Usage: actest A.py   (also works as: actest A)
actest() {
  local file="${1%.py}.py" # accept both "A" and "A.py"
  if [ ! -f "$file" ]; then
    echo "Error: '$file' not found."
    return 1
  fi
  python "$file" <input.txt >output.txt
}

# Scaffold a new AtCoder contest folder from anywhere
# Usage: new_contest ABC459
new_contest() {
  bash /home/imaayush/code/codingContests/new_contest.sh "$@"
}
