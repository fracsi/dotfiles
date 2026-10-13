alias ls="ls --color=auto"
vimdiff() {
  command vimdiff -c "windo set wrap" "$@"
}
