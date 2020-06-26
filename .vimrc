let g:conda_startup_msg_suppress = 1
set number

" Basic stuff
let mapleader = ","

command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

try
set transparency=25
set blurradius=20
catch
endtry

set foldmethod=indent
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set lazyredraw
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif
syntax enable
set wildmenu
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
map <silent> <leader><cr> :noh<cr>
set display=lastline
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
map <leader>e :vsplit $MYVIMRC<CR>
map <leader>s :so $MYVIMRC<CR>
set shortmess=I


" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
    autocmd FileType python map <buffer> <leader>r :w<CR>:exec '!python' shellescape(@%, 1)<CR>
    autocmd FileType tex map <buffer> <leader>r :w<CR><leader>ll
endif

"Plugins
call plug#begin('~/.vim/plugged')
  Plug 'cjrh/vim-conda'
  Plug 'vim-latex/vim-latex'
  Plug 'terryma/vim-multiple-cursors'
  "Plug 'davidhalter/jedi-vim'
  "Plug 'zchee/deoplete-jedi'
  Plug 'scrooloose/nerdcommenter'
  Plug 'morhetz/gruvbox'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-scripts/mru.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'junegunn/goyo.vim'
  Plug 'preservim/nerdtree'
call plug#end()

nnoremap <leader>n :NERDTreeToggleVCS<CR> 

let g:conda_startup_msg_suppress = 1

colorscheme gruvbox
set background=dark

" Some LaTeX config
let g:Tex_CustomTemplateDirectory = '~/.vim/tex_templates/'
:inoremap <D-B> <Esc>yiWi\begin{<Esc>$a}<CR>\end{<Esc>pa}<Esc>ko
let g:tex_flavor='latex'
" let g:Tex_CompileRule_pdf='latexmk -pdf; latex -c'
set iskeyword+=:

cd ~/Desktop
set autochdir
function! InsertFigure(name,path)
    let l:images_path = 'imgs'
    if !isdirectory(l:images_path)
        echom system('mkdir '.l:images_path)
    endif
    echom system('magick convert '.a:path.' '.l:images_path.'/'.a:name.'.png')
    execute "normal! i\\begin{figure}[ht]\<Cr>\\centering\\includegraphics[width=0.5\\paperwidth]{".l:images_path."/".a:name."}\<Cr>\\caption{\\label{fig:".a:name."}}\<Cr>\\end{figure}\<Esc>v<kf{l"
    startinsert
endfunction

function! NewTexFile(name)
    let l:esc_name = a:name
    if isdirectory(a:name)
        if toupper(input("Overwrite? (Y/N)")) == "Y"
            echom "Deleting folder..."
            echom system('rm -r '.l:esc_name)
        else 
            redraw
            return 0
        endif
    endif
    echom system('mkdir '.l:esc_name)
    echom system('mkdir '.l:esc_name.'/imgs')
    execute "e ".l:esc_name."/main.tex"
    TTemplate
endfunction

command! -nargs=* Fig call InsertFigure(<f-args>)
command! -nargs=1 Texn call NewTexFile(<f-args>)

" autocmd FileType tex map <buffer> <leader>r :w<CR>:exec '!latexmk -pdf | !latexmk -c'
map <buffer> <leader>R :wa<CR>:exec '!python' g:exec_file<CR>
map <buffer> <leader>sR :let g:exec_file=expand('%:p')<CR>

set tw=0

nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
