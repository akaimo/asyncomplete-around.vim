function! asyncomplete#sources#around#get_source_options(opts) abort
  return extend({
        \ 'refresh_pattern': '\k\+$',
        \}, a:opts)
endfunction

function! asyncomplete#sources#around#completor(opt, ctx) abort
endfunction

