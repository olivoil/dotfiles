"""""""""""""""
"
" Config
"
"""""""""""""""

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" MapLeader
let mapleader=","

" pathogen bundles
filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

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

" FuzzyFinder
let g:fuf_splitPathMatching=1
" mnemonic 'g' for 'go to'
ab G FufFile
map <Leader>g :FufFile<cr>

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


"""""""""""""""
"
" Ruby Stuff
"
"""""""""""""""

" extract selected lines to before block
vmap <Leader>bed "td?describe<cr>obefore(:each) do<cr><esc>ddk"tpjo<esc>

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

" Tags
let g:Tlist_Ctags_Cmd="/usr/local/bin/ctags --exclude='*.js'"
set tags=./tags;
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
map <S-H> <C-W>h
map <S-J> <C-W>j
map <S-K> <C-W>k
map <S-L> <C-W>l

" Move lines up and down
nmap <C-J> :m +1 <CR>
nmap <C-K> :m -2 <CR>

" Alias window controls
cmap <Leader>w <C-w>

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


"""""""""""""""
"
" Aesthetics
"
"""""""""""""""

" Keep selection when indenting in visual mode
vmap > >gv
vmap < <gv

" Set minimum pane height to 5 lines
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999

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

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Always display the status line
set laststatus=2

" GRB: Put useful info in status line
" set statusline=%<%f\\\\\\\\\\\\\\\\ (%{&ft})\\\\\\\\\\\\\\\\ %-4(%m%)%=%-19(%3l,%02c%03V%)
hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red
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
endif

" Solarized colors plugin configuration
" Toggle change of background with Conrol + Backtick (tilde key on Mac Book Pro 13 inch keyboard
if has('gui_running')
  colorscheme solarized
  set background=dark
  call togglebg#map("<Leader>`")
endif

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
map <Leader>w :call OpenURL()<CR>
