let g:complete_min_size = 3

function! asyncomplete#sources#around#get_source_options(opts) abort
  return extend({
        \ 'refresh_pattern': '\k\+$',
        \}, a:opts)
endfunction

function! asyncomplete#sources#around#completor(opt, ctx) abort
  let l:col = a:ctx['col']
  let l:typed = a:ctx['typed']

  let l:kw = matchstr(l:typed, '[[:alnum:]_-]\+$')
  let l:kwlen = len(l:kw)

  let l:startcol = l:col - l:kwlen

  if l:kwlen == 0
    return
  endif

  let l:buf = s:getlines(a:ctx['bufnr'], a:ctx['lnum'])
  let l:words = s:removeduplicates(s:parsebuffer(l:buf))
  let l:words = s:remove_small_words(l:words, g:complete_min_size)

  let l:matches = map(l:words, '{"word":v:val,"dup":1,"icase":1,"menu": "[around]"}')

  call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:matches)
endfunction

function! s:getlines(bufnr, lnum) abort
  let l:first = max([1, a:lnum - g:asyncomplete_around_range])
  let l:end = a:lnum + g:asyncomplete_around_range
  let l:buf = getbufline(a:bufnr, l:first, l:end)
  return l:buf
endfunction

function! s:parsebuffer(buf) abort
  let l:text = join(a:buf)
  let l:words = split(l:text, '[^[:alnum:]_-]\+')
  return l:words
endfunction

function! s:removeduplicates(list) abort
  return filter(copy(a:list), 'index(a:list, v:val, v:key+1)==-1')
endfunction

function! s:remove_small_words(words, size) abort
  return filter(copy(a:words), { index, val -> strlen(val) >= a:size })
endfunction

