" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		" do not keep a backup file, use versions instead
"set backup		" keep a backup file

set showcmd		" display incomplete commands

" Package management: pathogen
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

" REVISIT
" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

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

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set encoding=utf-8
set nowrapscan autoindent

" When off a buffer is unloaded when it is abandoned.  When on a
" buffer becomes hidden when it is abandoned.
set hidden

" removes option where a :read command with a file name arg will set the
" alternate file name for the current window.
set cpoptions-=a

" variables for php syntax highlighting
let php_minlines = 2000

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

set ruler

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

" Turn off that #@$%* beeping!!
set visualbell

" If folding is enabled in a filetype's syntax file, enable it by default.
"set foldmethod=syntax

" Turn syntax folding on for these filetypes.
"let g:xml_syntax_folding = 1
"let perl_fold = 1

" Diff options
set diffopt+=vertical
set diffopt+=iwhite
set diffopt+=icase

" Vorax
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
