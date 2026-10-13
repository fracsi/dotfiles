#!/bin/sh

DRY_RUN=false
for arg in "$@"; do
    if [ "$arg" = "--dry-run" ]; then
        DRY_RUN=true
        echo "=== DRY-RUN ACTIVATED ==="
        echo "The script just simulates all the steps."
        echo "============================="
    fi
done

run_cmd() {
     if [ "$DRY_RUN" = true ]; then
        echo "$*"
    else
        "$@"
    fi
}

link_item() {
    src_item="$1"
    target_item="$2"
    abs_src=$(realpath "$src_item")

    # Already exists
    if [ -h "$target_item" ] && [ "$(readlink "$target_item")" = "$abs_src" ]; then
        echo "  [OK]   $target_item is already linked"
        return
    fi

    # Exists, but not our symlink - backup
    if [ -e "$target_item" ] || [ -h "$target_item" ]; then
        backup="${target_item}.bak-${TIMESTAMP}"
        echo "  [BAK]  $target_item exists. Backing up to $backup"
        run_cmd mv "$target_item" "$backup"
    fi

    # Symlink
    echo "  [LNK]  Creating symlink: $target_item -> $src_item"
    run_cmd ln -s "$abs_src" "$target_item"
}

SCRIPT_DIR=$(dirname "$0")
# For backups if needed
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Install Oh My Zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Powerlevel10k zsh theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Install Powerlevel10k"
    run_cmd git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Install Tmux Plugin Manager"
    run_cmd git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Symlink dotfiles
for item in "$SCRIPT_DIR/home"/*; do
    link_item "$item" "$HOME/.$(basename "$item")"
done

# Symlink additional files

for item in "$SCRIPT_DIR/zsh"/*.zsh; do
    link_item "$item" "$ZSH_CUSTOM/$(basename "$item")"
done
