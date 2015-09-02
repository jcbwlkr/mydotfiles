" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker spell:
"
" Personal .vimrc of Jacob Walker (@jcbwlkr)
"
"   _    _           _ _
"  (_)__| |____ __ _| | |___ _
"  | / _| '_ \ V  V / | / / '_|
" _/ \__|_.__/\_/\_/|_|_\_\_|
"|__/
"
" This file is intended to be a (mostly) stand alone configuration for
" everything I use in Vim. The first time you open vim with this config it
" will clone vundle and install all configured plugins.
"
" Draws heavily from http://vim.spf13.com/

" Setup {{
    " First thing's first, don't try to preserve vi compatibility. This has to
    " be first because it affects the rest of this vimrc.
    set nocompatible

    set shortmess+=filmnrxoOtT " Abbreviation of messages (avoids 'hit enter')
    filetype off               " Required to run before vundle starts

    " Vundle {{
        fun! SetupVundle()
            " Define our install dir and add it to our runtime path
            let plugin_root_dir = expand('$HOME', 1) . '/.vim/bundle'
            let &rtp .= (empty(&rtp) ? '' : ',') . plugin_root_dir.'/vundle'

            " Clone vundle if we don't have it yet
            if !isdirectory(plugin_root_dir . '/vundle')
                echo "*********************************"
                echo "*  First time using this vimrc  *"
                echo "* Installing Vundle and plugins *"
                echo "*********************************"
                execute '!git clone --depth=1 https://github.com/gmarik/vundle ' shellescape(plugin_root_dir . '/vundle', 1)
                let g:jcbwlkr_first_run = 1
            endif

            " Activate vundle
            call vundle#begin()
            Plugin 'gmarik/vundle'
        endfun
        call SetupVundle()
    " }}
" }}

" Plugins {{

    " Colors and UI {{
        Plugin 'bling/vim-airline'
        "Plugin 'edkolev/tmuxline.vim'
        Plugin 'godlygeek/csapprox'
        Plugin 'flazz/vim-colorschemes'
        Plugin 'NLKNguyen/papercolor-theme'
    " }}

    " Utility {{
        " TODO snippets?
        Plugin 'scrooloose/nerdtree'
        Plugin 'jistr/vim-nerdtree-tabs'
        Plugin 'godlygeek/tabular'
        Plugin 'jlemetay/permut'
        Plugin 'scrooloose/syntastic'
        Plugin 'ctrlpvim/ctrlp.vim'
        Plugin 'majutsushi/tagbar'
        Plugin 'scrooloose/nerdcommenter'
        Plugin 'mileszs/ack.vim'
        Plugin 'kristijanhusak/vim-multiple-cursors'
        Plugin 'tpope/vim-abolish.git'
        Plugin 'tpope/vim-surround'
        Plugin 'tpope/vim-repeat'
        Plugin 'tpope/vim-speeddating'
        Plugin 'vim-scripts/restore_view.vim'
        Plugin 'vim-scripts/sessionman.vim'
        Plugin 'PeterRincker/vim-argumentative'
        Plugin 'chrisbra/NrrwRgn'
        Plugin 'editorconfig/editorconfig-vim'
        Plugin 'diepm/vim-rest-console'
        Plugin 'EinfachToll/DidYouMean'
        "Plugin 'joonty/vdebug.git'
    " }}

    " Version Control {{
        Plugin 'mhinz/vim-signify'
        Plugin 'tpope/vim-fugitive'
    " }}

    " Navigation {{
        Plugin 'skwp/vim-easymotion'
        Plugin 'matchit.zip'
    " }}

    " HTML / CSS {{
        Plugin 'groenewege/vim-less'
        Plugin 'hail2u/vim-css3-syntax'
    " }}

    " PHP {{
        Plugin 'spf13/PIV'
        Plugin 'arnaud-lb/vim-php-namespace'
        Plugin 'beyondwords/vim-twig'
        Plugin 'vim-php/tagbar-phpctags.vim'
        Plugin 'vim-php/vim-php-refactoring'
    " }}

    " Go {{
        Plugin 'fatih/vim-go'
        Plugin 'cespare/vim-go-templates'
        Plugin 'corylanou/vim-present'
    " }}

    " Python {{
        Plugin 'klen/python-mode'
        Plugin 'python.vim'
        Plugin 'python_match.vim'
        Plugin 'pythoncomplete'
    " }}

    " Javascript {{
        Plugin 'pangloss/vim-javascript'
        Plugin 'elzr/vim-json'
        Plugin 'Slava/vim-spacebars'
    " }}

    " Databases {{
        Plugin 'veegee/cql-vim'
    " }}

    " Puppet {{
        Plugin 'Puppet-Syntax-Highlighting'
    " }}

    " Markdown {{
        Plugin 'tpope/vim-markdown'
    " " }}

    " Misc {{
        Plugin 'vim-scripts/TwitVim'
        Plugin 'vimwiki'
        Plugin 'mattn/webapi-vim'
        Plugin 'mattn/gist-vim'
        Plugin 'beloglazov/vim-online-thesaurus'
    " }}

    call vundle#end() " Done adding plugins

    filetype plugin indent on   " Automatically detect file types.

    if exists('g:jcbwlkr_first_run')
        " If this is the first run we need to install all of the plugins
        PluginInstall!
    endif
