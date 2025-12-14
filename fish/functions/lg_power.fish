function lg_power --wraps='swaymsg output HDMI-A-1 toggle' --description 'alias lg_power=swaymsg output HDMI-A-1 toggle'
    swaymsg output HDMI-A-1 toggle $argv
end
