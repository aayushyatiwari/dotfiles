set nocompatible
filetype plugin indent on
syntax on

set number
set relativenumber
set cursorline
set scrolloff=8
set signcolumn=yes

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

set ignorecase
set smartcase
set incsearch
set hlsearch

set noswapfile
set nobackup
set undofile
set undodir=~/.vim/undodir

set splitright
set splitbelow
set hidden

set backspace=indent,eol,start
set clipboard=unnamedplus

set wildmenu
set wildmode=longest:full,full

let mapleader = " "

nnoremap <leader>e :Ex<CR>
nnoremap <leader>/ :nohlsearch<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>ss :split<CR>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap n nzzzv
nnoremap N Nzzzv

inoremap jk <Esc>
