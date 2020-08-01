if exists('g:asyncomplete_around_loaded')
    finish
endif
let g:asyncomplete_around_loaded = 1

let g:asyncomplete_around_range = get(g:, 'asyncomplete_around_range', 20)

