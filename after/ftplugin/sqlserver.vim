" NOTE: This is called when the sql type is set to sqlserver, see :h sql.txt
setlocal expandtab
setlocal tabstop=3
setlocal shiftwidth=3

" SQL Server code is not case sensitive
" Actually this option is global only, so setlocal acts just the same as set
" in this case, c'est la vie.
setlocal ignorecase

" TODO: There is a problem somewhere with folding - fix it.
setlocal nofoldenable

" TODO: Are the following useful?
"" SQL Server comments
"setlocal comments=s1:/*,mb:*,ex:*/,b:--
setlocal comments+=b:--,b:--*
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
                \ '\%(\<begin\%(\s\+\%(try\|catch\)\)\=\>\)\%(\s*transaction\)\@!:\<end\%(\s\+\%(try\|catch\)\)\=\>'.
                \ ',' .
                \ '\<if\>:<\else\>'

  "let b:match_skip = 'getline(".") =~ "\<begin\>\s\+\<transaction\>"'
endif
