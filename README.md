# Dotfiles

Everything I configure by hand, in one place. Each top-level folder is a
package laid out relative to `$HOME`; `install.sh` symlinks them in.

| package    | links to                                              |
|------------|-------------------------------------------------------|
| bash       | `~/.bashrc`, `~/.bash_profile`, `~/.profile`          |
| git        | `~/.gitconfig`, `~/.gitconfig-work`, `~/.config/git`  |
| ssh        | `~/.ssh/config` (config only — **never keys**)        |
| bin        | personal scripts in `~/.local/bin`                    |
| x11        | `~/.xinitrc` (startx → i3)                            |
| i3, i3status, picom, dunst, kitty | X11 desktop                    |
| hypr, waybar | Wayland desktop (`startw` from a TTY)               |
| nvim       | LazyVim + my overrides in `lua/config`, `lua/plugins` |
| vim, zathura | small stuff                                         |

## Install

```bash
git clone git@github-personal:aayushyatiwari/dotfiles.git ~/dotfiles
~/dotfiles/install.sh          # or: ./install.sh nvim kitty
```

No dependencies (no stow). It stops on a conflict instead of overwriting.

## Two GitHub accounts

- `github.com` / `github-personal` → personal key, personal identity.
- Any repo under `~/work/` → work name/email **and** work SSH key
  (`~/.gitconfig-work` sets `core.sshCommand`), regardless of remote host.

## Secrets

Not in this repo (it's public). They live in `~/.secrets/` (chmod 700):
`env` is sourced by `.bashrc` for API keys.
