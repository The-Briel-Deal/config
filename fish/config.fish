source ~/.config/shell/alias
source ~/.config/fish/abbr.fish

export MANPAGER='nvim +Man!'

# Load My Work Config if I'm on my Work Laptop.
if test $hostname = "gf.c.googlers.com";
    source ~/.google_fish_config;
    alias copybara='/google/bin/releases/copybara/public/copybara/copybara'

    # Setup Pyenv.
    pyenv init - | source
end;

# Init direnv if it's in path 
if which direnv &>/dev/null
    direnv hook fish | source
end

# Eval Brew on my Mac.
if test $hostname = "gabrielford-macbookpro.roam.internal"
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# Set Editor and Theme.
export EDITOR=vim
export GTK_THEME=Adwaita:dark

# Keybinds
set -g fish_key_bindings fish_vi_key_bindings
  
# TokyoNight Color Palette
set -l foreground c0caf5
set -l selection 283457
set -l comment 565f89
set -l red f7768e
set -l orange ff9e64
set -l yellow e0af68
set -l green 9ece6a
set -l purple 9d7cd8
set -l cyan 7dcfff
set -l pink bb9af7
set -l light_blue b4f9f8
set -l dark_blue 2ac3de
set -l beige cfc9c2
set -l lavender c0caf5

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_option $pink
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection

# Prompt Colors
set -g fish_prompt_color_username $light_blue
set -g fish_prompt_color_hostname $lavender
set -g fish_prompt_color_path $beige
set -g fish_prompt_color_operators $dark_blue

# ZVM
set -gx ZVM_INSTALL "$HOME/.zvm/self"
set -gx PATH $PATH "$HOME/.zvm/bin"
set -gx PATH $PATH "$ZVM_INSTALL/"
