"""""""""""""""""""""""""""""""""""""""""""""""""""""" 
"
" VIMRC Pielgrzyma / Pielgrzym's VIMRC
" v. 1.5
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""
" GENERAL OPTIONS
"""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible "Turns off vi compatibility - adds cool functionality

"Pathogen
call pathogen#runtime_append_all_bundles()
"Eof Pathogen

set t_Co=256
color molokai
let python_highlight_all = 1
set fencs=utf-8,iso-8859-2,cp1250 "Resolve encoding problems
set autoread "Set to auto read when a file is changed from the outside
set hidden "Enables changing buffer without saving
set history=2000 "Sets how many lines of history VIM has to remember
set ssop=blank,buffers,curdir,folds,winpos,winsize "Session options
set viminfo='50,<1000,s100,n~/.viminfo "Remember marks, registers (up to 100kb)
set ignorecase " case insensitive search
set smartcase " make searches case-insensitive, unless they contain upper-case letters:
set scrolljump=7
set pastetoggle=<F12>

filetype plugin on "Enable filetype plugin
filetype indent on "Enable indenting plugin
"""""""""""""""""""""""""""""""""""""""""""""""""""""
" BACKUP OPTIONS AND BACKUP DIR SCRIPT
"""""""""""""""""""""""""""""""""""""""""""""""""""""

set backup "Enable creation of backup files
set backupdir=~/.vbk "Place backup files in a hidden dir
set directory=~/.vbk "Place swap files in a hidden dir

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" USER INTERFACE
"""""""""""""""""""""""""""""""""""""""""""""""""""""

set number "Show line numbers
set wildmenu "Turn on WiLd menu
set wildignore=*.pyc
set shortmess=atI "Remove greeting msg and 'press a key' msgs
set laststatus=2 "Statusline always visible
set statusline=[%n]\ %f%-m%-r%-h%-w\ [%Y]\ [%l/%L\]\ %{fugitive#statusline()}\ [%p%%] "Better statusline format

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI
"""""""""""""""""""""""""""""""""""""""""""""""""""""
"get rid of gvim toolbars and stuff
set guioptions=
set guifont=Terminus\ 10

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" TEXT FORMATIING / TEXT LAYOUT
"""""""""""""""""""""""""""""""""""""""""""""""""""""

set expandtab "Use spaces to create tabs
set ai "Auto indent
set si "Smart indet

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" SYNTAX HIGHLIGHTING OPTIONS
"""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax on "Enable syntax highligting
let php_sql_query = 1 "Highlight SQL queries inside php
let php_htmlInStrings = 1 "Highlight HTML inside php strings

"Highlight drupal's .module files as php
if has("autocmd")
  augroup module
  autocmd BufRead *.module set filetype=php
  autocmd BufRead *.mako set filetype=mako
  augroup END
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" AUTOCOMPLETION COFIG
"""""""""""""""""""""""""""""""""""""""""""""""""""""

set completeopt=longest,menuone,preview
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEY MAPPINGS 
"""""""""""""""""""""""""""""""""""""""""""""""""""""

"Leader key under '\' is totally inconvenient, remapping to ','
let mapleader = ","

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUNDO
"""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <F5> :GundoToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" TAGLIST-PLUS
"""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <Leader>t :TagbarToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" TAGLIST-PLUS
"""""""""""""""""""""""""""""""""""""""""""""""""""""
"nnoremap <silent> <Leader>t :TlistToggle<CR>
"let g:Tlist_GainFocus_On_ToggleOpen = 1
"let g:Tlist_Close_On_Select = 1
"let g:Tlist_Compact_Format = 1
"let g:Tlist_File_Fold_Auto_Close = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" FUZZY FINDER
"""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <Leader>f :FufBuffer<CR>
nnoremap <silent> <Leader>o :FufFile<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" INDENT GUIDES
"""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('gui_running')
        let g:indent_guides_auto_colors = 0
        autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=236
        autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=237
endif
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
autocmd FileType python IndentGuidesEnable " auto enable for python

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" NEOCOMPLCACHE
"""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1 " c_p -> compeltion -> current_page
inoremap <expr><C-x> neocomplcache#smart_close_popup()."\<C-x>"
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIMOUTLINER
"""""""""""""""""""""""""""""""""""""""""""""""""""""
let otl_map_tabs = 1
autocmd FileType otl set noexpandtab
autocmd FileType otl set tabstop=4
autocmd FileType otl set shiftwidth=4

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" SNIPMATE
"""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType python set ft=python.django " For SnipMate
autocmd FileType html set ft=htmldjango.html " For SnipMate
autocmd FileType xhtml set ft=htmldjango.html " For SnipMate

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" TEMPLATES
"""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufNewFile * silent! 0r ~/.vim/templates/%:e.tpl
