# Rice Update: Nord Aesthetic (May 17, 2026)

This document summarizes the changes made to the Ubuntu + i3 + Picom + LazyVim setup to implement a modern Nord-themed environment.

## 1. Window Manager (i3)
- **File:** `~/.config/i3/config`
- **Colors:** Swapped to the **Nord** palette.
- **Compositor:** Pointed to the new `picom.conf`.
- **Tabs/Stacking:** Added `title_align center` and refined Nord Cyan accents for focused tabs.
- **Wallpaper:** Integrated `set-wallpaper.sh` for easy background and bar refreshing.
- **Fixes:** Removed syntax errors at the end of the file.

## 2. Compositor (Picom)
- **File:** `~/.config/picom/picom.conf`
- **Aesthetics:** 
    - **Corners:** `corner-radius = 12`.
    - **Blur:** `dual_kawase` (strength 6) for a premium frosted-glass look.
    - **Shadows:** Refined for better depth on Nord backgrounds.

## 3. Terminal (Kitty)
- **Files:** `~/.config/kitty/kitty.conf` & `current-theme.conf`
- **Theme:** Locked in official Nord colors.
- **Opacity:** Set to `0.85` to show off background blur.

## 4. Status Bar (Polybar)
- **File:** `~/.config/polybar/config.ini` & `colors.ini`
- **Design:** Modern "Floating Pill" layout (98% width, 16px radius).
- **Organization:** Centered Spotify module and segmented workspace indicators.
- **Dynamic Prep:** Added `colors.ini` support for potential future Wallust integration.
- **Multi-Monitor:** Added `toph-hdmi` bar for external displays.

## 5. Automation & Utilities
- **Wallpaper Helper:** Created `~/.local/bin/set-wallpaper.sh` to handle wallpaper setting (`feh`), color generation (`wallust` prep), and bar reloading.
- **Wallust Templates:** Added `polybar.template` for future-proof color syncing.

## 6. Editor (LazyVim)
- **File:** `~/.config/nvim/lua/plugins/nord.lua`
- **Integration:** Installed `nord.nvim` with transparency support enabled (`nord_disable_background = true`).

---

### Key Commands
- **Change Wallpaper:** `set-wallpaper.sh ~/path/to/image.jpg`
- **Reload i3:** `$mod+Shift+r`
- **Validate i3:** `i3 -C`
