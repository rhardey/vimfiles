" Basic settings ---------------------- {{{
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set nobackup    " Do not keep a backup file (i.e. no ~ files scattered around, OK if you use version control).
"set backup     " Keep a backup file.

set showcmd     " display incomplete commands

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
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

" show matching parenthesis etc
set showmatch

" REVISIT
set formatoptions=croql

set printoptions+=number:y

" Clobbered by statusline settings, by the looks.
"set ruler

set history=1000

set viminfo='20,\"50

" Search settings.
set hlsearch
set incsearch

set nrformats=alpha,hex

" Show the line number relative to the line with the cursor in front of each line.
set relativenumber

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

" }}}

" Mappings ---------------------- {{{

" Explicitly set the leader mappings, so I know what they are.  Should be done
" before plugins are activated.
let mapleader="\\"
" Let's keep local and global leader settings separate.
let maplocalleader="-" " REVISIT - Is there a better key?

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Make it easy to edit the .vimrc file.
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" A different escape - REVISIT not sure how valuable I'll find this.
inoremap jk <esc>

" Want a quick way to close
nnoremap <leader>c <C-W>c

" Turn off highlighting for the last search.
nnoremap <leader>h :nohlsearch<cr>

" Remove extraneous space at the end of lines
nnoremap <leader>ds :%s/\s\+$//g<cr>

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
set statusline+=%=%-14.(%l,%c%V%) " Line number, column and virtual column
set statusline+=\ %14L " Lines in buffer
set statusline+=\ %P " Percentage through file of displayed window.
" }}}

" Diff setup ---------------------- {{{

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
" Pathogen plugin management ---------------------- {{{
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()
" }}}

" Vorax setup ---------------------- {{{
let g:vorax_debug_level = 'ALL'
let g:vorax_output_window_clear_before_exec = 0
let g:vorax_throbber_chars = ['|', '/', '-', '\']
let g:vorax_explorer_file_extensions = { 'PACKAGE' : 'pkg',
                                   \     'PACKAGE_SPEC' : 'pks',
                                   \     'PACKAGE_BODY' : 'pkb',
                                   \     'FUNCTION' : 'fnc',
                                   \     'PROCEDURE' : 'prc',
                                   \     'TRIGGER' : 'trg',
                                   \     'TYPE' : 'typ',
                                   \     'TYPE_SPEC' : 'tps',
                                   \     'TYPE_BODY' : 'tpb',
                                   \     'TABLE' : 'tab',
                                   \     'VIEW' : 'view', }
" }}}

" CtrlP ---------------------- {{{
"
let g:ctrlp_working_path_mode = 'rw' " Use the CWD.

nnoremap <c-b> :CtrlPBuffer<cr>

" }}}
" }}}
