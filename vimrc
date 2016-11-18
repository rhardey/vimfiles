" Initialise variables for later use in vimrc ---------------------- {{{

" If this is a Windows environment that doesn't use a POSIX shell,
" set to vimfiles else set .vim
let win_shell = (has('win32') || has('win64')) && &shellcmdflag =~ '/'
let vimDir = win_shell ? $HOME.'/vimfiles' : $HOME.'/.vim'

" }}}

" Basic settings ---------------------- {{{
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set nobackup    " Do not keep a backup file (i.e. no ~ files scattered around, OK if you use version control).
"set backup     " Keep a backup file.

set showcmd     " display incomplete commands


" When on, Vim will change the current working directory whenever you open a
" file, switch buffers, delete a buffer or open/close a window.
"set autochdir
" autochdir was causing some weird behaviour with relative paths being passed
" via the command line.  The alternative below does what I need without the
" weirdness (see
" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file).
autocmd BufEnter * silent! lcd %:p:h

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax on
endif

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

set encoding=utf-8
set nowrapscan autoindent

" When off a buffer is unloaded when it is abandoned.  When on a
" buffer becomes hidden when it is abandoned.
set hidden

" removes option where a :read command with a file name arg will set the
" alternate file name for the current window.
set cpoptions-=a

set cindent
set cinoptions+=:0,(s
"set comments=sr:/*,mb:*,el:*/,://

" Had enough of tabs
set expandtab
set shiftwidth=4
set tabstop=4

" show matching parenthesis etc
set showmatch

" REVISIT
set formatoptions=croql

set printoptions+=number:y

" Clobbered by statusline settings, by the looks.
"set ruler

set history=2048

set viminfo='20,\"50

" Search settings.
set hlsearch
set incsearch

set nrformats=alpha,hex

" Show the line number relative to the line with the cursor in front of each line.
if !&diff
  set relativenumber
endif

" Set auto completion to work similar to my Bash setup.
set wildmode=longest,list

" Virtual editing means that the cursor can be positioned where there is no
" actual character.
set virtualedit=block

" Turn off that #@$%* beeping!!
set visualbell

set foldlevelstart=0 " Starts with all folds closed, where folding enabled.

" If folding is enabled in a filetype's syntax file, enable it by default.
"set foldmethod=syntax

" Turn syntax folding on for these filetypes.
"let g:xml_syntax_folding = 1
"let perl_fold = 1

" I wanna use matchit!
source $VIMRUNTIME/macros/matchit.vim

" }}}

" Persistent undo ---------------------- {{{

let vimUndoDir = vimDir."/undo"

" Let's save undo info!
if !isdirectory(vimUndoDir)
    call mkdir(vimUndoDir, "", 0700)
endif
let &undodir=vimUndoDir
set undofile

" }}}

" Mappings ---------------------- {{{

" Explicitly set the leader mappings, so I know what they are.  Should be done
" before plugins are activated.
let mapleader="\\"
" Let's keep local and global leader settings separate.
let maplocalleader=";" " REVISIT - Is there a better key?

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" There is a problem when in a sql buffer getting omni completion to work, there appears to be a mapping overriding
" <C-X><C-O>.  Until I track down what is going on here's an alternative mapping:
inoremap <C-K> <C-X><C-O>

" Make it easy to edit the .vimrc file.
nnoremap <localleader>ev :split $MYVIMRC<cr>
nnoremap <localleader>sv :source $MYVIMRC<cr>

" Make it easy to edit the TNSNAMES.ORA file.
nnoremap <localleader>ot :e $TNS_ADMIN/tnsnames.ora<cr>

" Want a quick way to close
nnoremap <localleader>c <C-W>c

" Want a quick way to close all windows except the current one.
nnoremap <localleader>o :only<cr>

" Turn off highlighting for the last search.
nnoremap <localleader>h :nohlsearch<cr>

" Remove extraneous space at the end of lines
nnoremap <localleader>ds :%s/\s\+$//g<cr>

" Go to the next item in the quickfix list quickly
nnoremap <localleader>n :cn<cr>

" }}}

" Abbreviations ---------------------- {{{
iabbrev @@ ryan.hardey@gov.bc.ca
iabbrev rjh Ryan Hardey
" }}}

" Status line ---------------------- {{{
" Based on standard status, see :help statusline.
set statusline=%f " Relative path
set statusline+=\ %m%r " modified and read-only flags
set statusline+=%y " File type
set statusline+=[%{&ff}] " File format
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''} " Fugitive status
set statusline+=[char=%b]
set statusline+=%=%-14.(%l,%c%V%) " Line number, column and virtual column
set statusline+=\ %14L " Lines in buffer
set statusline+=\ %P " Percentage through file of displayed window.

set laststatus=2 " Always display status line.
" }}}

