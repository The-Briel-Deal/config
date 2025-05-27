function clean_new_venv --wraps='deactivate && git clean -dfx && python -m virtualenv .venv && source .venv/bin/activate.fish' --description 'alias clean_new_venv deactivate && git clean -dfx && python -m virtualenv .venv && source .venv/bin/activate.fish'
  deactivate && git clean -dfx && python -m virtualenv .venv && source .venv/bin/activate.fish $argv
        
end
