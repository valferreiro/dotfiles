#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/config"

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

echo "======================================"
echo "        Dotfiles Installer"
echo "======================================"
echo

echo "Dotfiles: $DOTFILES_DIR"
echo "Sistema:  $(uname -s)"
echo

backup_and_link() {
    local source="$1"
    local target="$2"

    if [ ! -e "$source" ]; then
        echo "Fuente no encontrada: $source"
        return
    fi

    mkdir -p "$(dirname "$target")"

    if [ -L "$target" ]; then
        echo "Eliminando symlink existente: $target"
        rm "$target"
    elif [ -e "$target" ]; then
        mkdir -p "$BACKUP_DIR"

        echo "Backup:"
        echo "  $target"
        echo "  → $BACKUP_DIR/"

        mv "$target" "$BACKUP_DIR/"
    fi

    ln -s "$source" "$target"

    echo "✓ $target"
}

echo "Configurando Fish..."
backup_and_link \
    "$CONFIG_DIR/fish/config.fish" \
    "$HOME/.config/fish/config.fish"

backup_and_link \
    "$CONFIG_DIR/fish/fish.conf" \
    "$HOME/.config/fish/fish.conf"

echo
echo "Configurando Kitty..."
backup_and_link \
    "$CONFIG_DIR/kitty/kitty.conf" \
    "$HOME/.config/kitty/kitty.conf"

backup_and_link \
    "$CONFIG_DIR/kitty/current-theme.conf" \
    "$HOME/.config/kitty/current-theme.conf"

echo
echo "Configurando Fastfetch..."
backup_and_link \
    "$CONFIG_DIR/fastfetch/config.jsonc" \
    "$HOME/.config/fastfetch/config.jsonc"

if [ -d "$CONFIG_DIR/fastfetch/images" ]; then
    mkdir -p "$HOME/.config/fastfetch"

    if [ -L "$HOME/.config/fastfetch/images" ]; then
        rm "$HOME/.config/fastfetch/images"
    elif [ -d "$HOME/.config/fastfetch/images" ]; then
        mkdir -p "$BACKUP_DIR"

        echo "Backup:"
        echo "  $HOME/.config/fastfetch/images"

        mv "$HOME/.config/fastfetch/images" "$BACKUP_DIR/"
    fi

    ln -s "$CONFIG_DIR/fastfetch/images" \
          "$HOME/.config/fastfetch/images"

    echo "Fastfetch images"
fi

echo
echo "Configurando Starship..."
backup_and_link \
    "$CONFIG_DIR/starship.toml" \
    "$HOME/.config/starship.toml"

echo
echo "Configurando Git..."
backup_and_link \
    "$CONFIG_DIR/git/.gitconfig" \
    "$HOME/.gitconfig"

echo
echo "======================================"
echo "       Instalación completada"
echo "======================================"

if [ -d "$BACKUP_DIR" ]; then
    echo
    echo "Backups guardados en:"
    echo "$BACKUP_DIR"
fi

echo
echo "Tus configuraciones ahora apuntan al repositorio."
