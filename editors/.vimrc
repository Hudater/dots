"###############################Plugin(vimPlug)###################
"
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'ayu-theme/ayu-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sainnhe/gruvbox-material'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'mboughaba/i3config.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
colorscheme dracula

"#############################Settings##########################
set incsearch
set nobackup
set noswapfile
syntax enable
set nocompatible
set number
set relativenumber
set expandtab
set shiftwidth=2
set tabstop=2
set mouse=nicr

"Airline theme and colors
hi LineNr ctermfg=242
hi CursorLineNr ctermfg=15
hi VertSplit ctermfg=8 ctermbg=0
hi Statement ctermfg=3
set termguicolors
if exists('+termguicolors')
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
        set termguicolors
      endif
"let ayucolor="mirage"   " for dark version of theme
set background=dark
set t_Co=256
set t_ut=""

"Airline things
"let g:airline_theme='distinguished'
let g:airline_theme='fruit_punch'
"let g:airline_theme='minimalist'
"let g:airline_theme='tomorrow'
"let g:airline_theme='zenburn'
"let g:airline_theme='ayu_mirage'
"let g:airline_theme = 'gruvbox_material'
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


"Disable arrow keys in Normal mode
no <Up> <Nop>
no <Down> <Nop>
no <Left> <Nop>
no <Right> <Nop>

"Enabling .rasi syntax highlighting
au BufNewFile,BufRead /*.rasi setf css

"Different crosshair for different modes
let &t_SI = "\<esc>[5 q"  " blinking I-beam in insert mode
let &t_SR = "\<esc>[3 q"  " blinking underline in replace mode
let &t_EI = "\<esc>[1 q"  " default cursor (usually blinking block) otherwise

"i3 config syntax highlighting
aug i3config_ft_detection
  au!
  au BufNewFile,BufRead .config/i3/config set filetype=i3config
aug end
