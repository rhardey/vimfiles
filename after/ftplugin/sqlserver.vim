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
    "
    " begin try
    " end try
    "
    " begin catch
    " end catch
    "
    " case
    " end
    "
    " if
    " else
    "

    " For ColdFusion support
    setlocal matchpairs+=<:>

    let b:match_words = &matchpairs .
                \ ','.
                \ '\<begin\s\+try\>:\<end\s\+try\>'.
                \ ','.
                \ '\<begin\s\+catch\>:\<end\s\+catch\>'.
                \ ','.
                \ '\<\%(begin\|case\)\>:\<end\>'.
                \ ','.
                \ '\<if\>:\<else\>'.
                \ ''

    let b:match_skip = 'getline(".") =~ "\\<begin\\>\\s\\+\\<transaction\\>"'

endif
