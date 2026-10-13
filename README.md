# My dotfiles for zsh, tmux, git

Basic usage 

```shell
TARGET_DIR=$HOME/.dotfiles && \
    git clone https://github.com/fracsi/dotfiles.git "$TARGET_DIR" && \
    sh "$TARGET_DIR/install.sh"
```
The installer downloads:
* [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
* [powerlevel10k](https://github.com/romkatv/powerlevel10k)
* [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

The installer has a `dry-run` mode - add `--dry-run` to the command line arguments.  
The installer creates backups for already existing dotfiles: `.original.bak-Y-m-d_h-i-s`

## Customization

* `.zshrc` loads `~/.zshrc.local` if it exists.
* `.gitconfig` loads `~/.gitconfig.local`.
