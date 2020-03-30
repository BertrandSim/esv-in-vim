function! esv_in_vim#fitWidth()
  " autoformats scripture texts to current window's width
  " via Vim's built-in 'gw'

  let curpos_save = getpos('.')
  let tw_save = &l:tw

  let &l:tw = esv_in_vim#winTextWidth()
  let maxwidth = get(g:, 'esv_max_width', 78)
  let &l:tw = min( [ &l:tw, maxwidth ] )
  normal! gggwG

  let &l:tw = tw_save
  call setpos('.', curpos_save)
endfunction

function! esv_in_vim#autoWidthInit()
  " initializes autoformat using gw and fo=a
  let &l:tw = esv_in_vim#winTextWidth()
  setlocal formatoptions+=a
  normal! gggwGgg

  " autoformat when vim is resized
  " TODO [2020-03-29]: autoformat when local window is resized
  augroup esvFitWidth
    autocmd!
    autocmd VimResized <buffer> call esv_in_vim#fitWidth()
    " TODO [2020-03-29]: fix 'E523' vim is resized automatically
  augroup END
endfunction

function! esv_in_vim#winTextWidth()
  " computes width of current window's text area,
  " (excludes columns on left margin: line numbers, foldcolumns, signs)
  " based on https://stackoverflow.com/a/52921337

  let width = winwidth(0)

  let numberwidth = max([&numberwidth, strlen(line('$'))+1])
  let numwidth = (&number || &relativenumber) ? numberwidth : 0

  let foldwidth = &foldcolumn

  if &signcolumn == 'yes'
    let signwidth = 2
  elseif &signcolumn == 'auto'
    let signs = execute(printf('sign place buffer=%d', bufnr('')))
    let signs = split(signs, "\n")
    let signwidth = len(signs) > 2 ? 2 : 0
  else
    let signwidth = 0
  endif

  return width - numwidth - foldwidth - signwidth
endfunction

