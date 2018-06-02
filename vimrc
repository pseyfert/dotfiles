" syntax highlighting on by default
syntax on
" highlight search results
set hlsearch
" maintain space around cursor
set scrolloff=5
" enable filetype plugins
filetype plugin on

""" COMMANDS
"
" when going through many files with git difftool, I want to close w/o leader
" key
map Q :qa<cr>
map X :xa!<cr>

""" INDENTATION
"
" set tab to two spaces width
" (display tab as 2 and insert 2 spaces through expandtab)
" set tabstop=2
" insert two spaces on hitting tab, but don't affect tab display
set softtabstop=2
" standard indentation width (for auto indenting)
set shiftwidth=2
" insert spaces when hitting tab
set expandtab
" This enables automatic indentation as you type.
filetype indent on

""" NAVIGATION
" enable the matchit plugin (jumping between opening/closing xml/html tags and
" latx \begin \end)
runtime macros/matchit.vim

""" DIFF THINGS
"
"" diff visualisation
if &diff
 " diff mode
 set diffopt+=iwhite
endif
" small tweaked wrt defaults for compatibility with syntax highlighting
:hi DiffText term=underline cterm=underline ctermbg=LightMagenta gui=bold guibg=Red

"" LINEDIFF
" diff lines within a file (requires the linediff plugin)
" with the t key in visual modes (t=hard pronounciation of the d in diff)
" https://www.youtube.com/watch?v=DryXjvQ9t2A
" http://www.vim.org/scripts/script.php?script_id=3745
vnoremap t :Linediff<CR>

""" LANGUAGE SPECIFICS

"" PYTHON INDENTATION
"
" indendation
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
" code checking upon write
autocmd BufWritePost *.py call Flake8()
let g:flake8_show_in_file=1


"" C/C++/JS/... formatting
"
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

" consider *.icpp as c++
" http://vim.wikia.com/wiki/Forcing_Syntax_Coloring_for_files_with_odd_extensions
au BufRead,BufNewFile *.icpp setfiletype cpp


"" LATEX

" Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" for syntax highlighting, consider bbx and def as tex files
au BufRead,BufNewFile *.def setfiletype tex
au BufRead,BufNewFile *.bbx setfiletype tex
