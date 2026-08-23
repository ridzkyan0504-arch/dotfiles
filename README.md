# 🐧 Arch Linux + Hyprland Dotfiles

My personal **Arch Linux + Hyprland** dotfiles.

A clean and minimal desktop setup with dynamic colors, custom Waybar, Neovim, Rofi, Kitty, Mako, and Cava.

> [!WARNING]
> These are my personal configuration files.  
> Back up your existing configs before using them.

## ✨ Setup

| Component | Application |
|---|---|
| 🪟 Window Manager | Hyprland |
| 📊 Bar | Waybar |
| 💻 Terminal | Kitty |
| ✏️ Editor | Neovim |
| 🚀 Launcher | Rofi |
| 🔔 Notifications | Mako |
| 🎵 Audio Visualizer | Cava |
| 🎨 Colors | Matugen / Pywal |

## 📁 Structure

```text
dotfiles/
├── cava/
├── hypr/
├── kitty/
├── mako/
├── nvim/
├── rofi/
└── waybar/
```

Each folder corresponds to a configuration inside `~/.config/`.

## 📦 Requirements

This setup is primarily made for **Arch Linux + Hyprland**.

Main packages:

```text
hyprland
waybar
kitty
neovim
rofi
mako
cava
```

Additional utilities used by some features:

```text
wl-clipboard
cliphist
wireplumber
brightnessctl
hypridle
hyprlock
hyprshot
thunar
```

A **Nerd Font** is recommended for icons.

## 🚀 Installation

Clone this repository:

```bash
git clone https://github.com/ridzkyan0504-arch/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### ⚠️ Backup your configs first

Do not overwrite your entire `~/.config` directory.

For example, to install Waybar:

```bash
mv ~/.config/waybar ~/.config/waybar.backup 2>/dev/null || true
cp -r ~/dotfiles/waybar ~/.config/waybar
```

For Hyprland:

```bash
mv ~/.config/hypr ~/.config/hypr.backup 2>/dev/null || true
cp -r ~/dotfiles/hypr ~/.config/hypr
```

The same method can be used for:

- Kitty
- Neovim
- Rofi
- Mako
- Cava

## 🎨 Dynamic Colors

This setup uses **Matugen / Pywal** integration to generate colors based on the current wallpaper.

The generated color/cache files are not included in this repository because they are machine and wallpaper specific.

Some applications can automatically follow the generated color palette.

## ⌨️ Keybinds

| Keybind | Action |
|---|---|
| `SUPER + T` | Open Kitty |
| `SUPER + A` | Open Rofi |
| `SUPER + E` | Open Thunar |
| `SUPER + Q` | Close window |
| `SUPER + F` | Toggle floating |
| `SUPER + V` | Clipboard history |
| `SUPER + C` | Open Cava |
| `SUPER + grave` | Open btop |
| `SUPER + 1..0` | Switch workspace |
| `SUPER + SHIFT + 1..0` | Move window to workspace |
| `SUPER + ALT + ← / →` | Previous / next workspace |
| `SUPER + S` | Toggle special workspace |
| `Print` | Screenshot monitor |
| `SHIFT + Print` | Screenshot region |
| `SUPER + Print` | Screenshot window |

See:

```text
hypr/configs/keybinds.lua
```

for the complete keybind configuration.

## ✏️ Neovim

My Neovim setup uses **lazy.nvim** and includes:

- LSP support
- Treesitter
- Telescope
- Neo-tree
- Autocompletion
- Git integration
- Integrated terminal
- Matugen / Base16 colors
- Catppuccin Mocha fallback

## 🎵 Cava

Cava is used as the audio visualizer.

The repository includes configurations for both normal Cava usage and Waybar integration.

## 🛡️ Safety

Before using these dotfiles:

1. Back up your current configs.
2. Install the required packages.
3. Install a compatible Nerd Font.
4. Review the Hyprland autostart configuration.
5. Review the keybinds.
6. Install configs individually if you already have a customized system.

Never blindly delete your entire config directory:

```bash
rm -rf ~/.config
```

## 🔄 Updating

To update your local clone:

```bash
cd ~/dotfiles
git pull
```

Check local modifications first:

```bash
git status
```

## 📸 Screenshots

Screenshots coming soon.

## 📝 Notes

This repository contains my personal Arch Linux + Hyprland configuration.

The setup will continue to change as I customize and improve it.

Feel free to use individual parts as inspiration for your own rice.

## 📜 License

No license has been added yet.
