-- Hyprland.
--
-- Look and feel: ported from Omarchy (github.com/omacom/omarchy, branch
--   quattro, default/hypr/looknfeel.lua + envs.lua + nvidia.lua).
-- Keybindings: ported from ~/.config/i3/config, unchanged. The i3 line each
--   binding came from is quoted above it.
--
--   i3 $mod (Mod1) -> ALT        i3 Mod4 -> SUPER
--
-- API reference: /usr/share/hypr/stubs/hl.meta.lua (point lua-language-server
-- at it for completion). Note that `hyprctl dispatch` now takes Lua too:
--   hyprctl dispatch 'hl.dsp.exit()'


-- --- BASIC SETTINGS -----------------------------------------------------------
local mod = "ALT"

local scripts = "~/.config/hypr/scripts/"

-- i3: exec_always setxkbmap -option "caps:ctrl_modifier"
hl.config({
    input = {
        kb_layout = "us",
        kb_options = "caps:ctrl_modifier",
        follow_mouse = 1,          -- i3 focus_follows_mouse yes (its default)
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
            clickfinger_behavior = true,
            disable_while_typing = true,
        },
    },
})

-- Omarchy: general
local accent_active   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 }
local accent_inactive = "rgba(595959aa)"

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = accent_active,
            inactive_border = accent_inactive,
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    -- Omarchy: decoration. Note that Omarchy runs with square corners, no shadows
    -- and no blur — the polish comes from the gaps, the gradient border and the
    -- animations, not from effects.
    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = { enabled = false },
        blur = { enabled = false },
    },

    -- Omarchy: group + groupbar. This is what $mod+w / $mod+s (tabbed) look like.
    group = {
        col = {
            border_active = accent_active,
            border_inactive = accent_inactive,
        },

        -- New windows opened while a group is focused join that group, which is
        -- what makes it behave like an i3 tabbed container.
        auto_group = true,
        drag_into_group = 1,
        merge_groups_on_drag = true,

        groupbar = {
            font_size = 12,
            font_family = "JetBrainsMono Nerd Font, Iosevka Nerd Font, monospace",
            font_weight_active = "ultraheavy",
            font_weight_inactive = "normal",
            indicator_height = 1,
            indicator_gap = 5,
            height = 22,
            gaps_in = 5,
            gaps_out = 0,
            text_color = "rgb(ffffff)",
            text_color_inactive = "rgba(ffffff90)",
            col = {
                active = "rgba(00000040)",
                inactive = "rgba(00000020)",
            },
            gradients = true,
            gradient_rounding = 0,
            gradient_round_only_edges = false,
        },
    },

    animations = {
        enabled = true,
    },

    -- Omarchy: dwindle. force_split = 2 always opens the new window to the
    -- right/below, instead of i3's "split the longer side". $mod+Ctrl+v and
    -- $mod+Ctrl+h below still preselect explicitly.
    dwindle = {
        preserve_split = true,
        force_split = 2,
    },

    -- Omarchy: misc / cursor / binds
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        disable_scale_notification = true,
        focus_on_activate = true,
        anr_missed_pings = 3,
        on_focus_under_fullscreen = 1,
        initial_workspace_tracking = 0,
        force_default_wallpaper = 0,
    },

    cursor = {
        hide_on_key_press = true,
        warp_on_change_workspace = 1,
    },

    binds = {
        hide_special_on_workspace_change = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    ecosystem = {
        no_update_news = true,
    },
})

-- Omarchy: animation curves and per-leaf speeds, verbatim.
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1.0}  } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 3.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "fadeSwitch",    enabled = false })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = false })


-- --- MONITORS -----------------------------------------------------------------
-- i3: xrandr --output HDMI-1-0 --auto --same-as eDP-1   (mirrored)
--
-- X11's "HDMI-1-0" is a PRIME output on the NVIDIA card; under Wayland it gets
-- a different name. Run `hyprctl monitors` once on your first login and fix the
-- name below if it is not HDMI-A-1.
hl.monitor({ output = "eDP-1",    mode = "preferred", position = "0x0",  scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1, mirror = "eDP-1" })
hl.monitor({ output = "",         mode = "preferred", position = "auto", scale = 1 })  -- catch-all for anything else

-- To go side-by-side instead (the commented xrandr line in the i3 config),
-- replace the HDMI line above with:
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto-right", scale = 1 })


-- --- ENVIRONMENT --------------------------------------------------------------
-- Omarchy: default/hypr/envs.lua
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")

