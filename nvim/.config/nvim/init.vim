set number
set relativenumber
set nocompatible
let mapleader = ","
set tabstop=2
set shiftwidth=2
set expandtab


"Plug
call plug#begin('~/.local/share/nvim/plugged')

" Declare the list of plugins.
Plug 'ayu-theme/ayu-vim' " or other package manager
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dracula/vim', { 'as': 'dracula' }
"Plug 'ntk148v/vim-horizon'
"Plug 'mboughaba/i3config.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
"colorscheme dracula

"Colors and customizations
set termguicolors     " enable true colors support
set background=dark
let ayucolor="mirage"   " for dark version of theme
colorscheme ayu
"Airline themes
"let g:airline_theme='distinguished'
"let g:airline_theme='fruit_punch'
"let g:airline_theme='minimalist'
let g:airline_theme='tomorrow'
"let g:airline_theme='zenburn'
"let g:airline_theme='ayu_mirage'


"other Airline settings
let g:airline_powerline_fonts = 1
let g:Powerline_symbols = "fancy"
let g:Powerline_dividers_override = ["\Ue0b0","\Ue0b1","\Ue0b2","\Ue0b3"]
let g:Powerline_symbols_override = {'BRANCH': "\Ue0a0", 'LINE': "\Ue0a1", 'RO': "\Ue0a2"}
let g:airline_powerline_fonts = 1
let g:airline_right_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep= ''
let g:airline_left_sep = ''
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

"Enabling .rasi syntax highlighting
au BufNewFile,BufRead /*.rasi setf css

"Enabling global copy-pasta
vnoremap <C-c> "*y :let @+=@*<CR>
map <C-v> "+p

"i3config syntax highlighting
"aug i3config_ft_detection
 " au!
  "au BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
"aug end
