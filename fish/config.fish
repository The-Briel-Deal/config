source ~/.config/shell/alias
source ~/.config/fish/abbr.fish

export MANPAGER='nvim +Man!'

# Load My Work Config if I'm on my Work Laptop.
if test $hostname = "gf.c.googlers.com";
    source ~/.google_fish_config;

    # Setup Pyenv.
    pyenv init - | source
end;

# Eval Brew on my Mac.
if test $hostname = "gabrielford-macbookpro.roam.internal"
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# Set Editor and Theme.
export EDITOR=vim
export GTK_THEME=Adwaita:dark
