function fish_prompt
    if [ $USER = "gabe" ] || [ $USER = "gabrielford" ]
	set nickname "gf"
    else
	set nickname $USER
    end
    printf '%s%s%s~' \
    (set_color $fish_color_user) \
    $nickname \
    (set_color $fish_color_operator)
end
