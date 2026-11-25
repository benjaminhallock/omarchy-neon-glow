-- Neon Glow — a cyan + magenta halo around the active window.
-- Loaded from the active theme by Omarchy at login and on `hyprctl reload`.

local cyan = "rgba(00e5ffee)"
local magenta = "rgba(ff3ddcee)"

local active_border = { colors = { cyan, magenta }, angle = 45 }
local inactive_border = "rgba(2b3446aa)"

-- Three stops keep the outside glow bright on two sides and softer on the third.
local active_shadow = {
  colors = { "rgba(00e5ff66)", "rgba(ff3ddc55)", "rgba(00e5ff66)" },
  angle = 45,
}
local inactive_shadow = "rgba(05070f66)"

-- Hyprland's `glow` is an inner glow: it lights up the rim inside the window.
local active_glow = {
  colors = { "rgba(00e5ff4d)", "rgba(ff3ddc3d)", "rgba(00e5ff4d)" },
  angle = 45,
}
local inactive_glow = "rgba(05070f22)"

hl.config({
  general = {
    border_size = 2,
    col = {
      active_border = active_border,
      inactive_border = inactive_border,
    },
  },

  decoration = {
    rounding = 6,
    rounding_power = 2,

    -- Let the lit window stand out without making the rest hard to read.
    dim_inactive = true,
    dim_strength = 0.08,

    shadow = {
      enabled = true,
      range = 18,
      render_power = 2,
      color = active_shadow,
      color_inactive = inactive_shadow,
    },

    glow = {
      enabled = true,
      range = 12,
      render_power = 3,
      color = active_glow,
      color_inactive = inactive_glow,
    },
  },

  group = {
    col = {
      border_active = active_border,
      border_inactive = inactive_border,
    },
  },
})

-- A tiny overshoot when focus lands on a window: the light blips once, then
-- settles. Damping is ~0.76 of critical, so it reads as a flicker, not a bounce.
hl.curve("neon-pulse", { type = "spring", mass = 1, stiffness = 140, dampening = 18 })

hl.animation({ leaf = "border", enabled = true, speed = 4, spring = "neon-pulse" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 5, spring = "neon-pulse" })
hl.animation({ leaf = "fadeGlow", enabled = true, speed = 5, spring = "neon-pulse" })

-- Optional: a slow shimmer that travels around the halo. It looks lovely, but
-- Hyprland redraws every frame while a *angle loop runs (per the wiki warning),
-- so it is off by default. Uncomment both lines if you want it:
-- hl.animation({ leaf = "shadowangle", enabled = true, speed = 8, style = "loop", bezier = "linear" })
-- hl.animation({ leaf = "glowangle", enabled = true, speed = 8, style = "loop", bezier = "linear" })
