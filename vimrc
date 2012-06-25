"""""""""""""""
"
" Config
"
"""""""""""""""

" Vi Improved
set nocompatible

" MapLeader
let mapleader=","

" Vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'kien/ctrlp.vim'
Bundle 'godlygeek/tabular'
Bundle 'msanders/snipmate.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'altercation/vim-colors-solarized'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-ragtag'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-bundler'
Bundle 'vim-scripts/taglist.vim'
Bundle 'vim-scripts/AutoTag'
Bundle 'tsaleh/vim-align'
Bundle 'tsaleh/vim-supertab'
Bundle 'kchmck/vim-coffee-script'
Bundle 'digitaltoad/vim-jade'
Bundle 'taq/vim-rspec'
Bundle 'sunaku/vim-ruby-minitest'
Bundle 'thomd/vim-jasmine'
Bundle 'pangloss/vim-javascript'
Bundle 'tomtom/tcomment_vim.git'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'Lokaltog/vim-powerline'

" Set shell
set shell=/bin/zsh

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Store temporary files in a central spot
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
if has("vms")
  set nobackup" do not keep a backup file, use versions instead
else
  set backup" keep a backup file
endif
" set nobackup
" set nowritebackup
set history=100
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" case only matters with mixed case expressions
set ignorecase
set smartcase

" Local config
if filereadable(".vimrc.local")
  source .vimrc.local
endif


"""""""""""""""
"
" Plugins specific config
"
"""""""""""""""

" Gist
if exists("g:gist_detect_filetype")
  let g:gist_detect_filetype = 1
endif
if exists("g:gist_open_browser_after_post")
  let g:gist_open_browser_after_post = 1
endif


" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Set File type to 'text' for files ending in .txt
  autocmd BufNewFile,BufRead *.txt setfiletype text

  " For Haml
  autocmd BufRead,BufNewFile *.haml setfiletype haml
  autocmd BufNewFile,BufRead *.slim setfiletype haml

  " Enable soft-wrapping for text files
  autocmd FileType text,markdown,eco,html,xhtml,eruby setlocal wrap linebreak nolist

  " Jbuilder an Rabl templates
  autocmd BufRead,BufNewFile *.jbuilder setfiletype ruby
  autocmd BufRead,BufNewFile *.rabl setfiletype ruby

  augroup mkd
    autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
    autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;
  augroup END

  " Enable ragtag for additional filetypes
  if exists("g:loaded_ragtag")
    autocmd FileType jst call RagtagInit()
    autocmd FileType eco call RagtagInit()
  endif

  " Coffeescript auto-compile - actually that might be annoying...
  " au BufWritePost *.coffee silent CoffeeMake!

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Automatically load .vimrc source when saved
  autocmd BufWritePost .vimrc source $MYVIMRC
  " autocmd BufWritePost ~/.dotfiles/vimrc source $MYVIMRC
  augroup END
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")



"""""""""""""""
"
" Rails Stuff
"
"""""""""""""""

map <Leader>m :Rmodel 
map <Leader>c :Rcontroller 
map <Leader>v :Rview 
map <Leader>u :Runittest 
map <Leader>f :Rfunctionaltest 
map <Leader>tm :RTmodel 
map <Leader>tc :RTcontroller 
map <Leader>tv :RTview 
map <Leader>tu :RTunittest 
map <Leader>tf :RTfunctionaltest 
map <Leader>sm :RSmodel 
map <Leader>sc :RScontroller 
map <Leader>sv :RSview 
map <Leader>su :RSunittest 
map <Leader>sf :RSfunctionaltest 

" Edit routes
command! Rroutes :e config/routes.rb
command! Rschema :e db/schema.rb
command! Rrestart :!touch tmp/restart.txt


"""""""""""""""
"
" Ruby Stuff
"
"""""""""""""""

" extract selected lines to 'before do' block
" vmap <Leader>bd "td?describe\\|context<cr>obefore do<cr><esc>ddk"tpjo<esc>
function! PromoteToBefore()
  let rv = @"
  let rt = getregtype('"')
  try
    :norm! gvd
    :exec '?^\s*describe\|context\>'
    :normal! obefore do
    :normal! gp
    :normal! koend
  finally
    call setreg('"', rv, rt)
  endtry