-- Omarchy: default/hypr/nvidia.lua. nvidia-open ships GSP firmware, which is
-- the branch that gets NVD_BACKEND=direct. (Intel UHD 770 + RTX 4050 here.)
hl.env("NVD_BACKEND", "direct")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- If the session comes up black or the external monitor misbehaves, pin the
-- render GPU. Check the order with `ls -l /dev/dri/by-path/`.
-- hl.env("AQ_DRM_DEVICES", "/dev/dri/card1:/dev/dri/card0")


-- --- STARTUP PROGRAMS ---------------------------------------------------------
-- hyprland.start fires once per session, not on reload (the old exec-once).
hl.on("hyprland.start", function()
    -- Hand the session env to systemd --user and D-Bus, otherwise
    -- xdg-desktop-portal (screen sharing, file pickers) starts with an empty
    -- environment.
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    hl.exec_cmd("waybar")                               -- i3: bar { status_command i3status }
    hl.exec_cmd("hyprpaper")                            -- i3: feh --bg-fill
    hl.exec_cmd("dunst")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("hypridle")                             -- i3: xss-lock -- i3lock
    hl.exec_cmd("wl-paste --watch cliphist store")      -- clipboard survives closing the source window
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- i3: redshift -m randr -l 11.93:79.83 -t 6500:3500
    hl.exec_cmd("gammastep -l 11.93:79.83 -t 6500:3500")
end)

-- i3 also ran `dex --autostart` and `flameshot`. dex is not installed on this
-- machine, and flameshot's GUI does not work under Wayland — Print is bound to
-- grim+slurp below instead.


-- --- APP SHORTCUTS ------------------------------------------------------------
local exec = hl.dsp.exec_cmd

-- i3: bindsym Print exec flameshot gui
hl.bind("Print",         exec(scripts .. "screenshot.sh"))
hl.bind("SHIFT + Print", exec(scripts .. "screenshot.sh full"))

-- i3: bindsym $mod+Shift+f exec magnify
hl.bind(mod .. " + SHIFT + F", exec("magnify"))


-- --- AUDIO CONTROLS -----------------------------------------------------------
-- Identical wpctl calls to i3; waybar polls, so there is no i3status SIGUSR1 kick.
-- locked = works on the lock screen, repeating = fires while held.
local held = { locked = true, repeating = true }

hl.bind("XF86AudioRaiseVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),     held)
hl.bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),     held)
hl.bind("XF86AudioMute",        exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),    { locked = true })
hl.bind("XF86AudioMicMute",     exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),  { locked = true })

hl.bind(mod .. " + CTRL + Up",   exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), held)
hl.bind(mod .. " + CTRL + Down", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), held)
hl.bind(mod .. " + CTRL + M",    exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))


-- --- BRIGHTNESS ---------------------------------------------------------------
-- i3 bound bare F6/F7, so they are swallowed globally. Kept as-is.
hl.bind("F6", exec("brightnessctl set 10%-"), held)
hl.bind("F7", exec("brightnessctl set +10%"), held)


-- --- WINDOW MANAGEMENT --------------------------------------------------------
-- i3: floating_modifier $mod  (drag to move, right-drag to resize)
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize())

hl.bind(mod .. " + Return",    exec("kitty"))                -- i3: $mod+Return
hl.bind("SUPER + SHIFT + T",   hl.dsp.window.close())        -- i3: bindsym Mod4+T kill
hl.bind("CTRL + SHIFT + J",    exec("rofi -show drun"))      -- i3: Control+Shift+j

-- focus movement (vim keys)
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

-- move windows
hl.bind(mod .. " + SHIFT + Left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + Down",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + Up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "right" }))

hl.bind(mod .. " + SHIFT + space", hl.dsp.window.float())    -- i3: floating toggle

