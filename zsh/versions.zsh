# ------------------------------
# version managers
# current mode: mise only
# python -> mise
# node   -> mise
# ------------------------------

# DO NOT enable pyenv or nvm here.
# Keep this file for runtime activation only.

# ~/.dotfiles/zsh/versions.zsh

# version managers: mise only
if [[ -x "$HOME/.local/bin/mise" ]]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
fi

# remove old manager leftovers from PATH
path=(${path:#$HOME/.nvm/*})
path=(${path:#$HOME/.pyenv/shims})
path=(${path:#$HOME/.pyenv/bin})

# remove duplicates
typeset -U path PATH

export PATH