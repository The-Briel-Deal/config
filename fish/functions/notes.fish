function notes --wraps='tmux new-session -As notes -c ~/Notes/' --wraps='tmux new-session -As notes -c ~/Notes/ nvim' --wraps='tmux new-session -As notes -c ~/Notes/ nvim .' --description 'alias notes=tmux new-session -As notes -c ~/Notes/ nvim .'
  tmux new-session -As notes -c ~/Notes/ nvim . $argv
        
end
