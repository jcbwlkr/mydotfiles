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
