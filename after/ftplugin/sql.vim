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
setlocal comments+=b:--,b:--*
"
"" PL/SQL := assignment construct should not cause indentation (with : option,
"" vim indents assumming a 'c' style label is being entered).
"setlocal cinkeys-=:
"setlocal indentkeys-=:

" This removes a VoraX mapping allowing '@' to execute the entire buffer.
" Yuck!  I prefer the default setting for this key. There's <Leader>be anyway.
silent! nunmap <buffer> @

" Added the matchit code here because it doesn't seem to be working in
" $VIMRUNTIME\ftplugin\sql.vim.
"
" Also, the original matchit settings don't seem to do exactly what I want.
"
" Some standard expressions for use with the matchit strings
let s:notend = '\%(\<end\s\+\)\@<!'
let s:when_no_matched_or_others = '\%(\<when\>\%(\s\+\%(\%(\<not\>\s\+\)\?<matched\>\)\|\<others\>\)\@!\)'
let s:or_replace = '\%(or\s\+replace\s\+\)\?'

" Define patterns for the matchit macro
if !exists("b:match_words")
    " SQL is generally case insensitive
    let b:match_ignorecase = 1

    " Handle the following:
    " if
    " elseif | elsif
    " else [if]
    " end if
    "
    " [while condition] loop
    "     leave
    "     break
    "     continue
    "     exit
    " end loop
    "
    " for
    "     leave
    "     break
    "     continue
    "     exit
    " end loop
    "
    " do
    "     statements
    " doend
    "
    " case
    " when
    " when
    " default
    " end case
    "
    " merge
    " when not matched
    " when matched
    "
    " EXCEPTION
    " WHEN column_not_found THEN
    " WHEN OTHERS THEN
    "
    " create[ or replace] procedure|function|event
                " \ '^\s*\<\%(do\|for\|while\|loop\)\>.*:'.

    " For ColdFusion support
    setlocal matchpairs+=<:>
    "let b:match_words = &matchpairs .
		"\ ',\<begin\>:\<end\>\W*$,'.
		"\
    let b:match_words = &matchpairs .
                \ ',' .
                \ '\<begin\>:\<end;'. 
                \ ',' .
                \ s:notend . '\<if\>:'.
                \ '\<elsif\>\|\<elseif\>\|\<else\>:'.
                \ '\<end\s\+if\>'.
                \ ',' .
                \ '\(^\s*\)\@<=\(\<\%(do\|for\|while\|loop\)\>.*\):'.
                \ '\%(\<exit\>\|\<leave\>\|\<break\>\|\<continue\>\):'.
                \ '\%(\<doend\>\|\%(\<end\s\+\%(for\|while\|loop\>\)\)\)'.
                \ ',' .
                \ '\%('. s:notend . '\<case\>\):'.
                \ '\%('.s:when_no_matched_or_others.'\):'.
                \ '\%(\<when\s\+others\>\|\<end\s\+case\>\)' .
                \ ',' .
                \ '\<merge\>:' .
                \ '\<when\s\+not\s\+matched\>:' .
                \ '\<when\s\+matched\>' .
                \ ',' .
                \ '\%(\<create\s\+' . s:or_replace . '\)\?'.
                \ '\%(function\|procedure\|event\):'.
                \ '\<returns\?\>'
                " \ '\<begin\>\|\<returns\?\>:'.
                " \ '\<end\>\(;\)\?\s*$'
                " \ '\<exception\>:'.s:when_no_matched_or_others.
                " \ ':\<when\s\+others\>'.
                " \ ',' .
		"
                " \ '\%(\<exception\>\|\%('. s:notend . '\<case\>\)\):'.
                " \ '\%(\<default\>\|'.s:when_no_matched_or_others.'\):'.
                " \ '\%(\%(\<when\s\+others\>\)\|\<end\s\+case\>\)' .
endif
