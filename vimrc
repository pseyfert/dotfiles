" syntax highlighting on by default
syntax on

" enable filetype plugins
filetype plugin on

" enable the matchit plugin (jumping between opening/closing xml/html tags and
" latx \begin \end)
runtime macros/matchit.vim

" run clang-format on ^K for a marked section (^I for the entire file, try to
" jump back to where started with ``)
" TODO:
"  - do this depending on filetype (e.g. not for latex, vimrc, python)
"  - instead autopep8 for python
if has('python3')
map <C-K> :py3f /usr/share/clang/clang-format.py<cr>
map <C-I> ggV``G:py3f /usr/share/clang/clang-format.py<cr>``
elseif has('python')
map <C-K> :p3f /usr/share/clang/clang-format.py<cr>
map <C-I> ggV``G:pyf /usr/share/clang/clang-format.py<cr>``
endif

" ycm here seems to be built for python2
let g:ycm_server_python_interpreter='/usr/bin/python2'
let g:ycm_confirm_extra_conf = 0
