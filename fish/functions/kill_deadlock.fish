function kill_deadlock --wraps='WINEPREFIX=$DEADLOCK_WINEPREFIX wineserver -k' --description 'alias kill_deadlock=WINEPREFIX=$DEADLOCK_WINEPREFIX wineserver -k'
    WINEPREFIX=$DEADLOCK_WINEPREFIX wineserver -k $argv
end
