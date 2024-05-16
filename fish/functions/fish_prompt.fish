set __fish_git_prompt_show_informative_status 1
set __fish_git_prompt_showuntrackedfiles 1
set __fish_git_prompt_showdirtystate 1
set __fish_git_prompt_showstashstate 1
set __fish_git_prompt_shorten_branch_len 7
set __fish_git_prompt_showcolorhints 1

function fish_prompt
    # Definition of how the fish_prompt looks.
    if [ $USER = "gabe" ] || [ $USER = "gabrielford" ]
	set nickname "gf"
    else
	set nickname $USER
    end

    if [ $status = 0 ]
	set fish_color_status $fish_color_normal
    else
	set fish_color_status $fish_color_error
    end
    switch $hostname
    case "gf.c.googlers.com"
	set hostnickname "ctop"
    case "gabrielford-macbookpro"
	set hostnickname "gmac"
    case "*"
	set hostnickname $hostname
    end
    printf '%s%s%s on %s%s%s at %s%s%s%s%s%s' \
    (set_color $fish_color_user) \
    $nickname \
    (set_color $fish_color_operator) \
    (set_color $fish_color_host) \
    $hostnickname \
    (set_color $fish_color_operator) \
    (set_color $fish_color_cwd) \
    (prompt_pwd) \
    (set_color $fish_color_normal) \
    (fish_git_prompt) \
    (set_color $fish_color_status) \
    " := "
end
