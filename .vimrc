" _____________________________________________________________________ Approach

"   This .vimrc tries to be a minimal config and close to the default. It aims 
"   to embrace general Vim practices. Be reasonable. Stay vanilla. Stick to the 
"   defaults. Always try to find a way without additional dependencies.
"   Take the time to learn the basics. There is always a way. 
"   Consult notes...    Vim_*.txt

" ______________________________________________________________________ General

" Reload this config:           :source $MYVIMRC

syntax on                       " Enable syntax highlighting
let mapleader = ","             " Set leader key

set nocompatible                " Disable Vi compatibility
set hidden                      " Allow buffer switching without saving

set encoding=utf-8              " Set default encoding

set number                    " Show line numbers
" set relativenumber            " Relative line numbers


" __________________________________________________________________ Status line 

set laststatus=0
" 0 ... Never show statusline
" 1 ... Show only with more than one window
" 2 ... Always show statusline

" Set the default statusline
set statusline=

" Colors for statusline
highlight StatusLine ctermfg=Black ctermbg=Grey


" ___________________________________________________________________ Formatting

set tabstop=4           " Number of spaces that a <Tab> counts for
set shiftwidth=4        " Number of spaces to use for each step of (auto)indent
set expandtab           " Convert tabs to spaces
set nowrap              " Explicitly no line wrap
set nolinebreak         " Twice the charm


" _____________________________________________________________ System clipboard

" Copy (yank) to system clipboard. Needs confirmation to go through.
vnoremap <silent> <leader>y :w !wl-copy<CR>

" Paste from system clipboard. Will paste without prompt for confirmation.
nnoremap <silent> <leader>p :r !wl-paste<CR>


" ______________________________________________________________________ Tabline 

" Always hide tab bar
set showtabline=0

" The remaining of the tabline where there is no labels (background).
:highlight TabLineFill  ctermfg=black       ctermbg=black

" Labels which are not currently active.
:highlight TabLine      ctermfg=darkgrey    ctermbg=black   cterm=none

" Current active tab label
:highlight TabLineSel   ctermfg=lightgrey   ctermbg=black   cterm=bold

" Affects the output of ':tabs'
:highlight Title        ctermfg=red         ctermbg=black   cterm=bold


" ___________________________________________________________ Vertical separator

" Affects Vim windows, panes, and splits

" Set the vertical separator to a Unicode bar
set fillchars+=vert:\│
highlight VertSplit cterm=none ctermbg=none
highlight NonText ctermfg=darkgrey


" _________________________________________________________________ Color column

" Linebreak indicator (as visual border)

" Show color column when Vim opens.
" set colorcolumn=81 

highlight ColorColumn ctermbg=darkgrey

" Toggle linebreak indicator
nnoremap <Leader>cc :call ToggleColorColumn()<CR>

" 80 characters per line. Separator at 81.
function! ToggleColorColumn()
  if &colorcolumn == '81'
    set colorcolumn=
  else
    set colorcolumn=81
  endif
endfunction


" _______________________________________________________________________ Search

set hlsearch                    " Highlight all matches of last search
highlight Search ctermfg=black ctermbg=grey
set ignorecase
set smartcase                   " Case-insensitive unless uppercase is used

nnoremap n nzt
nnoremap N Nzt

" Write current line to active search register to jump between section headers
nnoremap _ :let @/ = '^' . escape(getline('.'), '\/.*$^~[]') . '$'<CR>
"
"   :let            ... Setting variable
"   @/              ... Search register variable
"   <CR>            ... Simulate 'Enter' press and thus execute :command
"
"   .               ... Dot operator is for string concatenation in Vimscript
"                       
"                           '^' . escape(<string>, <target>) . '$'
"
"                       Three parts are concatenated.
"
"                           1.  Start of line (^)
"                           2.  Everything in between     
"                           3.  End of line ($)
"
"                       The line needs processing before being written to the 
"                       search register.
"                       
"                           Whatever string is added, it will be interpreted by
"                           the / search function as such.
"                           
"                               To avoid feeding regex characters, they are
"                               escaped with this escape() function.
"                           
"   escape()        ... Function that escapes <target> characters within a
"                       <string> by adding a '\' prefix.
"                           
"   getline('.')    ... Returns the current line under the cursor.
"                           
"   \/.*$^~[]       ... Selection of special characters that'll be escaped.
"
"                       [!] This is not a complete list, but apparently a 
"                           sensible selection of characters to avoid unwanted 
"                           regex interpretation in the Vim search function.


" _______________________________________________________________________ Cursor

let &t_SI = "\e[6 q"   " Insert mode  ... Bar cursor
let &t_EI = "\e[2 q"   " Normal mode  ... Block cursor

" This might not work for tmux out of the box. That's because tmux does not 
" forward cursor shape sequences by default.


" ___________________________________________________________________ Navigation

" Disable standard (non-Vim) navigation to force myself to use Vim motions.

" Disable mouse support
set mouse=

" Disable arrow key navigation in normal mode
nnoremap <Up>    <Nop>
nnoremap <Down>  <Nop>
nnoremap <Left>  <Nop>
nnoremap <Right> <Nop>

" Disable arrow key navigation in insert mode
inoremap <Up>    <Nop>
inoremap <Down>  <Nop>
inoremap <Left>  <Nop>
inoremap <Right> <Nop>


" _______________________________________________________________________ Vundle
"

filetype off                    " Required before vundle#begin

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'   " Let Vundle manage Vundle, required

" PLUGINS 
Plugin 'sheerun/vim-polyglot'   " Language pack
Plugin 'junegunn/fzf'           " Fuzzy finder dependency
Plugin 'junegunn/fzf.vim'       " Fuzzy finder features

" Add Plugins before the following line
call vundle#end()               " Required
filetype plugin indent on       " Required


" __________________________________________________________________________ fzf

" Search file names in current directory 
nnoremap <silent> <leader>f :Files<CR>

" Search file names amongst open buffers
nnoremap <silent> <leader>b :Buffers<CR>

" Search within all loaded buffers
nnoremap <silent> <leader>l :Lines<CR>

" Search within files (via 'ripgrep' - hence 'rg' keybind)
nnoremap <silent> <leader>rg :Rg<Space>

" Disable preview window completely
let g:fzf_preview_window = ''

" Only use terminal UI
let g:fzf_layout = { 'down': '~40%' }

" Include a preview window
" let g:fzf_preview_window = ['right:60%']

" Toggle FZF preview window
nnoremap <Leader>g :call TogglePreviewWindow()<CR>

function! TogglePreviewWindow()
  if exists('g:fzf_preview_window') && !empty(g:fzf_preview_window)
    let g:fzf_preview_window = ''
    echo "FZF preview window: OFF"
  else
    let g:fzf_preview_window = ['right:60%']
    echo "FZF preview window: ON"
  endif
endfunction


" ___________________________________________________________________ Automation

" Insert today’s date below the cursor (in Insert mode).
inoremap <C-d> <C-r>=strftime('%Y-%m-%d %H:%M')<CR>
"
"              <C-r>=                           ... Insert contents of a 
"                                                   register (in Insert mode).
"
"                              %Y-%m-%d %H:%M   ... 2026-04-12 15:40
