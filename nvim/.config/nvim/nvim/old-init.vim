set encoding=utf-8
set number relativenumber
set noswapfile
set noerrorbells
set smartcase
set signcolumn=yes
set incsearch
set scrolloff=7
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set expandtab
set backspace=indent,eol,start
syntax enable

call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

colorscheme gruvbox

let mapleader = ' '

" NerdTree
let NERDTreeQuitOnOpen=1
let g:NERDTreeMinimalUI=1

" Tabs
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#fnamemode=':t'
nmap <leader>1 :bp<CR>
nmap <leader>2 :bn<CR>
nmap <C-w> :bd<CR>

let g:python_highlight_all=1
