
# Fish Configuration

# Sin mensaje de bienvenida
set -g fish_greeting

# ------------------------------------------
# Colores
# ------------------------------------------

set fish_color_command ff79c6
set fish_color_param cba6f7
set fish_color_keyword f38ba8
set fish_color_quote a6e3a1
set fish_color_redirection 89b4fa
set fish_color_end f5c2e7
set fish_color_error f38ba8
set fish_color_option 89dceb
set fish_color_operator cba6f7
set fish_color_escape fab387
set fish_color_autosuggestion 6c7086
set fish_color_valid_path 89b4fa

# ------------------------------------------
# Prompt
# ------------------------------------------

function fish_prompt
    set_color "#f5a9ff"
    echo -n (whoami)

    set_color "#89b4fa"
    echo -n "@"

    set_color "#89dceb"
    echo -n (hostname)

    echo -n " "

    set_color "#cba6f7"
    echo -n (prompt_pwd)

    echo

    set_color "#ff79c6"
    echo -n "❯ "

    set_color normal
end

# ------------------------------------------
# Alias
# ------------------------------------------

alias c="clear"

# Los activaremos cuando estén instalados
# alias ls="eza --icons"
# alias ll="eza -lah --icons --git"
# alias la="eza -a --icons"
# alias cat="bat"

# ------------------------------------------
# Programas
# ------------------------------------------

if type -q zoxide
    zoxide init fish | source
end





