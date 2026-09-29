#!/usr/bin/env bash
# Symlink every package in this repo into $HOME.
#
# Layout is stow-compatible: <package>/<path relative to $HOME>.
#   <pkg>/.config/<app>/   -> linked as one directory  (~/.config/<app>)
#   anything else          -> linked file by file      (~/.bashrc, ~/.ssh/config, ...)
#
# Safe to re-run. Never overwrites a real file: if something is in the way it
# stops and tells you, so you can move it aside yourself.
#
# Usage: ./install.sh            link all packages
#        ./install.sh nvim i3    link only these
set -euo pipefail

DOT="$(cd "$(dirname "$0")" && pwd)"
cd "$DOT"

packages=("$@")
[ ${#packages[@]} -eq 0 ] && packages=(*/)

link() { # link <source in repo> <target in $HOME>
    local src="$1" dst="$2"
    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$src" ]; then
        return # already correct
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        echo "CONFLICT: $dst exists and is not a link to $src — move it and re-run" >&2
        exit 1
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "linked $dst"
}

for pkg in "${packages[@]}"; do
    pkg="${pkg%/}"
    [ -d "$pkg" ] || { echo "no such package: $pkg" >&2; exit 1; }

    # ~/.config/<app> as whole directories
    if [ -d "$pkg/.config" ]; then
        for app in "$pkg"/.config/*; do
            link "$DOT/$app" "$HOME/.config/$(basename "$app")"
        done
    fi

    # everything else, file by file
    while IFS= read -r -d '' f; do
        rel="${f#"$pkg"/}"
        link "$DOT/$f" "$HOME/$rel"
    done < <(find "$pkg" -path "$pkg/.config" -prune -o -type f -print0)
done
