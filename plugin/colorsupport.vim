" colorsupport.vim: Use color schemes written for gvim in color terminal
"
" Maintainer:       Lee JiHwan <moonz.net@gmail.com>
" Version:          1.0.2
" URL:              http://www.vim.org/script.php?script_id=2682

if exists('g:loaded_colorsupport') || &cp
    finish
endif
let g:loaded_colorsupport = 1

" utility {{{------------------------------------------------------------------
" '#rrggbb' -> [0xrr00, 0xgg00, 0xbb00]
function! s:rgb(rgb)
    return map([1, 3, 5], '("0x" . strpart(a:rgb, v:val, 2)) * 0x100')
endfunction

" normalize color name
function! s:color_name(name)
    return tolower(substitute(a:name, '\s\+', '', 'g'))
endfunction

" '~/.vim/colors/<scheme-name>.vim' -> <scheme-name>
function! s:scheme(path)
    return fnamemodify(a:path, ':t:r')
endfunction

function! s:get_sid()
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_get_sid$')
endfunction
let s:sid = s:get_sid()

function! s:get_funcs(pat)
    redir => l:funcs
    silent execute 'function' '/' . a:pat
    redir END
    return map(split(l:funcs, "\n"), 'v:val[9:strridx(v:val, "(") - 1]')
endfunction
"}}}

" presets {{{------------------------------------------------------------------
" from gnome-terminal
let s:palette_dict = {
\   'tango':
\       [[0x2E2E, 0x3434, 0x3636], [0xCCCC, 0x0000, 0x0000],
\        [0x4E4E, 0x9A9A, 0x0606], [0xC4C4, 0xA0A0, 0x0000],
\        [0x3434, 0x6565, 0xA4A4], [0x7575, 0x5050, 0x7B7B],
\        [0x0606, 0x9820, 0x9A9A], [0xD3D3, 0xD7D7, 0xCFCF],
\        [0x5555, 0x5757, 0x5353], [0xEFEF, 0x2929, 0x2929],
\        [0x8A8A, 0xE2E2, 0x3434], [0xFCFC, 0xE9E9, 0x4F4F],
\        [0x7272, 0x9F9F, 0xCFCF], [0xADAD, 0x7F7F, 0xA8A8],
\        [0x3434, 0xE2E2, 0xE2E2], [0xEEEE, 0xEEEE, 0xECEC]],
\    'console':
\       [[0x0000, 0x0000, 0x0000], [0xAAAA, 0x0000, 0x0000],
\        [0x0000, 0xAAAA, 0x0000], [0xAAAA, 0x5555, 0x0000],
\        [0x0000, 0x0000, 0xAAAA], [0xAAAA, 0x0000, 0xAAAA],
\        [0x0000, 0xAAAA, 0xAAAA], [0xAAAA, 0xAAAA, 0xAAAA],
\        [0x5555, 0x5555, 0x5555], [0xFFFF, 0x5555, 0x5555],
\        [0x5555, 0xFFFF, 0x5555], [0xFFFF, 0xFFFF, 0x5555],
\        [0x5555, 0x5555, 0xFFFF], [0xFFFF, 0x5555, 0xFFFF],
\        [0x5555, 0xFFFF, 0xFFFF], [0xFFFF, 0xFFFF, 0xFFFF]],
\    'xterm':
\       [[0x0000, 0x0000, 0x0000], [0xCDCB, 0x0000, 0x0000],
\        [0x0000, 0xCDCB, 0x0000], [0xCDCB, 0xCDCB, 0x0000],
\        [0x1E1A, 0x908F, 0xFFFF], [0xCDCB, 0x0000, 0xCDCB],
\        [0x0000, 0xCDCB, 0xCDCB], [0xE5E2, 0xE5E2, 0xE5E2],
\        [0x4CCC, 0x4CCC, 0x4CCC], [0xFFFF, 0x0000, 0x0000],
\        [0x0000, 0xFFFF, 0x0000], [0xFFFF, 0xFFFF, 0x0000],
\        [0x4645, 0x8281, 0xB4AE], [0xFFFF, 0x0000, 0xFFFF],
\        [0x0000, 0xFFFF, 0xFFFF], [0xFFFF, 0xFFFF, 0xFFFF]],
\    'rxvt':
\       [[0x0000, 0x0000, 0x0000], [0xCDCD, 0x0000, 0x0000],
\        [0x0000, 0xCDCD, 0x0000], [0xCDCD, 0xCDCD, 0x0000],
\        [0x0000, 0x0000, 0xCDCD], [0xCDCD, 0x0000, 0xCDCD],
\        [0x0000, 0xCDCD, 0xCDCD], [0xFAFA, 0xEBEB, 0xD7D7],
\        [0x4040, 0x4040, 0x4040], [0xFFFF, 0x0000, 0x0000],
\        [0x0000, 0xFFFF, 0x0000], [0xFFFF, 0xFFFF, 0x0000],
\        [0x0000, 0x0000, 0xFFFF], [0xFFFF, 0x0000, 0xFFFF],
\        [0x0000, 0xFFFF, 0xFFFF], [0xFFFF, 0xFFFF, 0xFFFF]]
\ }

