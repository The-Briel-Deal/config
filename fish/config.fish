source ~/.config/shell/alias

if status is-interactive
    # Commands to run in interactive sessions can go here
end

if test $hostname = "gf.c.googlers.com";
    source ~/.google_fish_config;
end;
