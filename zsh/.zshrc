# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Created by `pipx` on 2025-08-02 11:24:42

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# export PATH="/usr/local/mysql/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# export PATH="$(brew --prefix icu4c@77)/bin:$PATH"

# alias claude="/Users/kwj903/.claude/local/claude"

# Task Master aliases added on 2025. 9. 9.
alias tm='task-master'
alias taskmaster='task-master'
export CODEX_API_KEY=6aca62555dd568ca6ad7bfb2a44dbb98f1c588e7

# OpenClaw Completion
source "/Users/kwj903/.openclaw/completions/openclaw.zsh"

# Added by Antigravity
# export PATH="/Users/kwj903/.antigravity/antigravity/bin:$PATH"

export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"

# ----- History Optimization -----
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan,bold'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# 히스토리 강화
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
eval "$(zoxide init zsh)"

# 명령어 별명 추가
alias cat="bat --paging=never"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}' --preview-window=right:60%"
alias ls="eza"
alias ll="eza -la"
alias grep="rg"
alias g="lazygit"
alias tree="eza --tree"
rgf() {
  rg --line-number --no-heading "$@" |
  fzf --delimiter ':' \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window=right:60% |
  awk -F: '{print $1 ":" $2}' |
  xargs -I {} sh -c 'file=$(echo {} | cut -d: -f1); line=$(echo {} | cut -d: -f2); vim +$line $file'
}
rgfv() {
  rg --line-number --no-heading "$@" |
  fzf --delimiter ':' \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window=right:60% |
  awk -F: '{print $1 ":" $2}' |
  xargs -I {} sh -c '
    file=$(echo {} | cut -d: -f1)
    line=$(echo {} | cut -d: -f2)
    code -g "$file:$line"
  '
}
# 1) fzf 미리보기 옵션(좌/우 방향키로 스크롤, 위아래로 이동)
export _ZO_FZF_OPTS='--height=40% --reverse --preview "ls -la --color=always {} | sed -n 1,200p"'

# 2) zoxide 인터랙티브 선택으로 이동 (fzf UI 뜸)
#    - 방향키로 폴더 선택 → Enter로 이동
cd() { builtin cd "$@"; }
zi() { cd "$(zoxide query --interactive)"; }

# 3) 선택한 폴더를 곧바로 에디터로 열기 (nvim / VS Code 중 택1)
zne() { nvim "$(zoxide query --interactive)"; }   # Neovim
zcode() { code "$(zoxide query --interactive)"; } # VS Code

# 4) fzf 키바인딩(CTRL-R, CTRL-T 등) 활성화 + 선택 위젯 바인딩
#    Homebrew 경로는 macOS 기준
[[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ]] && \
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"

# 5) ^P로 zoxide 인터랙티브(프로젝트 점프) 실행
zoxide_zi_widget(){ zle -I; BUFFER="zi"; zle accept-line; }
zle -N zoxide_zi_widget
bindkey '^P' zoxide_zi_widget

# tailscaile 내 핸드폰 터미널로 이동 명령어 별명
alias myphon='ssh -p 8022 u0_a876@100.97.191.89'
