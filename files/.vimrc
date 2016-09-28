filetype plugin indent on

syntax on
set number
set relativenumber
set hlsearch
set hidden
set pastetoggle=<F5>
set colorcolumn=80
"set mouse=a

" 'C-_' is 'Ctrl-/' (forward slash)"
map <C-_> :call ToggleComment()<CR>

nmap <F4> :call <SID>ToggleMouse()<CR>
nmap <C-l> :bnext<CR>
nmap <C-h> :bprevious<CR>
nmap <Space> zz
nmap <silent> // :nohlsearch<CR>

command -range Comm :<line1>,<line2>call ToggleComment()

function GetCommentPrepend()
  let data = {
\  'sh': '#',
\  'python': '#',
\  'javascript': '//',
\  'jade': '//',
\  'html': '<\!--',
\  'htmldjango': '<\!--',
\  'vim': '"',
\  'cpp': '//',
\ }
  return get(data, &ft, '')
endfunction

function GetCommentAppend()
  let data = {
\  'html': '-->',
\  'htmldjango': '-->',
\ }
  return get(data, &ft, '')
endfunction

function ToggleComment() range
  let prepend = GetCommentPrepend()
  let append = GetCommentAppend()
  for linenum in range(a:firstline, a:lastline)
    let curr_line = getline(linenum)
    if curr_line =~ '^\s*' . prepend
      " Remove comment
      let curr_line = substitute(curr_line, '\(^ *\)\(' . prepend . '\)', '\1', '')
      let curr_line = substitute(curr_line, append . '$', '', '')
    else
      " Add comment
      let curr_line = substitute(curr_line, '\(^ *\)', '\1' . prepend, '')
      let curr_line = substitute(curr_line, '$', append, '')
    endif
    call setline(linenum, curr_line)
  endfor
endfunction

fun! s:ToggleMouse()
  if !exists("s:old_mouse")
    let s:old_mouse = "a"
  endif
  if &mouse == ""
    let &mouse = s:old_mouse
    echo "Mouse is for Vim (" . &mouse . ")"
  else
    let s:old_mouse = &mouse
    let &mouse=""
    echo "Mouse is for terminal"
  endif
endfunction
