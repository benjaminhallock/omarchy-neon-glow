# Neon Glow for Omarchy

A dark cyan + magenta Omarchy theme whose active window wears a soft neon halo,
with a tiny one-shot flicker when focus changes.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/benjaminhallock/omarchy-neon-glow/main/install.sh | bash
```

The script clones this repo, copies the theme into
`~/.config/omarchy/themes/neon-glow` (backing up anything already there), and
applies it with `omarchy theme set neon-glow`.

> **Why a custom installer instead of `omarchy theme install <url>`?**
> Omarchy strips Lua from themes cloned from git for safety. This theme's glow
> and flicker live in `hyprland.lua`, so the installer copies it in as a
> hand-written user theme, where Lua is preserved.

To revert: `omarchy theme set gruvbox` (or your previous theme).

## What makes the glow

- `decoration.shadow` uses a vivid cyan/magenta gradient for the **active**
  window and a nearly invisible dark shadow for inactive ones — the halo lives
  outside the window and follows focus.
- `decoration.glow` adds a faint inner rim light in the same colors.
- `general.col.active_border` is a matching 45° gradient, so edge and halo read
  as one light source.
- `dim_inactive = true` with a gentle `dim_strength` keeps the lit window clear
  without darkening the rest of the desktop too much.

## The flicker

`hl.curve("neon-pulse", ...)` is a slightly underdamped spring (about 0.76 of
critical damping). It is used for `border`, `fadeShadow` and `fadeGlow`, so when
a window gains focus the light gives one tiny overshoot and settles. It only
runs on focus changes — no constant redraw.

An optional continuous shimmer is commented out at the bottom of
`hyprland.lua`. It uses Hyprland's `shadowangle`/`glowangle` `loop` animation,
which redraws every frame and can cost battery — enable only if you want it.

## Tuning

Edit `hyprland.lua` in the theme directory, then:

```bash
omarchy theme set neon-glow
hyprctl reload
hyprctl configerrors
```

| What | Where | Effect |
| --- | --- | --- |
| Halo size | `decoration.shadow.range` | Larger = wider bloom |
| Halo softness | `decoration.shadow.render_power` | Lower = softer spread |
| Halo brightness | alpha in `active_shadow` colors | `66` is subtle; `aa` is bold |
| Inner rim | `decoration.glow.*` | Range and color alpha |
| Flicker strength | spring `dampening` | Lower = more overshoot; `18` is subtle |
| Flicker speed | `speed` on the three animations | Deciseconds |
