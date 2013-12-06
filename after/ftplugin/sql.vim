" NOTE: I force the use of PL/SQL syntax file for file types of SQL.
setlocal expandtab
setlocal tabstop=3
setlocal shiftwidth=3

" PL/SQL is not case sensitive
" Actually this option is global only, so setlocal acts just the same as set
" in this case, c'est la vie.
setlocal ignorecase

" TODO: There is a problem somewhere with folding - fix it.
setlocal nofoldenable

" TODO: Are the following useful?
"" PL/SQL comments
"setlocal comments=s1:/*,mb:*,ex:*/,b:--
setlocal comments+=b:--*
"
"" PL/SQL := assignment construct should not cause indentation (with : option,
"" vim indents assumming a 'c' style label is being entered).
"setlocal cinkeys-=:
"setlocal indentkeys-=:
