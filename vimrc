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

set nomodeline  " turn off any chance of malicious code being executed from within a text file (https://www.theregister.co.uk/2019/06/12/vim_remote_command_execution_flaw/).


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
set formatoptions=croqlj

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
let g:xml_syntax_folding = 1
"let perl_fold = 1

" I wanna use matchit! REVISIT: Trying match-up...
packadd matchit

" SQL syntax highlighting will default to sqlserver (ughh)
let g:sql_type_default = "sqlserver"

" To allow the use of the :: idiom for comments in the Windows Command Interpreter or working with MS-DOS bat files
let dosbatch_colons_comment = 1

" }}}

" Persistent undo ---------------------- {{{

if has('nvim')
  let vimUndoDir = vimDir."/nvim_undo"
else
  let vimUndoDir = vimDir."/undo"
endif

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

" Perform a diffput
nnoremap <localleader>p :diffput<cr>

" }}}

" Abbreviations ---------------------- {{{
iabbrev @@ ryan.hardey@ca.fujitsu.com
iabbrev rjh Ryan Hardey
" }}}

" Status line ---------------------- {{{
" Based on standard status, see :help statusline.
set statusline=\ %f " Relative path
set statusline+=\ %m%r " modified and read-only flags
set statusline+=%y " File type
set statusline+=[%{&ff}] " File format
set statusline+=[%{&fenc}] " File encoding
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

" vim-plug plugin management ---------------------- {{{
call plug#begin(vimDir.'/plugs')

" Leaving in, but commented out, for old times' sake.
"Plug 'https://github.com/talek/vorax4.git'
Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
"Plug 'maxboisvert/vim-simple-complete'
Plug 'https://github.com/PProvost/vim-ps1.git', { 'for': 'ps1' }
Plug 'https://github.com/tpope/vim-dadbod'
Plug 'https://github.com/kristijanhusak/vim-dadbod-ui'
Plug 'https://github.com/kristijanhusak/vim-dadbod-completion'
Plug 'arthurxavierx/vim-caser'

" vim-dadbod-completion configuration for built-in omnifunc
"autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni

" TODO: Work out how this functions
Plug 'neoclide/coc.nvim', {'branch': 'release'} " this is for auto complete, prettier and tslinting - see https://github.com/neoclide/coc.nvim

let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-db']  " list of CoC extensions needed

"Plug 'andymass/vim-matchup'

Plug 'https://github.com/github/copilot.vim.git'

Plug 'OmniSharp/omnisharp-vim' " C# IDE-like functionality
" Investigate ALE for linting of C# code, see OmniSharp's website for details.

call plug#end()
" }}}

" Vorax setup ---------------------- {{{

"if &diff
  " setup for diff mode
  " Vorax folding interferes with fugitive Gdiff, so turning off until
  " resolved.
  let g:vorax_folding_enable = 0
"endif

let g:vorax_homedir = $HOME.'\.vorax'
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
let g:ctrlp_show_hidden = 1 " Include .* directories and files in list.

nnoremap <c-b> :CtrlPBuffer<cr>

" }}}

" tagbar ---------------------- {{{
"
nnoremap <silent> <F8> :TagbarToggle<CR>

" }}}

" NeoComplete ---------------------- {{{
"
"let g:neocomplete#enable_at_startup = 1
"
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" }}}

" vim-go ---------------------- {{{
"
if has('win32')
    " Windows doesn't like unix sockets, use tcp instead.  Breaks
    " auto-completion in golang otherwise.
    let g:go_gocode_socket_type = "tcp"
endif
" }}}

" vc ---------------------- {{{
"
if (has('win32') || has('win64'))
  let g:vc_cache_dir=$HOME
endif


" }}}

" ale ---------------------- {{{
"
"augroup Ale

  "au!
  "autocmd FileType java let g:ale_java_javac_classpath=g:JavaComplete_LibsPath

"augroup END

" }}}

" coc.nvim ---------------------- {{{
"" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice

" Use <Tab> to confirm completion and select the first item if none selected
inoremap <expr> <Tab> coc#pum#visible() ? coc#_select_confirm() : "\<Tab>"

"inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
"if has('nvim-0.4.0') || has('patch-8.2.0750')
"  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" }}}

" caser.vim ---------------------- {{{
source $HOME/vimfiles/mine/caser.vim
" }}}
