scriptencoding utf-8

" initial checks {{{

" check if +python3
if !has('python3') 
  echoerr "python 3 is required"
  finish
endif

" check esv_api_key
if !get(g:, "esv_api_key")
  echoerr "'g:esv_api_key' is not defined"
  finish
endif

" load guard
if get(g:, "loaded_esv_in_vim") 
  finish 
endif
let g:loaded_esv_in_vim = 1

" }}}

" main {{{

py3 from passage import get_esv_text
" passage.py should be in {rtp}/python3/  

function! s:esv_buffer(passage)
" puts a requested ESV Bible passage in vim buffer"

py3 << EOF
b = vim.current.buffer
passage_texts = get_esv_text(vim.eval("a:passage"))
b.vars['passage_texts'] = passage_texts
EOF

  " if error encountered, 
  " print it in vim cmd line, and exit
  if b:passage_texts =~ '^Error'
    echo b:passage_texts
    return
  endif 

  " move focus to 'passages' buffer"
  let esv_split = s:get_split_cmd()
  if bufwinnr('passages') <= 0
    exec 'noswapfile '.esv_split.' passages'
    " TODO [2019-12-30]: split options
    if has('conceal')
      call s:concealInit()
    endif
  endif
  let buf_num = bufwinnr('passages')
  exec buf_num.'wincmd w'
  
py3 << EOF
b = vim.current.buffer
is_first_entry = len(b[:]) == 1 and b[0] == ''
w = vim.current.window

# add seperator if other passages exist
if not is_first_entry:
  passages_sep = "\n* * *\n\n"
  passages_sep_l = passages_sep.splitlines()
  for l in passages_sep_l:
    b.append(l)

prev_line = len(b)
b.vars['esv_prev_line'] = prev_line


# put text(s) in 'passages' buffer
passage_lines = passage_texts.splitlines()
for l in passage_lines:
  b.append(l)

# place cursor on first passage ref
w.cursor = (prev_line + 1, 0)
EOF

  " convert smart quotes to straight quotes, 
  " unless specified otherwise by user opt
  if !get(g:, 'esv_smart_single_quotes', 0)
    silent! exec b:esv_prev_line+1.',$'."s/‘/'/g" 
    silent! exec b:esv_prev_line+1.',$'."s/’/'/g" 
  endif
  if !get(g:, 'esv_smart_double_quotes', 0)
    silent! exec b:esv_prev_line+1.',$'.'s/“/"/g' 
    silent! exec b:esv_prev_line+1.',$'.'s/”/"/g' 
  endif

py3 << EOF
# delete leading blank line
if is_first_entry:
  del b[0]   
EOF

endfunction

function! s:esv_buf_op(type, ...)
  " operator wrapper to main func s:esv_buffer()
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

" }}}

" helpers {{{

function! s:get_split_cmd()
  let esv_split = get(g:, 'esv_split', 'v')

  let splitcmd = esv_split == 'h' || esv_split == 'horizontal' ? 'split'  :
    \            esv_split == 'v' || esv_split == 'vertical'   ? 'vsplit' :
    \            esv_split == 't' || esv_split == 'tabpage'    ? 'tabe'   :
    \            esv_split == 'p' || esv_split == 'preview'    ? ''       :
    \ 'default'
    " TODO [2019-12-30]: check tab split option
    " TODO [2019-12-30] add preview split
  
  if splitcmd ==# 'default'
    echoerr '"g:esv_split" type should be one of "p/h/v/t".' 
  else
    return splitcmd
  endif
endfunction

function! s:optype2v(type)
  " converts first arg in opfunc() to v/V/^V
  let vtype = a:type ==# 'char'  || a:type ==# 'v' ? 'v' :
    \         a:type ==# 'line'  || a:type ==# 'V' ? 'V' :
    \         a:type ==# 'block' || a:type ==#'' ?'' : 
    \ 'default'

  if vtype ==# 'default' 
    echoerr "type should be 'char', 'line', or 'block'."
  else 
    return vtype
  endif
endfunction

" }}}

" enduser {{{
nnoremap <silent> <Plug>(esv_in_vim) :<C-u>set opfunc=<SID>esv_buf_op<CR>g@
vnoremap <silent> <Plug>(esv_in_vim) :<C-u>call <SID>esv_buf_op(visualmode(), 1)<CR>

if !hasmapto('<Plug>(esv_in_vim)', 'n')
  nmap <Leader>bb <Plug>(esv_in_vim)
endif

if !hasmapto('<Plug>(esv_in_vim)', 'v')
  vmap <Leader>bb <Plug>(esv_in_vim)
endif

command! -nargs=+ ESV call s:esv_buffer(<q-args>)

if has('conceal')
  command! ToggleVerseNum call s:toggleGroupConceal('esvVerseNum')
endif

" }}}

" conceal {{{
function! s:concealInit()
" called to setup conceal for window containing passages
  set conceallevel=2
  set concealcursor=nc

  " conceal verse numbers by default
  syntax match esvVerseNum '\[\d\+\]\( \|$\)' conceal
  hi link esvVerseNum Identifier
endfunction


function! s:toggleGroupConceal(group)
  " toggle conceal of a match group
  " from https://stackoverflow.com/questions/3853631/toggling-the-concealed-attribute-for-a-syntax-highlight-in-vim

  " Get the existing syntax definition
  redir => syntax_def
  exe 'silent syn list' a:group
  redir END
  " Split into multiple lines
  let lines = split(syntax_def, "\n")
  " Clear the existing syntax definitions
  exe 'syn clear' a:group
  for line in lines
    " Only parse the lines that mention the desired group
    " (so don't try to parse the "--- Syntax items ---" line)
    if line =~ a:group
      " Get the required bits (the syntax type and the full definition)
      let matcher = a:group . '\s\+xxx\s\+\(\k\+\)\s\+\(.*\)'
      let type = substitute(line, matcher, '\1', '')
      let definition = substitute(line, matcher, '\2', '')
      " Either add or remove 'conceal' from the definition
      if definition =~ 'conceal'
	let definition = substitute(definition, ' conceal\>', '', '')
	exe 'syn' type a:group definition
      else
	exe 'syn' type a:group definition 'conceal'
      endif
    endif
  endfor
endfunction

" }}}

" vim: fdm=marker:
