function fish_prompt
    if [ $USER = "gabe" ] || [ $USER = "gabrielford" ]
	set nickname "gf"
    else
	set nickname $USER
    end

    switch $hostname
    case "gf.c.googlers.com"
	set hostnickname "ctop"
    case "gabrielford-macbookpro"
	set hostnickname "gmac"
    case "*"
	set hostnickname $hostname
    end
    printf '%s%s%s on %s%s%s at %s%s%s%s %s' \
    (set_color $fish_color_user) \
    $nickname \
    (set_color $fish_color_operator) \
    (set_color $fish_color_host) \
    $hostnickname \
    (set_color $fish_color_operator) \
    (set_color $fish_color_status) \
    (prompt_pwd) \
    (set_color $fish_color_normal) \
    (fish_git_prompt) \
    "=>"

end
