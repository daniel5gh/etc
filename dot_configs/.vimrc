syntax on
set background=dark
set hlsearch
set showmatch
set wildmenu
set showcmd
set ai

autocmd FileType python set tabstop=4 shiftwidth=4 expandtab softtabstop=4
autocmd FileType python let python_highlight_all = 1
autocmd FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python set omnifunc=pythoncomplete#Complete

set textwidth=180
au BufNewFile,BufRead * exec 'match SpellRare /\%>' . &textwidth . 'v.\+/'
au BufNewFile,BufRead * exec 'match PmenuSbar /\s\s*$/'
