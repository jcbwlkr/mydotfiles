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
    " General Plugins
    Plugin 'gmoe/vim-espresso'               " My favorite dark theme.
    Plugin 'NLKNguyen/papercolor-theme'      " My favorite light theme.
    Plugin 'cocopon/iceberg.vim'             " Another fun dark theme
    Plugin 'jcbwlkr/nofrils'                 " My fork of the 'No Frills' minimal color scheme
    Plugin 'scrooloose/nerdtree'             " IDE-like file browser
    Plugin 'jistr/vim-nerdtree-tabs'         " Make NERDTree work better with tabs
    Plugin 'godlygeek/tabular'               " Used to vertically align stuff
    Plugin 'w0rp/ale'                        " Automatic linting/checking on save
    Plugin 'ctrlpvim/ctrlp.vim'              " Fuzzy file searching
    Plugin 'majutsushi/tagbar'               " Overview of symbols in a file
    Plugin 'scrooloose/nerdcommenter'        " Used to quickly comment/uncomment lines
    Plugin 'mileszs/ack.vim'                 " Use Ack or Ag from within vim
    Plugin 'terryma/vim-multiple-cursors'    " Sublime style multiple cursors
    Plugin 'tpope/vim-abolish.git'           " Search for, substitute, and abbreviate multiple variants of a word
    Plugin 'tpope/vim-surround'              " Act on the surroundings of a thing
    Plugin 'tpope/vim-repeat'                " Used by other plugins to enable `.` repeating
    Plugin 'PeterRincker/vim-argumentative'  " Swap argument order on functions
    Plugin 'editorconfig/editorconfig-vim'   " Respect project specific .editor-config files
    Plugin 'EinfachToll/DidYouMean'          " Prompt to open the correct file when you prematurely hit enter
    Plugin 'mhinz/vim-signify'               " Show VCS status next to line numbers
    Plugin 'tpope/vim-fugitive'              " Do Git stuff from vim
    Plugin 'mattn/gist-vim'                  " Publish Gists from vim
    Plugin 'mattn/webapi-vim'                " Used by other plugins like mattn/gist
    Plugin 'matchit.zip'                     " Make % motion match more things
    Plugin 'diepm/vim-rest-console'          " Explore REST APIs from vim
    Plugin 'vimwiki'                         " Manage a personal Wiki from vim
    Plugin 'beloglazov/vim-online-thesaurus' " Look up synonyms of words from vim
    Plugin 'AnsiEsc.vim'                     " Add command to conceal ansi color codes in log files etc
    Plugin 'SirVer/ultisnips'                " Use snippets for common patterns
    Plugin 'junegunn/goyo.vim'               " zen mode to focus on one file
    Plugin 'darfink/vim-plist'
    "Plugin 'Yggdroot/indentLine'             " Support indention guides for spaced files

    " Language Specific Plugins
    Plugin 'fatih/vim-go'               " The de facto standard for Go dev in vim
    Plugin 'tpope/vim-rails'            "
    Plugin 'Scuilion/markdown-drawer'   " Get an outline view of Markdown files
    Plugin 'kylef/apiblueprint.vim'     " Support the API Blueprint specification from apiary.io
    Plugin 'jparise/vim-graphql'        " Syntax support for graphql files
    Plugin 'leafgarland/typescript-vim' " Syntax support for TypeScript

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
        call SetTabWidth(2) " Typically I want columns of 2 spaces

        " Use list and listchars to highlight whitespace
        set list
        set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
    " }}

    " Search {{
        set incsearch                   " Find as you type search
        set hlsearch                    " Highlight search terms
        set ignorecase                  " Case insensitive search
        set smartcase                   " Case sensitive when upper case characters are present
        " Hit backspace in normal mode to clear hlsearch
        nmap <silent> <BS> :nohlsearch<CR>
    " }}

    set number
    set norelativenumber

    set timeout ttimeoutlen=50 " TODO What is this for exactly and is this the setting I want?
    set mouse=a                " Mouse support is nice sometimes
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
    set nomodeline                  " Disable modelines. They're a nice idea but frequently have security issues. See CVE-2019-12735.
    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set winminheight=0              " Windows can be 0 line high
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=                  " Don't go to previous lines when going left/right
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=2                 " Minimum lines to keep above and below cursor
    set nofoldenable                " Don't auto fold code
    set foldmethod=indent           " But if I do fold code just do it by indentation level
    set cm=blowfish2                " Use blowfish for VimCrypt

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

        set statusline=%f       " Path to the file
        set statusline+=%<      " If status line is too long truncate here
        set statusline+=\ %y    " File type, e.g. [go]
        set statusline+=%r      " [RO] if file is read only
        set statusline+=%m      " [+] if file is modified
        set statusline+=%=      " Switch to right side
        set statusline+=%p%%    " Percentage through file in lines
        set statusline+=\ %l,%c " Line, Column numbers
        set statusline+=\ [%o]    " Byte offset in the file

        set showmode " Show current mode below the status line on left side
                     " (when not in normal mode)
        set showcmd  " Show partial commands below the status line on the
                     " right (and selected characters/lines in visual mode)
    " }}

    " Colorscheme {{
        set t_Co=256
        set background=dark
        "set termguicolors

        " Set color scheme as espresso but tweak it a bit. These tweaks are in
        " a hooked function because Goyo will switch between color schemes as
        " needed and I want to tweaks to be reapplied when I switch back.
        function! s:tweak_espresso_colors()
          hi Normal ctermbg=none
          hi Comment ctermbg=none
          "hi Search ctermbg=153 ctermfg=255
        endfunction
        autocmd! ColorScheme espresso call s:tweak_espresso_colors()
        colorscheme espresso
        "colorscheme PaperColor
        "colorscheme nofrils-light
        "colorscheme iceberg
    " }}