let s:cube_dict = {
\   'xterm256'  : insert(range(0x5F, 0xFF, 40), 0),
\   'xterm88'   : insert(range(0x5F, 0xFF, 80), 0),
\   'konsole'   : range(0x00, 0xFF, 0x33),
\   'eterm'     : [0x00, 0x2A, 0x55, 0x7F, 0xAA, 0xD4],
\   'none'      : []
\ }

let s:grey_dict = {
\   'xterm256'  : range(0x08, 0xFF, 10)[:23],
\   'xterm88'   : range(0x1C, 0xFF, 30),
\   'none'      : []
\ }

let s:rgbs_dict = {
\   'unix'      : [
\       '/usr/share/X11',
\       '/usr/lib/X11',
\       '/usr/X11/share/X11',
\       $VIMRUNTIME
\   ]
\ }
"}}}

" defaults {{{-----------------------------------------------------------------
let s:palette_dflt = 'tango'

if &t_Co == 256
    if &term =~? 'konsole'
        let s:cube_dflt = 'konsole'
    elseif &term =~? '^eterm'
        let s:cube_dflt = 'eterm'
    else
        let s:cube_dflt = 'xterm256'
    endif
    let s:grey_dflt = 'xterm256'
elseif &t_Co == 88
    let s:cube_dflt = 'xterm88'
    let s:grey_dflt = 'xterm88'
else
    let s:cube_dflt = 'none'
    let s:grey_dflt = 'none'
endif

let s:rgbs_dflt = 'unix'
"}}}

" customize {{{----------------------------------------------------------------
let s:sfile = expand('<sfile>:t')
function! s:customize()
    for l:var in ['palette', 'cube', 'grey', 'rgbs']
        let l:gvar = 'g:colorsupport_' . l:var
        let l:gname = l:gvar . '_name'
        let l:dict = 's:' . l:var . '_dict'
        let l:dflt = 's:' . l:var . '_dflt'

        if exists(l:gvar)
            if type(eval(l:gvar)) != type([])
                echohl ErrorMsg
                echomsg printf('%s: invalid %s (list expected)',
                \              s:sfile, l:gvar)
                echohl None
                return 1
            endif
            execute printf('let %s["custom"] = %s', l:dict, l:gvar)
            execute printf('let %s = "custom"', l:gname)
        endif

        if !exists(l:gname)
            execute printf('let %s = %s', l:gname, l:dflt)
        endif

        if empty(filter(keys(eval(l:dict)), 'v:val ==# ' . l:gname))
            echohl ErrorMsg
            echomsg printf('%s: unknown %s name "%s"',
            \              s:sfile, l:var, eval(l:gname))
            echohl None
            return 1
        endif
    endfor
    return 0
endfunction

if exists('g:colorsupport_palette') && type(g:colorsupport_palette) == type([])
    call map(g:colorsupport_palette, 's:rgb(v:val)')
endif

if s:customize()
    finish
endif
"}}}

" set palette {{{--------------------------------------------------------------
function! s:get_palette()
    let l:palette = s:palette_dict[g:colorsupport_palette_name]
    let l:comp_vals = s:cube_dict[g:colorsupport_cube_name]
    let l:grey_vals = s:grey_dict[g:colorsupport_grey_name]

    for l:r in l:comp_vals
        for l:g in l:comp_vals
            for l:b in l:comp_vals
                call add(l:palette, [l:r * 0x100, l:g * 0x100, l:b * 0x100])
            endfor
        endfor
    endfor

    for l:c in l:grey_vals
        call add(l:palette, [l:c * 0x100, l:c * 0x100, l:c * 0x100])
    endfor

    return l:palette
endfunction

let s:palette = s:get_palette()
"}}}