endfunction
:command! -range PromoteToBefore :call PromoteToBefore()
:vmap <Leader>bd :PromoteToBefore<cr>

" promote to let
" map  <Leader>let vt=clet(:pi)wi{ldlA }Vd?^\s*describe\|contextpV==q
function! PromoteToLet()
  let rv = @"
  let rt = getregtype('"')
  try
    :normal! dd
    :exec '?^\s*describe\|context\>'
    :normal! p
    :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
    :normal ==
  finally
    call setreg('"', rv, rt)
  endtry
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <Leader>let :PromoteToLet<cr>

" Edit the README_FOR_APP (makes :R commands work)
map <Leader>R :e doc/README_FOR_APP<CR>

" Switch between spec and source file
" Adapted from https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction

function! FindMatchingFileInFilesystem(file_name)
  let new_file      = a:file_name
  let new_file      = substitute(new_file, '^.*/', '', '')
  let possible_file = system("find . -name " . new_file)
  let new_file      = substitute(possible_file, '^.\/', '', '')
  return new_file
endfunction

function! RelatedSpecFile(current_file)
  let new_file = a:current_file
  let in_lib = match(new_file, '^lib/') != -1
  if in_lib
    let new_file = substitute(new_file, '^lib/', '', '')
  endif
  let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
  let new_file = 'spec/' . new_file
  if !filereadable(new_file)
    let new_file = FindMatchingFileInFilesystem(new_file)
  endif
  return new_file
endfunction

function! RelatedProductionFile(current_file)
  let new_file = a:current_file
  let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
  let new_file = substitute(new_file, '^spec/', 'lib/', '')
  if !filereadable(new_file)
    let new_file = FindMatchingFileInFilesystem(new_file)
  endif
  return new_file
endfunction

function! AlternateForCurrentFile()
  let current_file = expand("%")
  let in_spec = match(current_file, '^spec/') != -1
  if in_spec
    let new_file = RelatedProductionFile(current_file)
  else
    let new_file = RelatedSpecFile(current_file)
  endif
  return new_file
endfunction

nnoremap <leader>. :call OpenTestAlternate()<cr>

" Ctags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
nnoremap <silent> <C-I> :TlistToggle<CR>
let g:Tlist_Ctags_Cmd="/usr/bin/env ctags --extra=+f -R"
let g:Tlist_Use_Right_Window = 1
let g:Tlist_Enable_Fold_Column = 1
let g:Tlist_Exit_OnlyWindow = 1
let g:Tlist_Compact_Format = 1
" set tags=./tags;
" let g:tagbar_ctags_bin='/usr/local/bin/ctags'  " Proper Ctags locations
" let g:tagbar_width=26                          " Default is 40, seems too wide
" noremap <silent> <Leader>y :TagbarToggle       " Display panel with \\y (or ,y)




"""""""""""""""
"
" Movements
"
"""""""""""""""

" Switch between split buffers
set wmh=0
nmap <S-H> <C-W>h
nmap <S-J> <C-W>j
nmap <S-K> <C-W>k
nmap <S-L> <C-W>l

" Move lines up and down
vmap <S-J> :m +1 <CR>
vmap <S-K> :m -2 <CR>
vmap <S-J> :m +1 <CR>gv
vmap <S-K> :m -2 <CR>gv

" Move from function to function
map <C-J> ]m
map <C-K> [m

" Move by function / method
nmap m ]m
nmap <C-m> [m
nmap M ]M

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" Tab completion options
""" Only complete to the longest unambiguous match, and show a menu
set completeopt=longest,menuone
set wildmode=list:longest,list:full
set complete=.,t
""" Smart selection and movements
inoremap <expr> <C-n> pumvisible() ? '<C-n>'  : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <C-p> pumvisible() ? '<C-p>'  : '<C-p><C-r>=pumvisible() ? "\<lt>Up>"   : ""<CR>'


