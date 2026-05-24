#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

stow -t "$HOME" i3 i3status kitty nvim picom
