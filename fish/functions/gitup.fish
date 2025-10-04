function gitup --wraps='git checkout main && git pull && git checkout - && git rebase main' --description 'alias gitup=git checkout main && git pull && git checkout - && git rebase main'
  git checkout main && git pull && git checkout - && git rebase main $argv
end