" }}

" Utility {{
    let g:ackprg="ack -H --nocolor --nogroup --column"

    " Fugitive {{
      " Let q close the :Gblame window
      autocmd FileType fugitiveblame nmap <buffer> q gq
    " }}

    " Vim REST Console {{
        let g:vrc_trigger = '<leader>r'
        let g:vrc_auto_format_response_patterns = {
        \   'json': 'jq .',
        \}

        let g:vrc_curl_opts = {
        \ '--silent' : '',
        \ '--include' : '',
        \ '--insecure' : '',
        \}

        " Add filetype `rest` to NERDCommenter
        let g:NERDCustomDelimiters = {
        \ 'rest': { 'left': '# ' }
        \ }
    " }}

    " NERDTree {{
        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.sw[op]$', '\.git', '\.hg', '\.svn', '\.bzr']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=0
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let NERDTreeSortOrder=['\/$', '^main.go$', '^main_test.go$'] ", '^[A-Z].*\.go$', '\.go$']
        let g:nerdtree_tabs_open_on_gui_startup=0

        nmap <Leader>e :NERDTreeToggle<CR>
        nmap <Leader>F :NERDTreeFind<CR>
    " }}

    " Ale {{
        " Only lint when I save, not as I type.
        let g:ale_lint_on_text_changed = 'never'
        " Don't lint html files
        let g:ale_pattern_options = {
        \   '.*\.html$': {'ale_enabled': 0},
        \}
        " Include the name of the linter in the error message
        let g:ale_echo_msg_format = '(%linter%) %code: %%s'

        " Don't put virtual text at the end of offending lines
        let g:ale_virtualtext_cursor = 'disabled'

        let g:ale_go_golangci_lint_package = 1
    " }}

    " CTRL P {{
        let g:ctrlp_working_path_mode = '0'
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

" Navigation {{
    let b:match_ignorecase = 1

    nmap <Leader>n :cnext<CR>
    nmap <Leader>p :cprevious<CR>
" }}

" Go {{
    " Convenient mappings for all Go things
    au FileType go nmap <leader>r :GoRun!<CR>
    au FileType go nmap <leader>e <Plug>(go-rename)
    au FileType go nmap <leader>s <Plug>(go-implements)
    au FileType go nmap <leader>gt :GoTest!<CR>
    au FileType go nmap <leader>c <Plug>(go-coverage)
    au FileType go nmap <leader>v <Plug>(go-vet)
    au FileType go nmap <leader>gd <Plug>(go-doc)
    au FileType go nmap <leader>ga :GoAlternate!<CR>
    au FileType go nmap <leader>D :GoDescribe<CR>

    " This is already handled by Ctrl-] which is more generally applicable so
    " I am removing support for <leader>d to break myself of the habit.
    "au FileType go nmap <leader>d :GoDef<CR>

    " Use `goimports` instead of `gofmt`
    let g:go_fmt_command = "goimports"

    " Put my company's imports after 3rd party imports
    let g:go_fmt_options = {
      \ 'goimports': '-local github.com/udacity',
      \ }

    " Enable the 'experimental' mode for gofmt so that folds don't get
    " autoclosed on every write
    let g:go_fmt_experimental = 1
" }}

" Elixir {{
    let g:mix_format_on_save = 1
" }}

" JSON {{
    " Use jq to pretty print json files
    nmap <leader>jt <Esc>:%!jq .<CR><Esc>:set filetype=json<CR>
    nmap <leader>jT <Esc>:.!jq .<CR><Esc>:set filetype=json<CR>
    let g:vim_json_syntax_conceal = 0
" }}

" Misc Fun Things {{
    " Vimwiki {{
        let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/'}]
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
    nmap <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Just close this buffer, dang it
    nmap <leader>bd :bd!<cr>

    " Shortcut to put a diff
    nmap <leader>dp :diffput<cr>

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

    " Macro to condense two lines of an if statement into one
    let @e='^iif Jxxr;'

    " Macro to turn 'func main' into 'func main' and 'func run'
    let @r='oif err := erkbkbrun(); err != nil {log.Fatal(err)}}func run() error {ýa'

    " Macro to change the contents of some quotes with a new uuid
    let @i='ci"k:.!uuidgengu$kJxJx'

    " Show syntax highlighting groups for word under cursor
    " From http://stackoverflow.com/a/7893500/859353
    nmap <leader>sn :call <SID>SynStack()<CR>
    function! <SID>SynStack()
        if !exists("*synstack")
            return
        endif
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    endfunc

    " URL encode/decode the current line
    nmap <leader>u :.!php -r 'print urlencode(fgets(STDIN));'<CR>
    nmap <leader>U :.!php -r 'print urldecode(fgets(STDIN));'<CR>
" }}

" Overrides {{
    " Hook to make local changes
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }}

function! GetDiffBuffers()
    return map(filter(range(1, winnr('$')), 'getwinvar(v:val, "&diff")'), 'winbufnr(v:val)')
endfunction

function! DiffPutAll()
    for bufspec in GetDiffBuffers()
        execute 'diffput' bufspec
    endfor
endfunction

map <leader>uc :set makeprg=ucheck-go\ ./... <CR>:make<CR>:copen<CR>

autocmd BufRead /home/jwalker/go/src/github.com/udacity/knowledge/*.go
      \ :GoGuruScope github.com/udacity/knowledge

autocmd BufRead /home/jwalker/go/src/github.com/udacity/gamification/*.go
      \ :GoGuruScope github.com/udacity/gamification
