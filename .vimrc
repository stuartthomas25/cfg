let g:conda_startup_msg_suppress = 1
set number relativenumber
set nu rnu

set clipboard+=unnamed

" Basic stuff
let mapleader = ","

command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

try
set transparency=25
set blurradius=20
catch
endtry

set foldmethod=indent
set nofoldenable
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
set cursorline


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
endif

"Plugins
call plug#begin('~/.vim/plugged')
  "Plug 'vim-latex/vim-latex'
  Plug 'mg979/vim-visual-multi'
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
  "Plug 'terryma/vim-smooth-scroll'
call plug#end()

"if v:version >= 800
"    call plug#begin('~/.vim/plugged')
"
"      Plug 'mg979/vim-visual-multi'
"    call plug#end()
"endif

nnoremap <leader>n :NERDTreeToggleVCS<CR> 

let g:conda_startup_msg_suppress = 1

colorscheme gruvbox
set background=dark

" Some LaTeX config
"let g:Tex_CustomTemplateDirectory = '~/.vim/tex_templates/'
:inoremap <C-B> <Esc>yiWi\begin{<Esc>$a}<CR>\end{<Esc>pa}<Esc>ko
let g:tex_flavor='latex'
"let g:Tex_CompileRule_pdf='make'
set iskeyword+=:

if system('hostname -s')=="Nala\n"
    cd ~/Desktop
endif

set autochdir
function! InsertFigure(name,path)
    let l:images_path = 'imgs'
    if !isdirectory(l:images_path)
        echom system('mkdir '.l:images_path)
    endif


    if a:path==""
        " base64 form
        let tempname = tempname()
        echom system("pbpaste > ".l:tempname)
        "echom l:tempname
        echom system('magick convert inline:'.l:tempname.' '.l:images_path.'/'.a:name.'.png')
    else
        " path form
        echom system('magick convert '.a:path.' '.l:images_path.'/'.a:name.'.png')
    endif


    execute "normal! i\\begin{figure}[ht]\<Cr>\\centering\\includegraphics[width=0.5\\paperwidth]{".l:images_path."/".a:name."}\<Cr>\\caption{\\label{fig:".a:name."}}\<Cr>\\end{figure}\<Esc>v<kf{l"
    startinsert
endfunction

function! ReplaceFigure(name,path)
    let l:images_path = 'imgs'

    if a:path==""
        " base64 form
        let tempname = tempname()
        echom system("pbpaste > ".l:tempname)
        "echom l:tempname
        echom system('magick convert inline:'.l:tempname.' '.l:images_path.'/'.a:name.'.png')
    else
        " path form
        echom system('magick convert '.a:path.' '.l:images_path.'/'.a:name.'.png')
    endif
endfunction

function! NewTexFile(name)
    let l:esc_name = a:name.'.latex'
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
    echom system('package '.l:esc_name)
    echom system('mkdir '.l:esc_name.'/imgs')
    echom system('cp ~/.vim/latex_makefile '.l:esc_name.'/Makefile')
    echom system('cp ~/.vim/tex_templates/article.tex '.l:esc_name.'/main.tex')
    execute "e ".l:esc_name."/main.tex"
    
endfunction

set makeprg=make

command! -nargs=* Fig call InsertFigure(<f-args>)
command! -nargs=1 Fig call InsertFigure(<f-args>,"")

command! -nargs=* ReplaceFig call ReplaceFigure(<f-args>)
command! -nargs=1 ReplaceFig call ReplaceFigure(<f-args>,"")

command! -nargs=1 Texn call NewTexFile(<f-args>)
command! -nargs=0 Open echom system("open main.pdf")

set autowrite

set tw=0

nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l


nnoremap <CR> o<Esc>
nnoremap <S-CR> O<Esc>j
inoremap <S-Tab> <C-V><Tab>


if has("autocmd")
    "autocmd FileType netrw edit main.tex
    autocmd FileType tex set spell 
endif
