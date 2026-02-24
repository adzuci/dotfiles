#!/usr/bin/env bash

set -euo pipefail

if [ "$(uname)" != "Darwin" ]; then
  echo "This script only supports macOS."
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
code_dir="${CODE:-$HOME/code}"

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update
brew bundle --file "$repo_root/Brewfile.base"
if [ "${1:-}" != "--base-only" ]; then
  brew bundle --file "$repo_root/Brewfile.personal"
fi

# Optional post-bundle installs
if command -v npm >/dev/null 2>&1; then
  npm install --global fast-cli
fi

if command -v gem >/dev/null 2>&1; then
  gem install tmuxinator teamocil
fi

# Fonts
mkdir -p "$code_dir"

if [ ! -d "$code_dir/fira-code" ]; then
  git clone https://github.com/tonsky/FiraCode "$code_dir/fira-code"
  cp "$code_dir/fira-code/distr/ttf/"* "$HOME/Library/Fonts/"
fi

if [ ! -d "$code_dir/fonts" ]; then
  git clone https://github.com/powerline/fonts.git "$code_dir/fonts"
  pushd "$code_dir/fonts" >/dev/null
  ./install.sh
  popd >/dev/null
fi

brew cleanup
