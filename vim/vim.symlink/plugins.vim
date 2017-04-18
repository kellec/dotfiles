filetype off

call plug#begin('~/.vim/plugged')

" General
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] } | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'bling/vim-airline'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'nathanaelkane/vim-indent-guides'

" Autocomplete
Plug 'ervandew/supertab'

" Colorschemes
Plug 'chriskempson/base16-vim'

" Language-specific plugins
" Plug 'mattn/emmet-vim', { 'for': 'html' }
" Plug 'gregsexton/MatchTag', { 'for': 'html' }
" Plug 'othree/html5.vim', { 'for': 'html' }
" Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
" Plug 'moll/vim-node', { 'for': 'javascript' }
" Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
" Plug 'mxw/vim-jsx', { 'for': 'jsx' }
" Plug 'elzr/vim-json', { 'for': 'json' }
" Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
" Plug 'ap/vim-css-color', { 'for': 'css' }
" Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
" Plug 'itspriddle/vim-marked', { 'for': 'markdown', 'on': 'MarkedOpen' }
" Plug 'tpope/vim-markdown', { 'for': 'markdown' }

" JavaScript syntax highlighting
Plug 'othree/yajs.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/es.next.syntax.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'javascript.jsx'] }

" JavaScript tools integration
Plug 'flowtype/vim-flow', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'scrooloose/syntastic'

call plug#end()
" filetype plugin indent on
