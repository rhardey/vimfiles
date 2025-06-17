function! caser#TitleSnakeCase(word)
  return substitute(caser#TitleCase(a:word), ' ', '_', 'g')
endfunction"