-- Fullscreen. Your i3 config never bound this, so these are new.
--   $mod+f        true fullscreen - covers the bar, no gaps, no border
--   $mod+Ctrl+f   maximize        - fills the screen but keeps waybar visible
-- Inside a tabbed group both act on the active tab; the group bar disappears
-- in true fullscreen and comes back when you toggle off.
hl.bind(mod .. " + F",        hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mod .. " + CTRL + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- i3: focus mode_toggle — jump focus between the tiling and the floating layer.
-- Hyprland has no dispatcher for this, so ask which layer we are on and hop.
hl.bind(mod .. " + space", function()
    local w = hl.get_active_window()
    if w and w.floating then
        hl.dispatch(hl.dsp.window.cycle_next({ tiled = true }))
    else
        hl.dispatch(hl.dsp.window.cycle_next({ floating = true }))
    end
end)

-- i3's `$mod+a focus parent` walks up the container tree. Hyprland's dwindle
-- has no addressable parent node, so there is nothing to bind here.

hl.bind(mod .. " + Tab",         hl.dsp.focus({ direction = "right" }))  -- i3: $mod+Tab focus right
hl.bind(mod .. " + SHIFT + Tab", hl.dsp.focus({ direction = "left" }))


-- --- WORKSPACES ---------------------------------------------------------------
for i = 1, 10 do
    local key = i % 10 -- workspace 10 is on key 0
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- i3: Mod4+h / Mod4+l -> workspace prev / next
hl.bind("SUPER + H", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + L", hl.dsp.focus({ workspace = "e+1" }))

-- i3: $mod+Shift+minus move scratchpad / $mod+minus scratchpad show
hl.bind(mod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
hl.bind(mod .. " + minus",         hl.dsp.workspace.toggle_special("scratchpad"))


-- --- CONFIG MANAGEMENT --------------------------------------------------------
hl.bind(mod .. " + SHIFT + C", exec("hyprctl reload"))           -- i3: reload
hl.bind(mod .. " + SHIFT + R", exec("hyprctl reload"))           -- i3: restart (reload is the equivalent)
hl.bind(mod .. " + SHIFT + E", exec(scripts .. "exit-prompt.sh"))


-- --- RESIZE MODE --------------------------------------------------------------
-- Same odd-but-yours mapping as i3: j/l shrink, k/semicolon grow.
local function grow(x, y)
    return hl.dsp.window.resize({ x = x, y = y, relative = true })
end

hl.bind(mod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("J",         grow(-10, 0),  { repeating = true })
    hl.bind("K",         grow(0, 10),   { repeating = true })
    hl.bind("L",         grow(0, -10),  { repeating = true })
    hl.bind("semicolon", grow(10, 0),   { repeating = true })

    hl.bind("Left",  grow(-10, 0), { repeating = true })
    hl.bind("Down",  grow(0, 10),  { repeating = true })
    hl.bind("Up",    grow(0, -10), { repeating = true })
    hl.bind("Right", grow(10, 0),  { repeating = true })

    hl.bind("Return", hl.dsp.submap("reset"))
    hl.bind("Escape", hl.dsp.submap("reset"))
end)


-- --- SPLITS AND LAYOUTS -------------------------------------------------------
-- i3: split v / split h  -> dwindle preselects the side the next window opens on
hl.bind(mod .. " + CTRL + V", hl.dsp.layout("preselect d"))
hl.bind(mod .. " + CTRL + H", hl.dsp.layout("preselect r"))

-- i3 had tabbed and stacked layouts. Hyprland's equivalent is a window group,
-- which is tabbed; there is no stacked variant, so both keys make a group.
hl.bind(mod .. " + W",            hl.dsp.group.toggle())
hl.bind(mod .. " + S",            hl.dsp.group.toggle())
hl.bind(mod .. " + bracketright", hl.dsp.group.next())
hl.bind(mod .. " + bracketleft",  hl.dsp.group.prev())

-- Unlike i3's `layout tabbed`, group.toggle only groups the FOCUSED window - it
-- does not sweep up its siblings. These pull a neighbour in / push one out.
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ into_group = "left" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ into_group = "down" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ into_group = "up" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ into_group = "right" }))
hl.bind(mod .. " + SHIFT + G", hl.dsp.window.move({ out_of_group = true }))

hl.bind(mod .. " + E", hl.dsp.layout("togglesplit"))            -- i3: layout toggle split


-- --- WINDOW RULES -------------------------------------------------------------
-- i3 floated every kitty window (`for_window [class="kitty"] floating enable,
-- resize set 800 500, move position center`). Dropped on purpose - kitty tiles
-- now. Re-add a rule here if you ever want the old behaviour back.

-- Sensible defaults i3 got for free from its floating heuristics.
hl.window_rule({
    name  = "tool-dialogs-float",
    match = { class = "^(pavucontrol|blueman-manager|nm-connection-editor)$" },
    float = true,
})

hl.window_rule({
    name  = "pip-float",
    match = { title = "^(Picture-in-Picture)$" },
    float = true,
})

hl.window_rule({
    name  = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})
