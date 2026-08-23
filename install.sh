#!/usr/bin/env bash

set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config-backups/dotfiles-$(date +%Y%m%d-%H%M%S)"

COMPONENTS=(
    hypr
    waybar
    kitty
    nvim
    rofi
    mako
    cava
)

PACMAN_PACKAGES=(
    hyprland
    waybar
    kitty
    neovim
    rofi
    mako
    cava
    btop
    thunar

    wl-clipboard
    cliphist

    pipewire
    wireplumber

    brightnessctl
    hypridle
    hyprlock

    networkmanager
    bluez
    bluez-utils

    lm_sensors
    libnotify

    polkit
    hyprpolkitagent

    ttf-jetbrains-mono-nerd
)

AUR_PACKAGES=(
    quickshell
    matugen-bin
    python-pywal16
    awww
    hyprshot
)

print_header() {
    clear
    printf '\n'
    printf '╭──────────────────────────────────────╮\n'
    printf '│     Arch + Hyprland Dotfiles         │\n'
    printf '╰──────────────────────────────────────╯\n'
    printf '\n'
}

pause() {
    printf '\nPress Enter to continue...'
    read -r
}

is_arch() {
    [[ -f /etc/arch-release ]]
}

install_pacman_packages() {
    echo
    echo "==> Installing official Arch packages..."
    echo

    sudo pacman -Syu --needed "${PACMAN_PACKAGES[@]}"

    if [[ $? -ne 0 ]]; then
        echo
        echo "⚠ Some official packages failed to install."
        echo "The installer will continue."
    fi
}

install_aur_packages() {
    echo
    echo "==> Installing AUR packages..."
    echo

    if command -v yay >/dev/null 2>&1; then
        yay -S --needed "${AUR_PACKAGES[@]}"
        return
    fi

    if command -v paru >/dev/null 2>&1; then
        paru -S --needed "${AUR_PACKAGES[@]}"
        return
    fi

    echo "⚠ No AUR helper found."
    echo
    echo "Install these packages manually:"
    printf '  - %s\n' "${AUR_PACKAGES[@]}"
    echo
    echo "Recommended AUR helper: yay or paru."
}

