" MapLeader
let mapleader=","

" Tired of typos between w/W and q/Q 
command WQ wq
command Wq wq
command W w
command Q q

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

" pathogen bundles
filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

" Set shell
set shell=/bin/zsh

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

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

" Don't use Ex mode, use Q for formatting
map Q gq

" Relative line numbers
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


" Gist
if exists("g:gist_detect_filetype")
  let g:gist_detect_filetype = 1
endif
if exists("g:gist_open_browser_after_post")
  let g:gist_open_browser_after_post = 1
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
  set hlsearch
endif

" Solarized colors plugin configuration
" Toggle change of background with Conrol + Backtick (tilde key on Mac Book Pro 13 inch keyboard
if has('gui_running')
  colorscheme solarized
  set background=dark
  call togglebg#map("<Leader>`")
endif

if has("gui_running")
    " GRB: set font"
    "   "set nomacatsui anti enc=utf-8 gfn=Monaco:h12
    
    " GRB: set window size"
      set lines=100
      set columns=171

    " GRB: highlight current line"
      set cursorline
endif

" GRB: hide the toolbar in GUI mode
if has("gui_running")
  set go-=T
endif

" Switch wrap off for everything
" set nowrap

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Set File type to 'text' for files ending in .txt
  autocmd BufNewFile,BufRead *.txt setfiletype text

  " Enable soft-wrapping for text files
  autocmd FileType text,markdown,html,xhtml,eruby setlocal wrap linebreak nolist

  augroup mkd
    autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
    autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;
  augroup END

  " Enable ragtag for additional filetypes
  if exists("g:loaded_ragtag")
    autocmd FileType jst call RagtagInit()
  endif

  " Coffeescript auto-compile
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

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

if has("folding")
  set foldenable
  set foldmethod=syntax
  set foldlevel=1
  set foldnestmax=2
  set foldtext=strpart(getline(v:foldstart),0,50).'\ ...\ '.substitute(getline(v:foldend),'^[\ #]*','','g').'\ '
endif

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Always display the status line
set laststatus=2

" GRB: Put useful info in status line
" set statusline=%<%f\\\\\\\\\\\\\\\\ (%{&ft})\\\\\\\\\\\\\\\\ %-4(%m%)%=%-19(%3l,%02c%03V%)
hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" Can't be bothered to understand the difference between ESC and <c-c> in
" insert mode
imap <c-c> <esc>


" Edit the README_FOR_APP (makes :R commands work)
map <Leader>R :e doc/README_FOR_APP<CR>






"
" Rails Stuff
"
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


"
" Ruby Stuff
"

" extract selected lines to before block
vmap <Leader>bed "td?describe<cr>obefore(:each) do<cr><esc>ddk"tpjo<esc>

"
" Movements
"

" Switch between split buffers
set wmh=0
map <S-H> <C-W>h
map <S-J> <C-W>j
map <S-K> <C-W>k
map <S-L> <C-W>l

" Move lines up and down
map <C-J> :m +1 <CR>
map <C-K> :m -2 <CR>

" Alias window controls
cmap <Leader>w <C-w>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

"
" Completion
"

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=longest,menu
set wildmode=list:longest,list:full
set complete=.,t




" Hide search highlighting
map <Leader>h :set invhls <CR>

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

" For Haml
au! BufRead,BufNewFile *.haml         setfiletype haml

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

" Keep selection when indenting in visual mode
vmap > >gv
vmap < <gv


" Set minimum pane height to 5 lines
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999

" Display extra whitespace
set list listchars=tab:»·,trail:·

" Local config
if filereadable(".vimrc.local")
  source .vimrc.local
endif

" Use Ack instead of Grep when available
" if executable("ack")
  " set grepprg=ack\\ -H\\ --nogroup\\ --nocolor\\ --ignore-dir=tmp\\ --ignore-dir=coverage
" endif

" Numbers
set number
set numberwidth=5


" case only matters with mixed case expressions
set ignorecase
set smartcase

" Tags
let g:Tlist_Ctags_Cmd="/usr/local/bin/ctags --exclude='*.js'"
set tags=./tags;
" let g:tagbar_ctags_bin='/usr/local/bin/ctags'  " Proper Ctags locations
" let g:tagbar_width=26                          " Default is 40, seems too wide
" noremap <silent> <Leader>y :TagbarToggle       " Display panel with \\y (or ,y)

let g:fuf_splitPathMatching=1

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
map <Leader>w :call OpenURL()<CR>

