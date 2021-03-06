colorscheme darkblue
set columns=132
set lines=40

" Yank into the clipboard all VISUAL selections.
set guioptions+=a

" I almost never use the menu, and never use the toolbar.
set guioptions-=m
set guioptions-=T

if has("gui_win32")
  behave mswin
  set guifont=Lucida_Console:h9:cANSI

  "It appears the MyDiff() is no longer required for Windows (perhaps Vim is
  "finding diff on the path). Not sure if it handles spaces in file paths
  "properly so will keep this until proven.
  "set diffexpr=MyDiff()
  function MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-w ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    "if &sh =~ '\<cmd'
      "execute '!""C:\Program Files\Vim\vim73\diff" ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . '"'
    "else
      silent execute '!C:"\Program Files\Vim\vim74\diff" ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
    "endif
  endfunction
else
  set guifont=Courier\ New\ Bold\ 10
endif
