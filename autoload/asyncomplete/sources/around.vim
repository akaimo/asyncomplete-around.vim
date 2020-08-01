function! asyncomplete#sources#around#get_source_options(opts) abort
  return extend({
        \ 'refresh_pattern': '\k\+$',
        \}, a:opts)
endfunction

function! asyncomplete#sources#around#completor(opt, ctx) abort
  let l:col = a:ctx['col']
  let l:typed = a:ctx['typed']

  let l:buf = s:getlines(a:ctx['bufnr'], a:ctx['lnum'])
  let l:words = s:removeduplicates(s:parsebuffer(l:buf))

  let l:kw = matchstr(l:typed, '\w\+$')
  let l:kwlen = len(l:kw)

  let l:matches = map(l:words, '{"word":v:val,"dup":1,"icase":1,"menu": "[around]"}')
  let l:startcol = l:col - l:kwlen

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
  let l:words = split(l:text, '\W\+')
  return l:words
endfunction

function! s:removeduplicates(list) abort
  return filter(copy(a:list), 'index(a:list, v:val, v:key+1)==-1')
endfunction

function! s:log(...) abort
  call writefile([json_encode(a:000)], '/tmp/vim-around.log', 'a')
endfunction