" }}

" General Settings {{
    scriptencoding utf-8

    " Use SPACE for <leader>. Need to map this early so references to <leader>
    " below use the new mapping
    let mapleader = ' '

    " Views, Backups, Swap, Info and Undo files {{
        set viminfo+=n~/.vim/viminfo " Store the viminfo file in ~/.vim/
        set history=1000             " Store a ton of history (default is 20)

        set backup                   " Store backups of files
        set undofile                 " Store undo history in a file
        set undolevels=1000          " Maximum number of changes that can be undone
        set undoreload=10000         " Maximum number lines to save for undo on a buffer reload

        " Make directories for backups, swap, views, and undo
        " Also set appropriate settings to use those dirs
        function! InitializeDirectories()
            let base_dir = $HOME . '/.vim'
            let dir_list = {
                \ 'backups': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swaps': 'directory',
                \ 'undos': 'undodir' }

            for [dirname, settingname] in items(dir_list)
                let directory = base_dir . '/' . dirname . '/'
                if exists("*mkdir")
                    if !isdirectory(directory)
                        call mkdir(directory)
                    endif
                endif
                if !isdirectory(directory)
                    echo "Warning: Unable to create backup directory: " . directory
                    echo "Try: mkdir -p " . directory
                else
                    let directory = substitute(directory, " ", "\\\\ ", "g")
                    exec "set " . settingname . "=" . directory
                endif
            endfor
        endfunction
        call InitializeDirectories()
    " }}

    " Text Formatting {{
        function! SetTabWidth(width)
            exec "set shiftwidth=" . a:width
            exec "set tabstop=" . a:width
            exec "set softtabstop=" . a:width
        endfunction
        set autoindent      " Indent at the same level of the previous line
        set expandtab       " Tabs are spaces, not tabs
        call SetTabWidth(4) " Typically I want columns of 4 spaces

        let custom_width_filetypes = {
            \ 'xml' : 2,
            \ 'html.twig' : 2,
            \ 'ruby' : 2,
            \ 'erb' : 2 }
        for [ft, width] in items(custom_width_filetypes)
            exec "autocmd FileType " . ft . " call SetTabWidth(" . width . ")"
        endfor

        " Use list and listchars to highlight undesired whitespace
        set list
        set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
    " }}

    " Search {{
        set incsearch                   " Find as you type search
        set hlsearch                    " Highlight search terms
        set ignorecase                  " Case insensitive search
        set smartcase                   " Case sensitive when upper case characters are present
    " }}

    set number
    set norelativenumber

    set timeout ttimeoutlen=50 " TODO What is this for exactly and is this the setting I want?
    set mouse=                 " I don't want mouse support
    set pastetoggle=<F12>      " F12 to enable pastetoggle (sane indentation on pastes)
    set nospell                " Spell checking off

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else                   " On Mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    " Disable bells
    set noerrorbells visualbell t_vb=
    if has('autocmd')
        autocmd GUIEnter * set visualbell t_vb=
    endif

    " Tabs and Buffers {{
        set tabpagemax=15               " Only show 15 tabs
        set hidden                 " Allow buffer switching without saving
    " }}

    set cursorline                  " Highlight current line

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set winminheight=0              " Windows can be 0 line high
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=                  " Don't go to previous lines when going left/right
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=2                 " Minimum lines to keep above and below cursor
    set nofoldenable                " Don't auto fold code
    set foldmethod=syntax           " Fold based on syntax

    set nowrap                      " Don't wrap long lines
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set showmatch                   " Show matching brackets/parenthesis
    set matchpairs+=<:>             " Match < and > with %

    set formatoptions+=j            " Remove comment leaders when joining lines in comments
