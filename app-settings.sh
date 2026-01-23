#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

confirm_overwrite() {
  local target="$1"
  if [ -e "$target" ]; then
    read -r -p "Overwrite existing settings at ${target}? (y/N) " reply
    if [[ ! "$reply" =~ ^[Yy]$ ]]; then
      echo "Skipping ${target}"
      return 1
    fi
  fi
  return 0
}

# Cursor settings (User directory includes state.vscdb)
cursor_src="$repo_root/init/cursor-user"
cursor_dst="$HOME/Library/Application Support/Cursor/User"
if [ -d "$cursor_src" ]; then
  if confirm_overwrite "$cursor_dst"; then
    if [ -d "$cursor_dst" ]; then
      backup="${cursor_dst}.backup-$(date +%Y%m%d%H%M%S)"
      mv "$cursor_dst" "$backup"
      echo "Backed up existing Cursor settings to $backup"
    fi
    mkdir -p "$(dirname "$cursor_dst")"
    cp -R "$cursor_src" "$cursor_dst"
    echo "Imported Cursor settings."
  fi
fi

# Rectangle settings (plist export)
rectangle_plist="$repo_root/init/rectangle.plist"
if [ -f "$rectangle_plist" ]; then
  defaults import com.knollsoft.Rectangle "$rectangle_plist"
  echo "Imported Rectangle settings."
fi

# Sunsama settings (plist export)
sunsama_plist="$repo_root/init/sunsama.plist"
if [ -f "$sunsama_plist" ]; then
  defaults import com.sunsama.native-app "$sunsama_plist"
  echo "Imported Sunsama settings."
fi
