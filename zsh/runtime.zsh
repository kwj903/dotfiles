# version manager activation only
# current mode: mise only
# do not enable nvm here; only clean up old nvm leftovers

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# remove old manager leftovers from PATH
path=(${path:#$HOME/.nvm/*})
path=(${path:#$HOME/.pyenv/shims})
path=(${path:#$HOME/.pyenv/bin})

typeset -U path PATH

export PATH
