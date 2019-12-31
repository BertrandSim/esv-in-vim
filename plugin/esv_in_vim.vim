" check if +python3
if !has('python3') 
  echoerr "python 3 is required"
  finish
endif

py3 from passage import get_esv_text
" TODO [2019-12-30]: fix import!
" for now, place passage.py in {rtp}/python3/
"  eg. .vim/python3/

function! s:esv_buffer(passage)
" puts a requested ESV Bible passage in vim buffer"

" move focus to 'passages' buffer"
  let esv_split = s:get_split_cmd()
  if bufwinnr('passages') <= 0
    exec esv_split.' '.'passages'
    " TODO [2019-12-30]: split options
  endif
  let buf_num = bufwinnr('passages')
  exec buf_num.'wincmd w'
  
py3 << EOF
b = vim.current.buffer
is_first_entry = len(b[:]) == 1 and b[0] == ''

# add seperator if other passages exist
if not is_first_entry:
  passages_sep = "\n* * *\n\n"
  passages_sep_l = passages_sep.splitlines()
  for l in passages_sep_l:
    b.append(l)

# put text(s) in 'passages' buffer
passage_texts = get_esv_text(vim.eval("a:passage"))
passage_lines = passage_texts.splitlines()
for l in passage_lines:
  b.append(l)

# delete leading blank line
if is_first_entry:
  del b[0]   
EOF

" view requested passages
normal! G

endfunction

function! s:esv_buf_op(type, ...)
  let reg_save = @@

  if a:0	" invoked from visual mode
    silent norm! gvy
  else
    let vtype = s:optype2v(a:type)
    silent exec 'norm! `['.vtype.'`]y'
  endif

  let passages = @@
  " replace newlines with tabs
  let passages = substitute(passages, "\n", "\t", "g")	
  let passages = substitute(passages, "\r", "\t", "g")	
  call s:esv_buffer(passages)

  let @@ = reg_save
endfunction

function! s:get_split_cmd()
  let esv_split = get(g:, 'esv_split', 'v')
  if     esv_split == 'h' || esv_split == 'horizontal'
    return 'split'
  elseif esv_split == 'v' || esv_split == 'vertical'
    return 'vsplit'
  elseif esv_split == 't' || esv_split == 'tabpage'
    return 'tabe'
    " TODO [2019-12-30]: check tab split option
  elseif esv_split == 'p' || esv_split == 'preview'
    " TODO [2019-12-30] add preview split
  else
    echoerr '"g:esv_split" type should be one of "p/h/v/t".' 
endfunction

function! s:optype2v(type)
  " converts first arg in opfunc() to v/V/^V
  if a:type ==# 'char'  || a:type ==# 'v' 
    return 'v'
  elseif a:type ==# 'line'  || a:type ==# 'V' 
    return 'V'
  elseif a:type ==# 'block' || a:type ==# '' 
    return ''
  else
    echoerr "type should be 'char', 'line', or 'block'."
  endif
endfunction

" enduser
nnoremap <Plug>(esv_in_vim) :<C-u>set opfunc=<SID>esv_buf_op<CR>g@
vnoremap <Plug>(esv_in_vim) :<C-u>call <SID>esv_buf_op(visualmode(), 1)<CR>

if !hasmapto('<Plug>(esv_in_vim)', 'n')
  nmap <Leader>bb <Plug>(esv_in_vim)
endif

if !hasmapto('<Plug>(esv_in_vim)', 'v')
  vmap <Leader>bb <Plug>(esv_in_vim)
endif

command! -nargs=+ ESV call s:esv_buffer('<args>')


