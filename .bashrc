# Source .profile if it exists
if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi


eval "$(direnv hook bash)"