" }}

" Colors and UI {{
    syntax on " Enabled syntax highlighting

    set colorcolumn=120 " Provide visual indicator on column 120 for long lines

    " Status line {{
        set laststatus=2 " Always show status line
        set showcmd      " Show partial commands in status line and selected
                         " characters/lines in visual mode

        if !exists('g:airline_symbols')
          let g:airline_symbols = {}
        endif
        let g:airline_left_sep='ᐳ'
        let g:airline_left_alt_sep='ᐳ'
        let g:airline_right_sep='ᐸ'
        let g:airline_right_alt_sep='ᐸ'
        let g:airline_symbols.branch='⎇'
    " }}

    " Colorscheme {{
        " Default to a light theme
        set background=light
        colorscheme PaperColor
        let g:airline_theme='papercolor'

        if $THEME == "dark"
          set background=dark
          colorscheme bubblegum
          let g:airline_theme='bubblegum'
        end


        highlight clear SignColumn
        highlight clear LineNr
        highlight clear CursorLineNr
    " }}

" }}

" Utility {{
    let g:ackprg="ack -H --nocolor --nogroup --column"

    " Vim REST Console {{
        let g:vrc_trigger = '<leader>r'

        " Add filetype `rest` to NERDCommenter
        let g:NERDCustomDelimiters = {
        \ 'rest': { 'left': '# ' }
        \ }
    " }}

    " Vdebug {{
    "    " TODO move this option to .vimrc.local?
    "    let g:vdebug_options = {
    "    \   "ide_key": "vim",
    "    \   "break_on_open" : 1,
    "    \   "watch_window_style" : "compact",
    "    \   "path_maps": {
    "    \       "/var/www/html": "/home/jwalker/Projects/TimeIPS-server",
    "    \   }
    "    \}
    " }}

    " NERDTree {{
        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=0
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let NERDTreeSortOrder=['\/$', '^main.go$', '\.go$', '*']
        let g:nerdtree_tabs_open_on_gui_startup=0
        let g:NERDShutUp=1

        nmap <Leader>e :NERDTreeToggle<CR>
    " }}

    " Tabular {{
        nmap <Leader>a& :Tabularize /&<CR>
        vmap <Leader>a& :Tabularize /&<CR>
        nmap <Leader>a= :Tabularize /=<CR>
        vmap <Leader>a= :Tabularize /=<CR>
        nmap <Leader>a: :Tabularize /:<CR>
        vmap <Leader>a: :Tabularize /:<CR>
        nmap <Leader>a:: :Tabularize /:\zs<CR>
        vmap <Leader>a:: :Tabularize /:\zs<CR>
        nmap <Leader>a, :Tabularize /,<CR>
        vmap <Leader>a, :Tabularize /,<CR>
        nmap <Leader>a,, :Tabularize /,\zs<CR>
        vmap <Leader>a,, :Tabularize /,\zs<CR>
        nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    " }}

    " Syntastic {{
        let g:syntastic_aggregate_errors = 1
    " }}

    " CTRL P {{
        let g:ctrlp_working_path_mode = 'ra'
        nnoremap <silent> <D-t> :CtrlP<CR>
        nnoremap <silent> <D-r> :CtrlPMRU<CR>
        let g:ctrlp_custom_ignore = {
            \ 'dir':  '\.git$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
        let g:ctrlp_user_command = {
            \ 'types': {
                \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': 'find %s -type f'
        \ }
    " }}

    " Tagbar {{
        nnoremap <silent> <leader>tt :TagbarToggle<CR>
        let g:tagbar_autofocus = 1
        let g:tagbar_autoclose = 1
    " }}

    " Ctags {{
        set tags=./tags;/,~/.vimtags
        " Make tags placed in .git/tags file available in all levels of a repository
        let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
        if gitroot != ''
            let &tags = &tags . ',' . gitroot . '/.git/tags'
        endif
    " }}
" }}

" Version Control {{
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>:GitGutter<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>:GitGutter<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    nnoremap <silent> <leader>gg :GitGutterToggle<CR>
" }}

" Navigation {{
    let b:match_ignorecase = 1
" }}

" HTML / CSS {{
    autocmd BufNewFile,BufRead *.less set filetype=less
" }}

" PHP {{
    let g:DisableAutoPHPFolding = 0
    let g:PIVAutoClose = 0
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig

    let g:php_html_in_strings = 0

    let g:php_refactor_command='refactor'

    let g:syntastic_php_checkers = ['php']
    let g:syntastic_php_phpcs_post_args = "--standard=psr2 -n"
" }}

" Go {{
    " Convenient mappings for all Go things
    au FileType go nmap <leader>r :GoRun!<CR>
    au FileType go nmap <leader>e <Plug>(go-rename)
    au FileType go nmap <leader>s <Plug>(go-implements)
    au FileType go nmap <leader>t :GoTest!<CR>
    au FileType go nmap <leader>c <Plug>(go-coverage)
    au FileType go nmap <leader>v <Plug>(go-vet)
    au FileType go nmap <leader>gd <Plug>(go-doc)

    " Highlight more Go stuff
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_structs = 1

    " Use `goimports` instead of `gofmt`
    let g:go_fmt_command = "goimports"

    let g:syntastic_go_checkers = ['go', 'golint', 'govet']
    let g:syntastic_go_go_test_args="-tags=integration"
    let g:syntastic_go_go_build_args="-o /tmp/"

    " Set custom filetype for Go html/template files
    autocmd BufNewFile,BufRead *.go.html set filetype=gotplhtml

    " Run `gometalinter` on demand
    function! GoMetaLinter() abort
        silent cexpr system("gometalinter ./...")
        cwindow
    endfunction
    au FileType go nmap <leader>l :call GoMetaLinter()<CR>
" }}

" Python {{
    let g:pymode_lint_checker = "pyflakes"
    let g:pymode_utils_whitespaces = 0
    let g:pymode_options = 0
" }}

" JavaScript {{
    nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
    nmap <leader>jT <Esc>:.!python -m json.tool<CR><Esc>:set filetype=json<CR>
    let g:vim_json_syntax_conceal = 0
" }}

" Misc Fun Things {{
    " Twitvim {{
        let g:twitvim_count = 50  " Show me 50 tweets at a time
    " }}

    " Vimwiki {{
        let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/', 'path_html': '~/Dropbox/vimwiki_html/', 'auto_export': '1'}]
    " }}

    " Gist {{
        let g:gist_detect_filetype = 1
        let g:gist_open_browser_after_post = 1
        let g:gist_post_private = 1
    " }}

    " Online Thesaurus {{
        let g:online_thesaurus_map_keys = 0
        nmap <leader>s :OnlineThesaurusCurrentWord<CR>
    " }}
" }}

" Mappings and Macros {{
    " Easier moving in tabs and windows
    map <C-J> <C-W>j
    map <C-K> <C-W>k
    map <C-L> <C-W>l
    map <C-H> <C-W>h

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <Leader>ff :EnableFastPHPFolds<CR>
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Mapping to fix syntax for the whole file
    nmap <leader>fs :syn sync fromstart<CR>

    " Just close this buffer, dang it
    nmap <leader>bd :bd!<cr>

    " TODO something to toggle spell

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Macro to add curly braces to something like a single line if
    let @s='VS{kJj^'

    " Macro to ack for the current word
    let @f=":Ack '\b\b' "

    " Macro to strip trailing whitespace.
    " I don't like having this always on so I invoke it on command.
    let @w=':%s/ \+$//'

    " Macro for PHPUnit to change a setter to an assertEquals and a getter
    let @e='^i$this->assertEquals(f(ldt)li)F(F(pa, />setlrg:noh^j'

    " Macro for PHPUnit to change a getMock to a getMockBuilder with the constructor disabled
    let @c='0/getMock:nohf(iBuilderf;i->disableOriginalConstructor()->getMock()'

    " Show syntax highlighting groups for word under cursor
    " From http://stackoverflow.com/a/7893500/859353
    nmap <F2> :call <SID>SynStack()<CR>
    function! <SID>SynStack()
        if !exists("*synstack")
            return
        endif
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    endfunc
" }}

" Overrides {{
    " Hook to make local changes
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }}