"""""""""""""""
"
" Shortcuts
"
"""""""""""""""

" Can't be bothered to understand the difference between ESC and <c-c> in
" insert mode
imap <c-c> <esc>

" Copy & paste with system clipboard
map <C-p> "*p
vmap <C-y> "*y

" Hide search highlighting
map <Leader>h :set invhls <CR>

" Tired of typos between :w/:W and :q/:Q
ab W w
ab WQ wq
ab Wq wq
ab WA wa
ab Wa wa
ab Q q
ab A a
ab QA qa
ab Qa qa
ab WqA wqa
ab WQa wqa
ab Wqa wqa

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Duplicate a selection
" Visual mode: D
vmap D y'>p

" Press Shift+P while in visual mode to replace the selection without
" overwriting the default register
vmap P p :call setreg('"', getreg('0')) <CR>

" No Help, please
nmap <F1> <Esc>

" Press ^F from insert mode to insert the current file name
imap <C-F> <C-R>=expand("%")<CR>

" Maps autocomplete to tab
imap <Tab> <C-N>
imap <S-Tab> <C-P>
imap <C-L> <Space>=><Space>

" Toggle NerdTree
ab NT NERDTreeToggle
nnoremap <silent> <C-U> :NERDTreeToggle<CR>



"""""""""""""""
"
" Aesthetics
"
"""""""""""""""

" Fancy powerline
let g:Powerline_symbols = 'fancy'

" Keep selection when indenting in visual mode
vmap > >gv
vmap < <gv

set winwidth=110
set winheight=50
" set winminheight=5

set previewheight=50
au BufEnter ?* call PreviewHeightWorkAround()
func! PreviewHeightWorkAround()
    if &previewwindow
        exec 'setlocal winheight='.&previewheight
    endif
endfunc

" Foldings
if has("folding")
  set foldenable
  set foldmethod=syntax
  set foldlevel=1
  set foldnestmax=2
  set foldtext=strpart(getline(v:foldstart),0,50).'\ ...\ '.substitute(getline(v:foldend),'^[\ #]*','','g').'\ '
endif

" Display extra whitespace
set list listchars=tab:»·,trail:·

" No wrap
set nowrap

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Always display the status line
set laststatus=2

" Put useful info in status line
set statusline=%<%f%=%{fugitive#statusline()}\ %{&ft}[%{Tlist_Get_Tagname_By_Line()}]\ [%l/%L]\ %m
hi User1 term=inverse,bold cterm=inverse,bold,underline ctermbg=white ctermfg=red
" Line Numbers
set numberwidth=5

function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunction

nnoremap <C-n> :call NumberToggle()<cr>
:au FocusLost * :set number
:au FocusGained * :set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

" Fullscreen on OSX
" <Leader>1 toggles full screen on and off
if has("gui_running")
  let g:fullScreened = 0
  set nofullscreen
  function ToggleFullScreen()
    if g:fullScreened == 0
      let g:fullScreened = 1
      set fullscreen
    else
      let g:fullScreened = 0
      set nofullscreen
    endif
  endfunction
  map <Leader>1 :call ToggleFullScreen()<CR>
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
  set hlsearch
  highlight Search term=underline cterm=underline gui=underline
endif

" Solarized colors
set background=dark
colorscheme solarized
call togglebg#map("<Leader>`")

if has("gui_running")
    " set font
    set nomacatsui anti enc=utf-8 gfn=Monaco:h12

    " set window size"
    set lines=100
    set columns=171

    " highlight current line"
    set cursorline
endif

" hide the toolbar in GUI mode
if has("gui_running")
  set go-=T
endif


" Use Ack instead of Grep when available
" if executable("ack")
  " set grepprg=ack\\ -H\\ --nogroup\\ --nocolor\\ --ignore-dir=tmp\\ --ignore-dir=coverage
" endif

" Open URL
command! -bar -nargs=1 OpenURL :!open <args>
function! OpenURL()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;:]*')
  echo s:uri
  if s:uri != ""
    exec "!open \"" . s:uri . "\""
  else
    echo "No URI found in line."
  endif
endfunction