backup_component() {
    local component="$1"
    local target="$CONFIG_DIR/$component"

    if [[ -e "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        echo "Backup: $target"
        cp -a "$target" "$BACKUP_DIR/$component"
    fi
}

install_component() {
    local component="$1"
    local source="$REPO_DIR/$component"
    local target="$CONFIG_DIR/$component"

    if [[ ! -d "$source" ]]; then
        echo "⚠ Skipping $component: not found in repository."
        return
    fi

    backup_component "$component"

    rm -rf "$target"
    cp -a "$source" "$target"

    echo "✓ Installed $component"
}

install_all_configs() {
    echo
    echo "==> Backing up existing configs..."
    echo "Backup directory:"
    echo "  $BACKUP_DIR"
    echo

    mkdir -p "$CONFIG_DIR"

    for component in "${COMPONENTS[@]}"; do
        install_component "$component"
    done

    chmod +x "$CONFIG_DIR/waybar/scripts/"*.sh 2>/dev/null || true

    /usr/bin/find "$CONFIG_DIR/hypr/scripts" \
        -type f -name '*.sh' \
        -exec chmod +x {} \; \
        2>/dev/null || true

    /usr/bin/find "$CONFIG_DIR/rofi" \
        -type f -name '*.sh' \
        -exec chmod +x {} \; \
        2>/dev/null || true
}

generate_colors() {
    echo
    echo "==> Checking generated colors..."

    mkdir -p "$HOME/.cache/wal"

    if [[ ! -f "$HOME/.cache/wal/colors-waybar.css" ]]; then
        echo
        echo "⚠ Pywal colors have not been generated yet."
        echo "Waybar styling requires:"
        echo "  ~/.cache/wal/colors-waybar.css"
        echo
        echo "After installation, generate colors from a wallpaper:"
        echo
        echo '  wal -i /path/to/wallpaper.jpg'
    else
        echo "✓ Existing Pywal palette found."
    fi
}

enable_services() {
    echo
    echo "==> Enabling useful services..."

    sudo systemctl enable NetworkManager.service 2>/dev/null || true
    sudo systemctl enable bluetooth.service 2>/dev/null || true

    echo "✓ Services configured"
}

check_commands() {
    echo
    echo "==> Dependency check"
    echo

    local commands=(
        hyprland
        waybar
        kitty
        nvim
        rofi
        mako
        cava
        btop
        thunar
        wl-copy
        wl-paste
        cliphist
        wpctl
        brightnessctl
        hypridle
        hyprlock
        nmcli
        sensors
        notify-send
        qs
        matugen
        awww
        hyprshot
        wal
    )

    for command_name in "${commands[@]}"; do
        printf '%-20s' "$command_name"

        if command -v "$command_name" >/dev/null 2>&1; then
            echo "✓"
        else
            echo "MISSING"
        fi
    done
}

restore_backup() {
    echo
    echo "Available backups:"
    echo

    if [[ ! -d "$HOME/.config-backups" ]]; then
        echo "No backups found."
        return
    fi

    ls -1 "$HOME/.config-backups"

    echo
    read -r -p "Backup folder name: " backup_name

    local selected="$HOME/.config-backups/$backup_name"

    if [[ ! -d "$selected" ]]; then
        echo "Backup not found."
        return
    fi

    echo
    echo "Restoring from:"
    echo "  $selected"

    for component in "${COMPONENTS[@]}"; do
        if [[ -e "$selected/$component" ]]; then
            rm -rf "$CONFIG_DIR/$component"
            cp -a "$selected/$component" "$CONFIG_DIR/$component"
            echo "✓ Restored $component"
        fi
    done
}

full_install() {
    if ! is_arch; then
        echo "⚠ This installer is intended for Arch Linux."
        echo "Installation cancelled."
        return
    fi

    echo "This will:"
    echo
    echo "  • install required packages"
    echo "  • back up existing configs"
    echo "  • install the dotfiles"
    echo "  • enable NetworkManager/Bluetooth"
    echo
    echo "Nothing outside the listed config folders will be deleted."
    echo

    read -r -p "Continue? [y/N] " answer

    case "$answer" in
        y|Y)
            ;;
        *)
            echo "Cancelled."
            return
            ;;
    esac

    install_pacman_packages
    install_aur_packages
    install_all_configs
    enable_services
    generate_colors
    check_commands

    echo
    echo "╭──────────────────────────────────────╮"
    echo "│        Installation complete         │"
    echo "╰──────────────────────────────────────╯"
    echo
    echo "Backup:"
    echo "  $BACKUP_DIR"
    echo
    echo "Log out and start Hyprland when ready."
}

install_single() {
    print_header

    echo "Available components:"
    echo
    echo "1) Hyprland"
    echo "2) Waybar"
    echo "3) Kitty"
    echo "4) Neovim"
    echo "5) Rofi"
    echo "6) Mako"
    echo "7) Cava"
    echo

    read -r -p "Select: " choice

    case "$choice" in
        1) install_component hypr ;;
        2) install_component waybar ;;
        3) install_component kitty ;;
        4) install_component nvim ;;
        5) install_component rofi ;;
        6) install_component mako ;;
        7) install_component cava ;;
        *) echo "Invalid selection." ;;
    esac
}

while true; do
    print_header

    echo "1) Full installation"
    echo "2) Install one component"
    echo "3) Install dependencies only"
    echo "4) Check dependencies"
    echo "5) Restore backup"
    echo "0) Exit"
    echo

    read -r -p "Select an option: " choice

    case "$choice" in
        1)
            full_install
            pause
            ;;
        2)
            install_single
            pause
            ;;
        3)
            install_pacman_packages
            install_aur_packages
            pause
            ;;
        4)
            check_commands
            pause
            ;;
        5)
            restore_backup
            pause
            ;;
        0)
            echo "Bye."
            exit 0
            ;;
        *)
            echo "Invalid option."
            sleep 1
            ;;
    esac
done