" Diff setup ---------------------- {{{

set diffexpr=

set diffopt+=vertical
set diffopt+=iwhite
set diffopt+=icase

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
" }}}

" Vim configuration augroup ---------------------- {{{
" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " Expand tabs to 2 spaces, and set folding method to 'marker'
  autocmd FileType vim setlocal shiftwidth=2 tabstop=2 foldmethod=marker

  " Expand tabs to 2 spaces.
  autocmd FileType python setlocal shiftwidth=2 tabstop=2

  " Expand tabs to 2 spaces.
  autocmd FileType ruby setlocal shiftwidth=2 tabstop=2

  autocmd FileType php
        \ let php_minlines = 2000 " variables for php syntax highlighting

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

augroup END
" }}}

" Plugins ---------------------- {{{
"
" Builtin netrw plugin configuration ---------------------- {{{
if has('win32') " Configure PuTTY for use with netrw.
  let g:netrw_silent = 1
  let g:netrw_scp_cmd="pscp -q -agent -batch"
  let g:netrw_list_cmd = "plink -agent USEPORT HOSTNAME \"ls -Fa\" "
  let g:netrw_ssh_cmd  = "plink -agent"
  let g:netrw_sftp_cmd = "psftp -agent"
endif
" }}}

" Settings required prior to Pathogen getting going {{{
"let g:ycm_semantic_triggers = { 'mytest' : ['.'] }
"let g:ycm_server_use_vim_stdout = 1
" }}}

" Pathogen plugin management ---------------------- {{{
" To disable a plugin, add it's bundle name to the following list
"let g:pathogen_disabled = ['ycm', 'tagbar', 'easytags', 'AutoTag']
"runtime bundle/pathogen/autoload/pathogen.vim
"call pathogen#infect()
"call pathogen#helptags()
" }}}

" vim-plug plugin management ---------------------- {{{
call plug#begin(vimDir.'/plugs')

Plug 'https://github.com/talek/vorax4.git', { 'on': 'VORAXConnect' }
Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/Shougo/neocomplete.vim.git'
Plug 'https://github.com/fatih/vim-go.git', { 'tag': '*', 'for': 'go' }
Plug 'https://github.com/majutsushi/tagbar.git'
Plug 'https://github.com/craigemery/vim-autotag.git'

call plug#end()
" }}}

" Vorax setup ---------------------- {{{

"if &diff
  " setup for diff mode
  " Vorax folding interferes with fugitive Gdiff, so turning off until
  " resolved.
  let g:vorax_folding_enable = 0
"endif

let g:vorax_homedir = '\Users\hardeyry\.vorax'
let g:vorax_debug = 1
let g:vorax_debug_level = 'ALL'
let g:vorax_output_window_clear_before_exec = 0
let g:vorax_output_window_append = 1

" Default to TABLEZIP
let g:vorax_output_window_default_funnel = 3

let g:vorax_throbber = ['|', '/', '-', '\']
" NOTE: Vorax sets any values not set here.
let g:vorax_plsql_associations = {'PACKAGE_BODY': 'pkb',
                               \  'PACKAGE_SPEC': 'pks',
                               \  'PACKAGE': 'pls'
                               \}

augroup VoraX
  au!

  " Cleanup SQL copied and pasted from a sqlplus buffer.
  autocmd FileType sql nnoremap <localleader>r  :'<,'>s/^\d\d:\d\d:\d\d\s\+\%(\w\+@\w\+>\s\\|\d\+\s\s\)\=//<cr>

augroup END
" }}}

" CtrlP ---------------------- {{{
"
let g:ctrlp_working_path_mode = 'rc' " Use the CWD.
let g:ctrlp_show_hidden = 1

nnoremap <c-b> :CtrlPBuffer<cr>

" }}}

" YouCompleteMe ---------------------- {{{
let g:ycm_server_keep_logfiles=1
"let g:ycm_server_log_level = 'debug'
let g:ycm_collect_identifiers_from_tags_files=1
" }}}

" JavaComplete ---------------------- {{{
"
" Vim configuration augroup ---------------------- {{{
" Put these in an autocmd group, so that we can delete them easily.
augroup JavaComplete
  au!

  " Set omnifunc
  autocmd FileType java setlocal omnifunc=javacomplete#Complete

augroup END
" }}}
" }}}

" tagbar ---------------------- {{{
"
nnoremap <silent> <F8> :TagbarToggle<CR>

" }}}

" NeoComplete ---------------------- {{{
"
let g:neocomplete#enable_at_startup = 1

inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" }}}

" vim-go ---------------------- {{{
"
if has('win32')
    " Windows doesn't like unix sockets, use tcp instead.  Breaks
    " auto-completion in golang otherwise.
    let g:go_gocode_socket_type = "tcp"
endif
" }}}

" }}}
