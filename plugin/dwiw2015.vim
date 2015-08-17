" dwiw2015.vim -- sensible defaults for a modern text editor

" Maintainer: Michael Kropat <mail@michael.kropat.name>

" Run-once guard
if exists('g:loaded_dwiw2015') || &compatible
    finish
else
    let g:loaded_dwiw2015 = 1
endif

" Group script autocmds so they can be identified with `:autocmd dwiw`
augroup dwiw
autocmd!

if has('win32')
  let s:vimfiles = $HOME . '/vimfiles'
else
  let s:vimfiles = $HOME . '/.vim'
endif

" ###### Settings ######

" backup -- when overwriting a file, take a backup copy
set backup
let &backupdir = s:vimfiles . '/tmp/backup//'
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif

" cursorline -- highlight the entire line the cursor is on
set cursorline

" hidden -- let user switch away from (hide) buffers with unsaved changes
set hidden

" hlsearch -- highlight search term matches
set hlsearch

" ignorecase -- case-insensitive searching, but...
"  smartcase -- become case-sensitive when search term contains upper case
set ignorecase smartcase

" lazyredraw -- don't update screen interactively when running macros etc.
set lazyredraw

" linebreak -- wrap long lines at word breaks instead of fixed length
set linebreak

" listchars -- characters for rendering tab character etc. with :list
if !has('win32') && (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8')
  let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u00b7"
endif

" modeline -- whether to run lines like '# vim: noai:ts=4:sw=4' in any file
"   Disabled, as it tends to be a source of security vulnerabilities
"   Look at the 'securemodelines' plugin for a better alternative
set nomodeline

" number -- show line numbers at the beginning of each line
"   Only enabled in GUI mode, where it is less obtrusive
if has("gui_running") == 1
    set number
endif

" showmatch -- flash matching pair when typing a closing paren, bracket etc.
" matchtime -- tenths of a second to display a showmatch (default: 5)
set showmatch matchtime=3

" showmode -- outputs the "-- INSERT --", etc. messages on the last line
"   Disabled, since vim-airline displays the mode
set noshowmode

" splitbelow -- open horizontal splits below the current window
set splitbelow

" splitright -- open vertical splits to the right of the current window
set splitright

" swapfile -- keep a swap file to help recover from file corruption
"   Disabled since it's so rare and any important file is version controlled
"   (Avoids annoying "recover swap file??" questions)
set noswapfile
let &directory = s:vimfiles . '/tmp/swap//'
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" undofile -- keep a file to persist undo history after file is closed
if has("persistent_undo") == 1
    set undofile
    let &undodir = s:vimfiles . '/tmp/undo//'
    if !isdirectory(expand(&undodir))
        call mkdir(expand(&undodir), "p")
    endif
endif

" visualbell -- instead of audible bell, output terminal code 't_vb'
"   Disable annoying bell by setting 't_vb' to ''
set visualbell t_vb=
" When GUI starts, 't_vb' is reset, so set it again to ''
autocmd GUIEnter * set t_vb=

" wildmode  -- behavior of command-line tab completion
" = list    -- print possible matches
" = longest -- complete until amibguous (same as bash/readline)
set wildmode=list:longest

" Settings inherited from ** vim-sensible ** [3]:
"
" * autoindent
" * autoread
" * backspace
" * complete
" * display
" * encoding
" * fileformats
" * history
" * incsearch
" * laststatus
" * listchars
" * nrformats
" * ruler
" * scrolloff
" * shell
" * shiftround
" * showcmd
" * sidescrolloff
" * sidescrolloff
" * smarttab
" * tabpagemax
" * ttimeout
" * ttimeoutlen100
" * viminfo
" * wildmenu


" ###### Key Bindings ######

" Load Windows keybindings on all platforms except OS-X GUI
"   Maps the usual suspects: Ctrl-{A,C,S,V,X,Y,Z}
if has("gui_macvim") == 0
    source $VIMRUNTIME/mswin.vim

    " Let arrow keys work with visual select
    set keymodel-=stopsel
endif

" C-V -- Gvim: paste                                            [All Modes]
"    Terminal: enter Visual Block mode               [Normal / Visual Mode]
"    Terminal: insert literal character                       [Insert Mode]
" C-Q -- Gvim: enter Visual Block mode               [Normal / Visual Mode]
"        Gvim: insert literal character                       [Insert Mode]
if has("gui_running") == 0
    if ! empty(mapcheck('<C-V>'))
        unmap <C-V>
        iunmap <C-V>
    endif
endif

" C-Y -- scroll window upwards                       [Normal / Visual Mode]
if ! empty(mapcheck('<C-Y>'))
    unmap <C-Y>
endif

" C-Z -- Gvim: undo                                             [All Modes]
"    Terminal: suspend vim and return to shell       [Normal / Visual Mode]
if has("gui_running") == 0
    if ! empty(mapcheck('<C-Z>'))
        unmap <C-Z>
        " Technically <C-Z> still performs undo in Terminal during insert mode
    endif
endif

" C-/ -- Terminal: toggle whether line is commented  [Normal / Visual Mode]
"   (Only works in terminals where <C-/> is equivalent to <C-_>)
noremap <silent> <C-_> :Commentary<CR>

" & -- repeate last `:s` substitute (preserves flags)
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Y -- yank to end of line; see `:help Y`                     [Normal Mode]
nnoremap Y y$

" Enter key -- insert a new line above the current            [Normal Mode]
nnoremap <CR> O<Esc>j
" ...but not in the Command-line window (solution by Ingo Karkat [2])
autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
" ...nor in the Quickfix window
autocmd BufReadPost * if &buftype ==# 'quickfix' | nnoremap <buffer> <CR> <CR> | endif

" Ctrl-Tab -- Gvim: switch to next tab                        [Normal Mode]
nnoremap <silent> <C-Tab> :tabnext<CR>

" Ctrl-Shift-Tab -- Gvim: switch to previous tab              [Normal Mode]
nnoremap <silent> <C-S-Tab> :tabprev<CR>

" Q{motion} -- format specified lines                [Normal / Visual Mode]
noremap Q gq

" j -- move down one line on the screen              [Normal / Visual Mode]
nnoremap j gj
vnoremap j gj

" gj -- move down one line in the file               [Normal / Visual Mode]
nnoremap gj j
vnoremap gj j

" k -- move up one line on the screen                [Normal / Visual Mode]
nnoremap k gk
vnoremap k gk

" gk -- move up one line in the file                 [Normal / Visual Mode]
nnoremap gk k
vnoremap gk k

" > -- shift selection rightwards (preserve selection)        [Visual Mode]
vnoremap > >gv

" < -- shift selection leftwards (preserve selection)         [Visual Mode]
vnoremap < <gv

" Tab -- indent at beginning of line, otherwise autocomplete  [Insert Mode]
inoremap <silent> <Tab> <C-R>=DwiwITab()<cr>
inoremap <silent> <S-Tab> <C-N>

" Taken from Gary Bernhardt's vimrc [1]
function! DwiwITab()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction


augroup END

" ##### References #####
"
" [1] https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
" [2] http://stackoverflow.com/a/11983449/27581
" [3] https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
