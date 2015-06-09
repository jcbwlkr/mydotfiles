case "$(uname -s)" in
   Darwin)
     ;;

   Linux)
        alias 'ls'='ls --classify --color=auto --group-directories-first -H'
        # Use vimx if it's available
        hash vimx && alias 'vim'='vimx'
     ;;
esac

alias 'll'='ls -l'
alias 'tmux'='tmux -2'
alias ackgo='ack --ignore-dir=Godeps --go'

# `git show` without changes in vendor dir `Godeps/_workspace`
# git show HEAD -- $(git diff-tree --no-commit-id --name-only -r HEAD | grep -v 'Godeps/_workspace' | xargs)

# `git diff` ignoring changes in `Godeps/_workspace`
# git diff --staged $(git status --porcelain | grep -v Godeps/_workspace | awk '{print $2}')
