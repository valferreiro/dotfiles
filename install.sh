#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/config"

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

OS="$(uname -s)"

echo "======================================"
echo "          Dotfiles Installer"
echo "======================================"
echo
echo "Dotfiles: $DOTFILES_DIR"
echo "Sistema:  $OS"
echo

case "$OS" in
    Linux)
        echo "Sistema Linux detectado"
        ;;
    Darwin)
        echo "macOS detectado"
        ;;
    *)
        echo "Sistema no soportado: $OS"
        exit 1
        ;;
esac

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
        local current_target
        current_target="$(readlink "$target")"

        if [ "$current_target" = "$source" ]; then
            echo "Ya configurado: $target"
            return
        fi

        echo "Symlink diferente encontrado:"
        echo "  $target"
        echo "  $current_target"

        rm "$target"

    elif [ -e "$target" ]; then
        mkdir -p "$BACKUP_DIR"

        echo "Backup:"
        echo "  $target"
        echo "  $BACKUP_DIR/"

        mv "$target" "$BACKUP_DIR/"
    fi

    ln -s "$source" "$target"

    echo "Configurado: $target"
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
        current_target="$(readlink "$HOME/.config/fastfetch/images")"

        if [ "$current_target" = "$CONFIG_DIR/fastfetch/images" ]; then
            echo "✓ Fastfetch images ya configuradas"
        else
            rm "$HOME/.config/fastfetch/images"

            ln -s \
                "$CONFIG_DIR/fastfetch/images" \
                "$HOME/.config/fastfetch/images"

            echo "Fastfetch images configuradas"
        fi

    elif [ -d "$HOME/.config/fastfetch/images" ]; then
        mkdir -p "$BACKUP_DIR"

        echo "Backup:"
        echo "  $HOME/.config/fastfetch/images"
        echo "  $BACKUP_DIR/"

        mv \
            "$HOME/.config/fastfetch/images" \
            "$BACKUP_DIR/"

        ln -s \
            "$CONFIG_DIR/fastfetch/images" \
            "$HOME/.config/fastfetch/images"

        echo "Fastfetch images configuradas"

    else
        ln -s \
            "$CONFIG_DIR/fastfetch/images" \
            "$HOME/.config/fastfetch/images"

        echo "Fastfetch images configuradas"
    fi
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
else
    echo
    echo "No fue necesario crear backups."
fi

echo
echo "Tus configuraciones ahora apuntan al repositorio."
