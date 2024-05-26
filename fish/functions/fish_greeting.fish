function fish_greeting
    set -l dog """
                                 ._.
    (___________________________()6 `-,
    (   ______________________   /''\"`
    //\\\\   hi grabriel !      //\\\\
    \"\" \"\"                     \"\" \"\"
    """

    if type -q "lolcat"
	echo $dog | lolcat
    else
	echo $dog
    end
end
