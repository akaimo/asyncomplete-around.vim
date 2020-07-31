let g:asyncomplete_around_line = 10


function! asyncomplete#sources#around#get_source_options(opts) abort
  return extend({
        \ 'refresh_pattern': '\k\+$',
        \}, a:opts)
endfunction

function! asyncomplete#sources#around#completor(opt, ctx) abort
  let l:col = a:ctx['col']
  let l:typed = a:ctx['typed']

  call s:log('ctx', a:ctx)
  let l:lnum = a:ctx['lnum']
  let l:buf = s:getlines(a:ctx['bufnr'], l:lnum)
  call s:log('buffer', l:buf)
  let l:words = s:parsebuffer(l:buf)
  call s:log('words', l:words)
"   let l:matches = [{"word":"test_text","dup":1,"icase":1,"menu": "[around]"}]
"   call asyncomplete#complete(a:opt['name'], a:ctx, a:ctx['col'], l:matches)
endfunction

function! s:getlines(bufnr, lnum) abort
  let l:first = max([1, a:lnum - g:asyncomplete_around_line])
  let l:end = a:lnum + g:asyncomplete_around_line
  let l:buf = getbufline(a:bufnr, l:first, l:end)
  return l:buf
endfunction

function! s:parsebuffer(buf) abort
  let l:text = join(a:buf)
  let l:words = split(l:text, '\W\+')
  return l:words
endfunction

function! s:log(...) abort
  call writefile([json_encode(a:000)], '/tmp/vim-around.log', 'a')
endfunction

