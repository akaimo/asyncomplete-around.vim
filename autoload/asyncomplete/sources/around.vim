let g:asyncomplete_around_line = 10


function! asyncomplete#sources#around#get_source_options(opts) abort
  return extend({
        \ 'refresh_pattern': '\k\+$',
        \}, a:opts)
endfunction

function! asyncomplete#sources#around#completor(opt, ctx) abort
  let l:col = a:ctx['col']
  let l:typed = a:ctx['typed']

  let l:lnum = a:ctx['lnum']
  let l:buf = s:getlines(a:ctx['bufnr'], l:lnum)
  call asyncomplete#log('buffer', l:buf)
endfunction

function! s:getlines(bufnr, lnum) abort
  let l:first = max([1, a:lnum - g:asyncomplete_around_line])
  let l:end = a:lnum + g:asyncomplete_around_line
  call asyncomplete#log(l:first, l:end)
  let l:buf = getbufline(a:bufnr, l:first, l:end)
  return l:buf
endfunction

