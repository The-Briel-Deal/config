set __fish_git_prompt_show_informative_status 1
set __fish_git_prompt_showuntrackedfiles 1
set __fish_git_prompt_showdirtystate 1
set __fish_git_prompt_showstashstate 1
set __fish_git_prompt_shorten_branch_len 7
set __fish_git_prompt_showcolorhints 1


function fish_prompt
    #===Definition=Of=How=The=Fish=Prompt=Looks===#
    function nickname
	#===Abreviate=The=Users=Name===#
	#==Default-to-actual-username==#
	set -f nickname $USER

	#==If-it's-me-use-initial==#
	if [ $USER = "gabe" ] || [ $USER = "gabrielford" ]
	    set -f nickname "gf"
	end

	#==Echo-the-response==#
	echo -n (set_color $fish_prompt_color_username)
	echo $nickname
    end

    function hostname
	#===Abreviate=The=Hosts=Name===#
	switch $hostname
	#==If-it's-work-machine-shorten==#
	case "gf.c.googlers.com"
	    set -f hostnickname "ctop"
	case "gabrielford-macbookpro" "gabrielford-macbookpro.roam.internal"
	    set -f hostnickname "gmac"
	case "*"
	    set -f hostnickname $hostname
	end

	#==Echo-the-response==#
	echo -n (set_color $fish_prompt_color_hostname)
	echo -n $hostnickname
    end

    function prompt_path
	#===Color=The=Path===#
	echo -n (set_color $fish_prompt_color_path)
	echo -n (prompt_pwd)
    end

    #==Set-the-seperators-and-suffix==#
    set at  (set_color $fish_prompt_color_operators)'@'
    set in  (set_color $fish_prompt_color_operators)':'
    set suf (set_color $fish_prompt_color_operators)'=>'

    #==Set-the-prompt-itself==#
    echo -n (nickname)$at(hostname)$in(prompt_path)$suf
end
