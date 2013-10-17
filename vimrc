"""""""""""""""""""""""
"  pielgrzym's vimrc  "
"""""""""""""""""""""""

" General initialization ----------------------- {{{
set nocompatible "Turns off vi compatibility - adds cool functionality
"Pathogen{{{
"call pathogen#runtime_append_all_bundles()
runtime bundle/vim-pathogen/autoload/pathogen.vim
silent! call pathogen#infect()
"Eof Pathogen}}}
set t_Co=256 " without this line tmux/screen will do *bad* things to colors, dude
" }}}
" Solarized settings --------------------------- {{{
function! SolLight() " {{{
        set background=light
        colorscheme solarized
endfunction " }}}
function! SolDark() "{{{
        set background=dark
        colorscheme solarized
endfunction " }}}
set background=dark
colorscheme solarized
if has('gui_running')
        call togglebg#map("<F1>")
else
        noremap <F1> :call SolLight()<CR>
        noremap <F2> :call SolDark()<CR>
endif
" }}}
" Various options ------------------------------ {{{
let python_highlight_all = 1
set fencs=utf-8,iso-8859-2,cp1250 "Resolve encoding problems
set autoread "Set to auto read when a file is changed from the outside
set hidden "Enables changing buffer without saving
set history=2000 "Sets how many lines of history VIM has to remember
set ssop=blank,buffers,curdir,folds,localoptions,tabpages,winpos,winsize "Session options
set viminfo='500,<1000,s100,f1,n~/.viminfo "Remember marks, registers (up to 100kb)
set ignorecase " case insensitive search
set smartcase " make searches case-insensitive, unless they contain upper-case letters:
set scrolljump=7
set pastetoggle=<F12>
set modelines=1
set backspace=indent,eol,start " backspacing over all sorts of stuff
filetype plugin on "Enable filetype plugin
filetype indent on "Enable indenting plugin
" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv
" same when jumping to changes!
nnoremap g; g;zz
nnoremap g, g,zz
" }}}
" Nowrap goodies ------------------------------- {{{
set nowrap
set sidescroll=5 "when moving in the file horizontally move 5 columns a time
set listchars+=precedes:←,extends:→ " nice indicators that there is more text horizontally
" }}}
" Backup options ------------------------------- {{{
set backup "Enable creation of backup files
set backupdir=~/.vbk "Place backup files in a hidden dir
"set directory=~/.vbk "Place swap files in a hidden dir
set undofile "persisent undo! new in vim 7.3!
set noswapfile
set undodir=~/.vimundo
" }}}
" User interface and text formatting ----------- {{{
set number "Show line numbers
set wildmenu "Turn on WiLd menu
" wildignore taken from Steve Losh's config:
set wildignore+=.hg,.git,.svn " Version control
set wildignore+=*.aux,*.out,*.toc " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg " binary images
set wildignore+=*.luac " Lua byte code
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.pyc " Python byte code
set wildignore+=*.sw? " Vim swap files
set shortmess=atI "Remove greeting msg and 'press a key' msgs
set laststatus=2 "Statusline always visible
set statusline=[%n]\ %f%-m%-r%-h%-w\ [%Y]\ [%l/%L\]\ %{fugitive#statusline()}\ [%p%%] "Better statusline format
"get rid of gvim toolbars and stuff
set guioptions=
set guifont=Terminus\ Medium\ for\ Powerline:h13
if has("gui_macvim")
        set guifont=Terminus\ Medium\ for\ Powerline:h14
endif
" Resize splits when the window is resized
" au VimResized * exe "normal! \<c-w>="
set noea " no equalalways - closing a window will not resize other!
" text formatting
set expandtab "Use spaces to create tabs
set ai "Auto indent
set si "Smart indet
syntax on "Enable syntax highligting
" }}}
" Autocompletion ------------------------------- {{{
set completeopt=longest,menuone,preview
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
" }}}
" Global Keymappings --------------------------- {{{
"Leader key under '\' is totally inconvenient, remapping to ','
let mapleader = "\<Space>"
let maplocalleader = ","
inoremap jk <esc>
" Quick edit vimrc:
nnoremap <leader>ev :tabnew $MYVIMRC<cr>
" Quick source vimrc:
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <silent> <Leader>w :set nowrap!<CR>
nnoremap <silent> <C-k> :tabp<CR>
nnoremap <silent> <C-j> :tabn<CR>
nnoremap <silent> <Leader>x :MkS<CR>
nnoremap <silent> <Leader>X :MkS <CR> :qal<CR>
" cmap in case we've forgotten to sudo vim before editing file ;)
cmap `w w !sudo tee >/dev/null %
" git reset file changes
cmap `r Git checkout -- %
" }}}
" Gundo ---------------------------------------- {{{
nnoremap <F5> :GundoToggle<CR>
" }}}
" Tagbar --------------------------------------- {{{
nnoremap <silent> <Leader>l :TagbarOpenAutoClose<CR>
let g:tagbar_left = 1
let g:tagbar_compact = 1
" }}}
" CtrlP ---------------------------------------- {{{
nnoremap <silent> <Leader>f :CtrlPBuffer<CR>
nnoremap <silent> <Leader>F :CtrlPFiletype<CR>
" show pylint window. PURRRRRFECT!!!
nnoremap <silent> <Leader>e :CtrlPQuickfix<CR>
" jump between changes in buffer:
nnoremap <silent> <Leader>c :CtrlPChange<CR>
nnoremap <silent> <Leader>o :CtrlP<CR>
" nnoremap <silent> <Leader>d :CtrlPTag<CR>
nnoremap <silent> <Leader>t :CtrlPBufTag<CR>
nnoremap <silent> <Leader>T :CtrlPBufTagAll<CR>
nnoremap <silent> <Leader>` :CtrlPSessions<CR>
let g:ctrlp_cmd = 'CtrlPMRU' " show all mru by default
let g:ctrlp_mruf_relative = 1 " only mru from current workdir
let g:ctrlp_working_path_mode = 'r' " set path to nearest parent containing .git
" let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files'] " use git to search for files
let g:ctrlp_open_multi = 3 " open max 3 splits when multiple files are being opened
let g:ctrlp_jump_to_buffer = 0 " allows to open one buffer more than once
let g:ctrlp_mruf_exclude = 'media/tinymce/.*\|static/tinymce/.*' " ignore those parts of django proj
let g:ctrlp_follow_symlinks = 1 " prooves quite usefull
let g:ctrlp_extensions = ['sessions', 'filetype', 'tags']
" if getcwd() == $HOME
"         let g:ctrlp_max_depth = 0
"         let g:ctrlp_working_path_mode = 'c' " set path to pwd
" endif
" }}}
" Neocomplcache -------------------------------- {{{
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1 " c_p -> compeltion -> current_page
inoremap <expr><C-x> neocomplcache#smart_close_popup()."\<C-x>"
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" }}}
" Vimoutliner ---------------------------------- {{{
let otl_map_tabs = 1
augroup ft_otl
        autocmd!
        autocmd FileType otl set noexpandtab
        autocmd FileType otl set tabstop=4
        autocmd FileType otl set shiftwidth=4
augroup END
" }}}
" Ultisnips ------------------------------------ {{{
" let g:UltiSnipsExpandTrigger="<C-l>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" }}}
" Rope ----------------------------------------- {{{
" let ropevim_goto_def_newwin=1
" map <leader>j :RopeGotoDefinition<CR>
map <localleader>r :RopeRename<CR>
" }}}
" Bash/zsh/etc --------------------------------- {{{
augroup ft_bash
        autocmd!
        autocmd FileType bash,sh,zsh set ai sw=4 sts=4 et
augroup END
" }}}
" Puppet --------------------------------------- {{{
augroup ft_puppet
        autocmd!
        autocmd FileType puppet set ai sw=2 sts=2 et
augroup END
" }}}
" Ruby ----------------------------------------- {{{
augroup ft_ruby
        autocmd!
        autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et
        autocmd FileType ruby,eruby,yaml nmap <buffer> <leader>rci :%!ruby-code-indenter<cr>
augroup END
" }}}
" Django docs ---------------------------------- {{{
" Search tags generated for django .rst docs source files
" to find documentation with CtrlP and open it in given window
function! SearchDjangoDocs()
        let g:django_docs_path = "/home/pielgrzym/work/django_docs/docs/"
        let g:oldtags = &tags
        let g:oldpwd = getcwd()
        :cd `=g:django_docs_path`
        let &tags = g:django_docs_path."tags"
        :CtrlPTag
        let &tags = g:oldtags
endfunction
autocmd BufRead */django_docs/django/docs/* set filetype=rst
noremap <leader>? :call SearchDjangoDocs()<CR>
" }}}
" Vagrant --------------------------------------- {{{
augroup ft_vagrant
        autocmd!
        autocmd BufRead Vagrantfile set ft=ruby
augroup END
" }}}
" Nginx ----------------------------------------- {{{
function! NginxFt()
        autocmd BufRead *.conf set filetype=nginx
endfunction
augroup ft_nginx
        autocmd!
        autocmd BufRead nginx.conf set ft=nginx
        call NginxFt()
augroup END
" }}}
" Python --------------------------------------- {{{
augroup ft_python
        autocmd!
        autocmd FileType python set omnifunc=pythoncomplete#Complete
        " autocmd FileType python set ft=python.django " For SnipMate
        autocmd FileType python set nosmartindent " For SnipMate
        autocmd FileType python iabbrev <buffer> dfe def
        autocmd FileType python iabbrev <buffer> exept except
        autocmd FileType python iabbrev <buffer> ecxept except
        " enable django models snippets if filename models.py
        function! GetCustomSnippets()
                let fname = expand('%:t')
                if fname == 'models.py'
                        :UltiSnipsAddFiletypes dj_models.dj_all.python
                elseif  fname == 'urls.py'
                        :UltiSnipsAddFiletypes dj_urls.dj_all.python
                elseif  fname == 'admin.py'
                        :UltiSnipsAddFiletypes dj_admin.dj_all.python
                elseif  fname == 'views.py'
                        :UltiSnipsAddFiletypes dj_views.dj_all.python
                endif
        endfunction
        " hit T to run doctests for current file and output errors into
        " new vertical split buffer
        function! RunDoctests()
                let fname = expand('%:p')
                :silent w
                :silent vne 'python_doctest_result'
                :set ft=python
                :set buftype=nofile
                :setlocal noswapfile
                :exec ':silent r!python2 -m doctest -f' fname
                :nnoremap <buffer> q :bd<cr>
        endfunction
        autocmd FileType python nnoremap T :call RunDoctests()<cr>

        autocmd FileType python :call GetCustomSnippets()
        " below two mapping to make for example:
        " from django.db import models
        " with cursor over this line cif will remove django.db and place
        " cursor there in insert mode
        " cii will remove stuff after the import statement
        autocmd FileType python onoremap <buffer> if :<c-u>normal! 0f <space>vt <cr>
        autocmd FileType python onoremap <buffer> ii :<c-u>execute "normal! 0/import\rwvg_"<cr>
augroup END
" }}}
" Python mode ---------------------------------- {{{
let g:pymode_run_key = '<localleader>R'
let g:pymode_rope_goto_def_newwin = 'new'
let g:pymode_lint_checker = "pyflakes,pep8"
let g:pymode_lint_config = '/home/pielgrzym/.vim/pylint.ini'
let g:pymode_lint_cwindow = 0
let g:pymode_folding = 0
let g:pymode_syntax = 1
nnoremap <F4> :PyLintWindowToggle<CR>
" }}}
" Gist ----------------------------------------- {{{
let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'firefox %URL%'
" }}}
" Templates ------------------------------------ {{{
autocmd BufNewFile * silent! 0r ~/.vim/templates/%:e.tpl
" }}}
" XML ------------------------------------------ {{{
augroup ft_xml
        autocmd!
        autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
        autocmd FileType xml  let g:AutoClosePairs = {'(': ')', '{': '}', '[': ']', '"': '"', "'": "'", '`': '`', '«': '»'}
augroup END
" }}}
" Html ----------------------------------------- {{{
augroup ft_html
        autocmd!
        autocmd FileType htmldjango set commentstring={#\ %s\ #}
augroup END
" }}}
" Css ------------------------------------------ {{{
augroup ft_css
       autocmd!
       au BufNewFile,BufRead *.less,*.css setlocal foldmethod=marker
       au BufNewFile,BufRead *.less,*.css setlocal foldmarker={,}
       au BufNewFile,BufRead *.less,*.css nnoremap <buffer> <leader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>
augroup END
" }}}
" Java ----------------------------------------- {{{
augroup ft_java
        autocmd!
        autocmd FileType java set noexpandtab
        autocmd FileType java set tabstop=4
        autocmd FileType java set shiftwidth=4
        autocmd FileType java set makeprg=ant\ clean\ install\ -emacs
        autocmd FileType java map <F9> :make<CR>
        autocmd FileType java map <F10> :cp<CR>
        autocmd FileType java map <F11> :cn<CR>
        autocmd FileType java set cinoptions+=jl
        autocmd FileType java nnoremap <silent> <Leader>t :TagbarToggle<CR>
augroup END
" }}}
" PHP (ye old stuff!) -------------------------- {{{
let php_sql_query = 1 "Highlight SQL queries inside php
let php_htmlInStrings = 1 "Highlight HTML inside php strings
"Highlight drupal's .module files as php {{{{
if has("autocmd")
  augroup module
  autocmd BufRead *.module set filetype=php
  autocmd BufRead *.mako set filetype=mako
  augroup END
endif " }}}
" }}}
" Vimscript file settings ---------------------- {{{
augroup filetype_vim
    au!
    au FileType vim setlocal foldmethod=marker
augroup END
" }}}
" Airline -------------------------------------- {{{
let g:airline_powerline_fonts = 1
let g:airline_theme='solarized'
let g:airline_detect_whitespace=0
" let g:airline#extensions#tabline#enabled = 1
let g:airline_mode_map = {'R': 'R', 'c': 'CMD   ', 'V': 'VL', 'v': 'V', 'i': 'I', '^V': 'VB', 'n': 'N'}
" }}}
" Viki ----------------------------------------- {{{
let g:vikiNameSuffix = ".viki"
let g:viki_intervikis = {}
let g:viki_intervikis['V']  = [$HOME."/btsync/wiki", ".viki", "index.viki"]
nnoremap <leader>v :V<cr>
augroup ft_viki
        " au BufNewFile,BufRead *.viki  setf viki
        autocmd BufRead,BufNewFile $HOME/btsync/wiki/* set filetype=viki
        autocmd BufRead,BufNewFile $HOME/btsync/wiki/* nnoremap <silent> <CR> :VikiJump<cr>
        autocmd BufRead,BufNewFile $HOME/btsync/wiki/* nnoremap <silent> <BS> :VikiGoBack<cr>
        autocmd BufRead,BufNewFile $HOME/btsync/wiki/* nnoremap <silent> <Tab> :VikiFindNext<cr>
        autocmd BufRead,BufNewFile $HOME/btsync/wiki/* nnoremap <silent> <S-Tab> :VikiFindPrev<cr>
        autocmd FileType viki set ai sw=4 sts=4 et
augroup END
let g:vikitasks#intervikis = 2
" }}}
" NERDTree ----------------------------------------- {{{
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
" }}}
"