" load rgb {{{-----------------------------------------------------------------
function! s:load_rgb()
    for l:dir in s:rgbs_dict[g:colorsupport_rgbs_name]
        let l:file = l:dir . '/rgb.txt'
        if !filereadable(l:file)
            continue
        endif
        let l:s = escape('v:val =~ "^\s*\d"', '\')
        let l:lines = filter(readfile(l:file), l:s)
        for l:split in map(l:lines, 'split(v:val)')
            let [l:r, l:g, l:b] = l:split[:2]
            let l:name = s:color_name(join(l:split[3:]))
            let s:color_map[l:name] = printf('#%02x%02x%02x', l:r, l:g, l:b)
        endfor
    endfor
endfunction

let s:color_map = {}
call s:load_rgb()
"}}}

" :Highlight {{{---------------------------------------------------------------
function! s:distance(rgb1, rgb2)
    let l:dist = 0.0
    for l:i in range(0, 2)
        let l:dist += pow(a:rgb1[l:i] - a:rgb2[l:i], 2) / 3
    endfor
    return float2nr(l:dist)
endfunction

let s:rgb_cache = {}
function! s:map_color(color)
    let l:c = a:color
    if l:c[0] != '#'
        if !has_key(s:color_map, s:color_name(l:c))
            return l:c
        endif
        let l:c = s:color_map[s:color_name(l:c)]
    endif

    if !has_key(s:rgb_cache, l:c)
        let l:distances = map(copy(s:palette), 's:distance(v:val, s:rgb(l:c))')
        let s:rgb_cache[l:c] = index(l:distances, min(l:distances))
    endif

    return s:rgb_cache[l:c]
endfunction

function! s:map_attrs(attrs)
    let l:new_attrs = []
    for l:attr in split(a:attrs, ',')
        if l:attr ==? 'italic'
            continue
        endif
        call add(l:new_attrs, l:attr)
    endfor
    return l:new_attrs
endfunction

function! s:highlight_do(cmd)
    execute a:cmd
    return

    " XXX: deprecated (changing colors_name is easier)
    let l:name = exists('g:colors_name') ? g:colors_name : ''
    execute a:cmd
    if l:name != '' && !exists('g:colors_name')
        " reloaded
        execute a:cmd
        let g:colors_name = l:name
    endif
endfunction

let s:delay = 0
let s:last_cmds = []
function! s:highlight(arg_str)
    " TODO:
    " - argument as quoted string
    " - " could be escaped or be inside quoted string

    " remove comment
    if strlen(substitute(a:arg_str, '[^"]', '', 'g')) % 2 == 0
        let l:arg_str = a:arg_str
    else
        let l:arg_str = a:arg_str[:strridx(a:arg_str, '"') - 1]
    endif

    " ignore cterm*
    let l:args = filter(split(l:arg_str), 'v:val !~? "^cterm.*="')
    if empty(l:args)
        return
    endif

    let l:attrs = []
    let l:fg = -1
    let l:bg = -1

    for l:arg in l:args
        if l:arg !~? '^gui.*='
            continue
        endif

        let [l:key, l:val] = split(l:arg, '=')
        if l:key ==? 'gui'
            call extend(l:attrs, s:map_attrs(l:val))
        elseif l:key =~? '^gui[fb]g$'
            let l:{l:key[-2:]} = s:map_color(l:val)
        elseif l:key ==? 'guisp'
            let l:bg = s:map_color(l:val)
        endif
    endfor

    if l:fg ==? 'bg' && l:bg ==? 'fg'
        let l:fg = -1
        let l:bg = -1
        call add(l:attrs, 'reverse')
    endif

    let l:adds = []
    if !empty(l:attrs)
        call add(l:adds, 'cterm=' . join(l:attrs, ','))
    endif
    for l:key in ['fg', 'bg']
        if l:{l:key} != -1
            call add(l:adds, 'cterm' . l:key . '=' . l:{l:key})
        endif
    endfor

    let l:kw = '^\%(clear\|link\|default\)$'
    if ((l:args[0] !~# l:kw && len(l:args) == 1) ||
    \   (l:args[0] == 'default' && l:args[1] !~# l:kw && len(l:args) == 2)) &&
    \  empty(l:adds)
        return
    endif

    let l:cmd = 'hi ' . join(l:args + l:adds)
    call add(s:last_cmds, l:cmd)
    if !s:delay
        call s:highlight_do(l:cmd)
    endif
endfunction

command! -nargs=* -complete=highlight
\   Highlight :call s:highlight(<q-args>)
"}}}

" default highlights {{{--------------------------------------------------------
function s:hl_dflt_light()
    Highlight SpecialKey    gui=none        guifg=Blue      guibg=none
    Highlight NonText       gui=bold        guifg=Blue      guibg=none
    Highlight Directory     gui=none        guifg=Blue      guibg=none
    Highlight ErrorMsg      gui=none        guifg=White     guibg=Red
    Highlight IncSearch     gui=reverse     guifg=none      guibg=none
    Highlight Search        gui=none        guifg=none      guibg=Yellow
    "Highlight MoreMsg       gui=bold        guifg=SeaGreen  guibg=none
    Highlight ModeMsg       gui=bold        guifg=none      guibg=none
    Highlight LineNr        gui=none        guifg=Brown     guibg=none
    "Highlight Question      gui=bold        guifg=SeaGreen  guibg=none
    Highlight StatusLine    gui=bold,reverse    guifg=none  guibg=none
    Highlight StatusLineNC  gui=reverse     guifg=none      guibg=none
    Highlight VertSplit     gui=reverse     guifg=none      guibg=none
    Highlight Title         gui=bold        guifg=Magenta   guibg=none
    Highlight Visual        gui=none        guifg=none      guibg=LightGrey
    Highlight VisualNOS     gui=bold,underline  guifg=none  guibg=none
    Highlight WarningMsg    gui=none        guifg=Red       guibg=none
    Highlight WildMenu      gui=none        guifg=Black     guibg=Yellow
    Highlight Folded        gui=none        guifg=DarkBlue  guibg=LightGrey
    Highlight FoldColumn    gui=none        guifg=DarkBlue  guibg=Grey
    Highlight DiffAdd       gui=none        guifg=none      guibg=LightBlue
    Highlight DiffChange    gui=none        guifg=none      guibg=LightMagenta
    Highlight DiffDelete    gui=bold        guifg=Blue      guibg=LightCyan
    Highlight DiffText      gui=bold        guifg=none      guibg=Red
    Highlight SignColumn    gui=none        guifg=DarkBlue  guibg=Grey
    Highlight SpellBad      gui=undercurl   guifg=none      guisp=Red
    Highlight SpellCap      gui=undercurl   guifg=none      guisp=Blue
    Highlight SpellRare     gui=undercurl   guifg=none      guisp=Magenta
    Highlight SpellLocal    gui=undercurl   guifg=none      guisp=DarkCyan
    Highlight Pmenu         gui=none        guifg=none      guibg=LightMagenta
    Highlight PmenuSel      gui=none        guifg=none      guibg=Grey
    Highlight PmenuSbar     gui=none        guifg=none      guibg=Grey
    Highlight PmenuThumb    gui=reverse     guifg=none      guibg=none
    Highlight TabLine       gui=underline   guifg=none      guibg=LightGrey
    Highlight TabLineSel    gui=bold        guifg=none      guibg=none
    Highlight TabLineFill   gui=reverse     guifg=none      guibg=none
    Highlight CursorColumn  gui=none        guifg=none      guibg=Grey90
    Highlight CursorLine    gui=none        guifg=none      guibg=Grey90
    Highlight Cursor        gui=reverse     guifg=none      guibg=none
    Highlight lCursor       gui=reverse     guifg=none      guibg=none
    Highlight MatchParen    gui=none        guifg=none      guibg=Cyan
endfunction

function s:hl_dflt_dark()
    Highlight SpecialKey    gui=none        guifg=Cyan      guibg=none
    Highlight NonText       gui=bold        guifg=Blue      guibg=none
    Highlight Directory     gui=none        guifg=Cyan      guibg=none
    Highlight ErrorMsg      gui=none        guifg=White     guibg=Red
    Highlight IncSearch     gui=reverse     guifg=none      guibg=none
    Highlight Search        gui=none        guifg=Black     guibg=Yellow
    "Highlight MoreMsg       gui=bold        guifg=SeaGreen  guibg=none
    Highlight ModeMsg       gui=bold        guifg=none      guibg=none
    Highlight LineNr        gui=none        guifg=Yellow    guibg=none
    Highlight Question      gui=bold        guifg=Green     guibg=none
    Highlight StatusLine    gui=bold,reverse    guifg=none  guibg=none
    Highlight StatusLineNC  gui=reverse     guifg=none      guibg=none
    Highlight VertSplit     gui=reverse     guifg=none      guibg=none
    Highlight Title         gui=bold        guifg=Magenta   guibg=none
    Highlight Visual        gui=none        guifg=none      guibg=DarkGrey
    Highlight VisualNOS     gui=bold,underline  guifg=none  guibg=none
    Highlight WarningMsg    gui=none        guifg=Red       guibg=none
    Highlight WildMenu      gui=none        guifg=Black     guibg=Yellow
    Highlight Folded        gui=none        guifg=Cyan      guibg=DarkGrey
    Highlight FoldColumn    gui=none        guifg=Cyan      guibg=Grey
    Highlight DiffAdd       gui=none        guifg=none      guibg=DarkBlue
    Highlight DiffChange    gui=none        guifg=none      guibg=DarkMagenta
    Highlight DiffDelete    gui=bold        guifg=Blue      guibg=DarkCyan
    Highlight DiffText      gui=bold        guifg=none      guibg=Red
    Highlight SignColumn    gui=none        guifg=Cyan      guibg=Grey
    Highlight SpellBad      gui=undercurl   guifg=none      guisp=Red
    Highlight SpellCap      gui=undercurl   guifg=none      guisp=Blue
    Highlight SpellRare     gui=undercurl   guifg=none      guisp=Magenta
    Highlight SpellLocal    gui=undercurl   guifg=none      guisp=Cyan
    Highlight Pmenu         gui=none        guifg=none      guibg=Magenta
    Highlight PmenuSel      gui=none        guifg=none      guibg=DarkGrey
    Highlight PmenuSbar     gui=none        guifg=none      guibg=Grey
    Highlight PmenuThumb    gui=reverse     guifg=none      guibg=none
    Highlight TabLine       gui=underline   guifg=none      guibg=DarkGrey
    Highlight TabLineSel    gui=bold        guifg=none      guibg=none
    Highlight TabLineFill   gui=reverse     guifg=none      guibg=none
    "Highlight CursorColumn  gui=none        guifg=none      guibg=Grey40
    "Highlight CursorLine    gui=none        guifg=none      guibg=Grey40
    Highlight Cursor        gui=reverse     guifg=none      guibg=none
    Highlight lCursor       gui=reverse     guifg=none      guibg=none
    Highlight MatchParen    gui=none        guifg=none      guibg=DarkCyan
endfunction
"}}}

" :ColorScheme {{{-------------------------------------------------------------
function! ColorSchemeComplete(arg_lead, cmd_line, csr_pos)
    let l:glob = globpath(&runtimepath, 'colors/' . a:arg_lead . '*.vim')
    return map(split(l:glob, "\n"), 's:scheme(v:val)')
endfunction

let s:last_run = ''
function! s:run(cmds)
    " join continued lines
    let @" = substitute(a:cmds, '\n\s*\\', '', 'g')
    let s:last_run = @"
    @"
endfunction

let s:comment = '" Generated by colorsupport.vim (DO NOT MODIFY THIS LINE)'
let s:colors_name = ''
function! s:colorscheme(scheme)
    let l:file = ''
    if a:scheme =~ '/'
        if glob(a:scheme) != ''
            let l:file = a:scheme
        endif
        let l:scheme = substitute(a:scheme, '^.*/', '', '')
        let l:scheme = substitute(l:scheme, '\.vim$', '', '')
    else
        let l:glob = globpath(&runtimepath, 'colors/' . a:scheme . '.vim')
        let l:files = split(l:glob, "\n")
        if len(l:files) != 0
            let l:file = l:files[0]
        endif
        let l:scheme = a:scheme
    endif

    if l:file == ''
        echohl ErrorMsg
        echomsg 'Colorscheme "' . a:scheme . '" not found'
        echohl None
        return
    endif

    hi clear Normal
    set background&

    let l:lines = readfile(l:file)
    if has('gui_running') || (!empty(l:lines) && l:lines[0] == s:comment)
        execute 'source' l:file
        return
    endif

    let l:patsub = [
    \   ['^\s*\(exe\a*\s\+"\)\?hi\a*\s', '\1Highlight '],
    \   ["colors_name\\s*=\\s*['\"]", '\0.'],
    \   ["\\<has(['\"]gui_running['\"])", '!\0'],
    \   ['&term\>', '"builtin_gui"'],
    \   ['', '<ESC>'],
    \   ['\%(g:\)\@<!colors_name\>', 'g:\0'],
    \   ['^\s*fini\a*', 'return'],
    \   ['^\s*sy\a*\s\+enable', '"\0'],
    \   ['<SID>', '\0_'],
    \   ['\<s:', '\0_'],
    \ ]

    let l:s = 'v:val'
    for [l:pat, l:sub] in l:patsub
        let l:pat = escape(l:pat, '\"')
        let l:sub = escape(l:sub, '\"')
        let l:s = printf('substitute(%s, "%s", "%s", "g")', l:s, l:pat, l:sub)
    endfor

    call filter(l:lines, 'v:val !~ "^\\s*\\\""')
    call map(l:lines, l:s)

    let s:delay = 1
    let s:last_cmds = []
    call s:run(join(l:lines, "\n"))
    let s:colors_name = g:colors_name[1:]

    for l:var in filter(keys(s:), 'v:val =~ "^_"')
        unlet s:[l:var]
    endfor
    for l:func in filter(s:get_funcs(s:sid . '__'),
    \                    'v:val =~ "^<SNR>' . s:sid . '__"')
        execute 'delfunction' l:func
    endfor

    " put Normal first in order to make 'fg' and 'bg' work for cterm
    let l:last_cmds = copy(s:last_cmds)
    call filter(s:last_cmds, 'v:val =~? "normal"')
    call s:hl_dflt_{&background}()
    call filter(l:last_cmds, 'v:val !=? "hi clear" && v:val !~? "normal"')
    call extend(s:last_cmds, l:last_cmds)

    let l:background = &background
    hi clear
    for l:cmd in s:last_cmds
        call s:highlight_do(l:cmd)
        " Normal can change &background
        if &background != l:background
            execute 'set background=' . l:background
        endif
    endfor
    let s:delay = 0
endfunction

command! -nargs=1 -complete=customlist,ColorSchemeComplete
\   ColorScheme :call s:colorscheme(<f-args>)

if exists('g:colors_name')
    execute 'ColorScheme' g:colors_name
endif
"}}}

" :ColorSchemeBrowse {{{-------------------------------------------------------
function! s:colorscheme_browse(...)
    execute 'silent bot 10new ColorSchemeBrowse'
    setlocal bufhidden=wipe buftype=nofile nobuflisted
    setlocal noswapfile nowrap

    if a:0 == 0
        let l:glob = globpath(&runtimepath, 'colors/*.vim')
    else
        let l:glob = globpath(a:1, '*.vim')
    endif
    silent put =l:glob
    /^\s*$/delete
    setlocal nomodifiable

    map <buffer> <CR> :ColorScheme <C-R>=getline('.')<CR><CR>
endfunction

command! -nargs=? -complete=dir
\   ColorSchemeBrowse :call s:colorscheme_browse(<f-args>)
"}}}

" :ColorSchemeSave {{{---------------------------------------------------------
function! s:colorscheme_save(...)
    if s:colors_name == ''
        echohl ErrorMsg
        echomsg 'ColorScheme not loaded'
        echohl None
        return
    endif

    let l:name = a:0 == 0 ? s:colors_name : a:1
    let l:file = split(&runtimepath, '\s*,\s*')[0] . '/colors/'
    let l:file .= l:name . '.vim'

    if filereadable(l:file)
        echohl ErrorMsg
        echomsg 'ColorScheme already exists "' . l:file . '"'
        echohl None
        return
    endif

    let l:lines = [
    \   s:comment,
    \   'hi clear',
    \   'set background=' . &background,
    \   'if exists("syntax_on")',
    \   '  syntax reset',
    \   'endif',
    \   'let g:colors_name = "' . l:name . '"'
    \ ] + s:last_cmds

    call writefile(l:lines, l:file)
    echo 'ColorScheme "' . l:file . '" saved'
endfunction

command! -nargs=? ColorSchemeSave :call s:colorscheme_save(<f-args>)
"}}}

" for debugging and testing {{{------------------------------------------------
command! -nargs=0 ColorSchemeDebug :echo s:last_run
command! -nargs=0 ColorSchemePrint :echo join(s:last_cmds, "\n")

function! ColorSchemeTest()
    " setup
    let l:more = &more
    set nomore
    let l:name = exists('g:colors_name') ? g:colors_name : ''

    " test
    let l:glob = globpath(&runtimepath, 'colors/*.vim')
    for l:file in split(l:glob, "\n")
        echo "checking " . l:file
        execute 'ColorScheme' l:file
    endfor

    " teardown
    if l:name != ''
        if l:name[0] == '.'
            let l:name = l:name[1:]
            execute 'ColorScheme' l:name
        else
            execute 'colorscheme' l:name
        endif
    else
        hi clear
    endif
    if l:more == 'more'
        set more
    endif
endfunction
"}}}

" vim: foldmethod=marker
