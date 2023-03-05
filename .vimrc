call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Chiel92/vim-autoformat'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mhartington/oceanic-next'
Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdcommenter'
Plug 'neovimhaskell/haskell-vim'
Plug 'OmniSharp/omnisharp-vim'
call plug#end()

set encoding=utf-8

execute pathogen#infect()

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

set tabstop=4
set shiftwidth=4
set expandtab
set background=dark

set ttymouse=sgr
set mouse=a

"syntastic settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_haskell_hlint_quiet_messages = { "level" : "warnings" }
let g:syntastic_python_pylint_quiet_messages = { "level" : ["warnings", "errors"] }

set number

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

"omnisharp variables
let g:OmniSharp_server_use_mono = 1

colorscheme OceanicNext

au BufWrite * :Autoformat

nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-w> :w<CR>
nnoremap <C-q> :wq<CR>
nnoremap <C-l> :tabn<CR>

"<leader> is actually \
"normal nerd commenter commands are done using the leader key
nnoremap <C-k> :call nerdcommenter#Comment(0, 'toggle')<CR>
vnoremap <C-k> :call nerdcommenter#Comment(0, 'toggle')<CR>
