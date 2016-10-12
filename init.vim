" Global config
syntax on
filetype plugin indent on
set nocompatible
set number
set wrap linebreak nolist
set formatoptions=l
set showmode
set tw=80
set smartcase
set smarttab
set smartindent
set autoindent
set softtabstop=2
set shiftwidth=2
set expandtab
set incsearch
set mouse=a
set history=1000
set notimeout
set cursorline
set cursorcolumn
" set clipboard=unnamedplus,autoselect
set clipboard+=unnamedplus

set completeopt=menuone,menu,longest

set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox,result
set wildmode=longest,list,full
set wildmenu
set completeopt+=longest

set t_Co=256
set cmdheight=1
set shell=/bin/sh

let &t_SI = "\<Esc>]12;orange\x7"

" vim-plug
call plug#begin('~/.vim/plugged')
Plug 'LnL7/vim-nix'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/neopairs.vim'
Plug 'Shougo/vimproc.vim'
Plug 'benekastah/neomake'
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'
Plug 'eagletmt/neco-ghc'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'mhinz/vim-startify'
Plug 'nbouscal/vim-stylish-haskell'
Plug 'neovimhaskell/haskell-vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'whatyouhide/vim-gotham'
Plug 'terryma/vim-expand-region'
Plug 'zeekay/vice-complete'
Plug 'kchmck/vim-coffee-script'
call plug#end()

colorscheme gotham

" Use deoplete.
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : deoplete#mappings#manual_complete()

let g:deoplete#enable_smart_case = 1
" Disable haskell-vim omnifunc
let g:deoplete#enable_at_startup = 1
let g:haskellmode_completion_ghc = 0
let g:lightline = { 'colorscheme': 'gotham' }

let g:necoghc_enable_detailed_browse = 1

autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
autocmd! BufWritePost * Neomake

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

map <silent> tw :GhcModTypeInsert!<CR>
map <silent> ts :GhcModSplitFunCase!<CR>
map <silent> tq :GhcModType!<CR>
map <silent> te :GhcModTypeClear<CR>

nmap <F8> :TagbarToggle<CR>

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>


" Fuzzy open
nnoremap <C-e> :Unite -start-insert -buffer-name=File_List file<CR>

let g:neomake_warning_sign = {
  \ 'text': 'W',
  \ 'texthl': 'WarningMsg',
  \ }

let g:neomake_error_sign = {
  \ 'text': 'E',
  \ 'texthl': 'ErrorMsg',
  \ }


let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
    \ }

" Clipboard
function! ClipboardYank()
  call system('xclip -i -selection clipboard', @@)
endfunction
function! ClipboardPaste()
  let @@ = system('xclip -o -selection clipboard')
endfunction

vnoremap <silent> y y:call ClipboardYank()<cr>
vnoremap <silent> d d:call ClipboardYank()<cr>
nnoremap <silent> p :call ClipboardPaste()<cr>

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

hi MatchParen cterm=none ctermbg=darkblue ctermfg=white



