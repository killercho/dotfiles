call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Chiel92/vim-autoformat'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mhartington/oceanic-next'
Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdcommenter'
Plug 'neovimhaskell/haskell-vim'
Plug 'dense-analysis/ale'
call plug#end()

set encoding=utf-8

execute pathogen#infect()

set statusline+=%#warningmsg#
set statusline+=%*

set tabstop=4
set shiftwidth=4
set expandtab
set background=dark

set ttymouse=sgr
set mouse=a

set splitbelow
set splitright

"folds a function, default bind is z->a
set foldmethod=indent
set foldlevel=99

set number

"airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '>'

"ale settings
let g:ale_fix_on_save = 1

"haskell settings
syntax on
filetype plugin indent on
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
let g:haskell_indent_before_where = 1     " indent before a where clause
let g:haskell_indent_guard = 1            " indent before a guard clause (|)

colorscheme OceanicNext

au BufWrite * :Autoformat

"Move trough visual lines
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk

"Yanks from cursor to the end of the line
nnoremap Y y$

"Paste in different modes
inoremap <C-p> <Esc>pa<CR>
cnoremap <C-p> <C-r>"<CR>
nnoremap <C-p> "+p<CR>

"NERDTree bindings
nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

"Save/Exit bindings
nnoremap <C-w> :w<CR>
nnoremap <C-q> :wq<CR>

"Tab bindings
nnoremap <C-l> gt<CR>
nnoremap <C-h> gT<CR>
nnoremap <C-n> :tabnew<CR>

"Moving text around bindings
nnoremap <C-j> :m +1<CR>
nnoremap <C-k> :m -2<CR>

"<leader> is actually \
"normal nerd commenter commands are done using the leader key
nnoremap <C-c> :call nerdcommenter#Comment(0, 'toggle')<CR>
xnoremap <C-c> :call nerdcommenter#Comment(0, 'toggle')<CR>
