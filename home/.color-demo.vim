" Script to see what all terminal colors would look like in vim.
"
" Run with :so ~/.color-demo.vim
"
" http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
let num = 255
while num >= 0
    exec 'hi col_'.num.' ctermbg='.num.' ctermfg=white'
    exec 'syn match col_'.num.' "ctermbg='.num.':...." containedIn=ALL'
    call append(0, 'ctermbg='.num.':....')
    let num = num - 1
endwhile
