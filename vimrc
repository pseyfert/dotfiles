" use the pathogen plugin manager
execute pathogen#infect()
" syntax highlighting on by default
syntax on
" highlight search results
set hlsearch
" maintain space around cursor
set scrolloff=5
" enable filetype plugins
filetype plugin on
set background=light

""" COMMANDS
"
" when going through many files with git difftool, I want to close w/o leader
" key
map Q :qa<cr>
map X :xa!<cr>
map <C-n> :tabnext<cr>
map <C-p> :tabprevious<cr>
map <C-t> :tabnew<cr>
map <C-f> <c-w>gF

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
" indent on ^i
" not overly useful in the default form, I'm mainly interested in the
" language specific functions below, and have the same UI when falling back to =.
nmap <C-I> =gg``=G
vmap <C-I> =

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
  " tweak yet another syntax color + diff color issue (preprocessor magenta on
  " diff magenta)
  colorscheme elflord
endif
" small tweaked wrt defaults for compatibility with syntax highlighting
" otherwise I end up with red on red (string on diff)
:hi DiffText term=underline cterm=underline ctermbg=LightMagenta gui=bold guibg=Red

"" LINEDIFF
" diff lines within a file (requires the linediff plugin)
" with the t key in visual modes (t=hard pronounciation of the d in diff)
" https://www.youtube.com/watch?v=DryXjvQ9t2A
" http://www.vim.org/scripts/script.php?script_id=3745
vnoremap t :Linediff<CR>

""" LANGUAGE SPECIFICS
" TODO:
"  - do this depending on filetype (e.g. not for latex, vimrc, python)
"  - instead autopep8 for python
"  - ensure lsb_release is installed
"  - nasty: g:os comes with trailing linefeed
let g:os=system('echo ${$(lsb_release -d)[2]}')

"" PYTHON INDENTATION
"
" indendation
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
" TODO: needs fixing on lxplus
if g:os != "Scientific\n" || g:os != "CentOS\n"
  autocmd FileType python noremap <C-I> :call Autopep8()<cr>
  " code checking upon write
  autocmd BufWritePost *.py call Flake8()
  let g:flake8_show_in_file=1
endif


"" Go
"
" indentation (done by vim-go upon write, but for muslce memory)
if g:os == "Scientific\n" || g:os == "CentOS\n"
  let g:go_version_warning = 0
endif
autocmd FileType go set noexpandtab copyindent preserveindent softtabstop=0 shiftwidth=4 tabstop=4
autocmd FileType go noremap <C-I> :GoFmt<cr>
autocmd FileType go noremap <C-B>i :w<cr>:GoImports<cr>
autocmd FileType go noremap <C-B>b :w<cr>:GoBuild<cr>
autocmd FileType go noremap <C-B>r :w<cr>:GoRun<cr>

"" C/C++/JS/... formatting
"
" manual filetype overriding before other things (allow ft switches)
" consider *.icpp as c++
" http://vim.wikia.com/wiki/Forcing_Syntax_Coloring_for_files_with_odd_extensions
au BufRead,BufNewFile *.icpp setfiletype cpp

" run clang-format on ^K for a marked section (^I for the entire file, try to
" jump back to where started with ``)
if g:os == "Scientific\n"
  let $PATH="/cvmfs/lhcb.cern.ch/lib/lcg/external/llvm/3.9/x86_64-slc6/bin:" . $PATH
  let $LD_LIBRARY_PATH="/cvmfs/lhcb.cern.ch/lib/lcg/releases/gcc/4.9.3/x86_64-slc6/lib64:/cvmfs/lhcb.cern.ch/lib/lcg/external/llvm/3.9/x86_64-slc6/lib/:" . $LD_LIBRARY_PATH
  autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino vmap <C-I> :pyf /cvmfs/lhcb.cern.ch/lib/lcg/external/llvm/3.7/x86_64-slc6/share/clang/clang-format.py<cr>
  autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino nmap <C-I> ggV``G:pyf /cvmfs/lhcb.cern.ch/lib/lcg/external/llvm/3.7/x86_64-slc6/share/clang/clang-format.py<cr>``
elseif g:os == "CentOS\n"
  let $PATH="/cvmfs/lhcb.cern.ch/lib/lcg/external/llvm/3.9/x86_64-centos7/bin/:/afs/cern.ch/sw/lcg/external/llvm/3.9/x86_64-centos7/bin:" . $PATH
  let $LD_LIBRARY_PATH="/cvmfs/lhcb.cern.ch/lib/lcg/releases/gcc/4.9.3/x86_64-centos7/lib64/:/afs/cern.ch/sw/lcg/external/gcc/4.9.3/x86_64-centos7/lib64:/cvmfs/lhcb.cern.ch/lib/lcg/external/llvm/3.9/x86_64-centos7/lib/lib:/afs/cern.ch/sw/lcg/external/llvm/3.9/x86_64-centos7/lib:" . $LD_LIBRARY_PATH
  autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino vmap <C-I> :pyf /cvmfs/lhcb.cern.ch/lib/lcg/external/llvm/3.9/x86_64-centos7/share/clang/clang-format.py<cr>
  autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino nmap <C-I> ggV``G:pyf /cvmfs/lhcb.cern.ch/lib/lcg/external/llvm/3.9/x86_64-centos7/share/clang/clang-format.py<cr>``
elseif g:os == "Arch\n"
  if has('python3')
    autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino vmap <C-I> :py3f /usr/share/clang/clang-format.py<cr>
    autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino nmap <C-I> ggV``G:py3f /usr/share/clang/clang-format.py<cr>``
  elseif has('python')
    autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino vmap <C-I> :pyf /usr/share/clang/clang-format.py<cr>
    autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino nmap <C-I> ggV``G:pyf /usr/share/clang/clang-format.py<cr>``
  endif
elseif g:os == "Debian\n"
  " Tears go here.
  " In Debian stable we get clang 3.8 which comes with clang-format for python2
  " only. But vim comes with python3 only.
  " Debian testing seems okay.
  " TODO:
  "  - avoid hard coded version?
  "  - detect host (local patch)
  autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino vmap <C-I> :py3f /usr/share/clang/clang-format-4.0/clang-format.py<cr>
  autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino nmap <C-I> ggV``G:py3f /usr/share/clang/clang-format-4.0/clang-format.py<cr>``
endif

let g:ycm_filetype_blacklist = {'notes': 1, 'markdown': 1, 'netrw': 1, 'unite': 1, 'pandoc': 1, 'tagbar': 1, 'qf': 1, 'vimwiki': 1, 'text': 1, 'infolog': 1, 'mail': 1, 'go': 1}
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_goto_buffer_command = 'split'
if g:os == "Scientific\n" || g:os == "CentOS\n"
  " TODO: move away from site-dependent location
  let g:ycm_global_ycm_extra_conf = "/afs/cern.ch/user/p/pseyfert/.vim/.ycm_extra_conf.py"
elseif g:os == "Arch\n"
  " ycm here seems to be built for python2
  let g:ycm_global_ycm_extra_conf = "/home/pseyfert/.ycm_global_conf.py"
  "let g:ycm_server_python_interpreter='/usr/bin/python2'
elseif g:os == "Debian\n"
endif

" toggle the column with the >> signs
nnoremap <F5> :call ToggleCopyPasteMode()<cr>
if g:os == "Scientific\n" || g:os == "CentOS\n"
  " tough luck
else
  set signcolumn=auto
endif
function! ToggleCopyPasteMode()
  if &paste == 0
    if !(g:os == "Scientific\n" || g:os == "CentOS\n")
      set signcolumn=no
    endif
    let g:flake8_show_in_file=0
    set conceallevel=3
  else
    if !(g:os == "Scientific\n" || g:os == "CentOS\n")
      set signcolumn=auto
    endif
    let g:flake8_show_in_file=1
    set conceallevel=0
  endif
  set paste!
endfunction
set conceallevel=0

if &diff
  let g:my_ycm = "not_in_diff"
else
  let g:ycm_filetype_whitelist = { 'cpp': 1 }
  let g:ycm_filetype_blacklist = {
        \ 'tagbar' : 1,
        \ 'qf' : 1,
        \ 'notes' : 1,
        \ 'markdown' : 1,
        \ 'unite' : 1,
        \ 'text' : 1,
        \ 'vimwiki' : 1,
        \ 'pandoc' : 1,
        \ 'infolog' : 1,
        \ 'mail' : 1,
        \ 'python' : 1
        \}
  if g:os=="Scientific\n"
    set rtp+=/afs/cern.ch/user/p/pseyfert/.vim/os_dependent_bundle/YouCompleteMe.slc6
    let g:my_ycm = "slc6"
  elseif g:os=="CentOS\n"
    set rtp+=/afs/cern.ch/user/p/pseyfert/.vim/os_dependent_bundle/YouCompleteMe
    let g:my_ycm = "cc7"
  else
    let g:my_ycm = "unknownOS"
  endif
endif

"" LATEX

" Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" for syntax highlighting, consider bbx and def as tex files
au BufRead,BufNewFile *.def setfiletype tex
au BufRead,BufNewFile *.bbx setfiletype tex



""" TODO

" * doxygen something

let g:licenses_authors_name = 'Paul Seyfert <pseyfert@cern.ch>'
let g:licenses_copyright_holders_name = 'CERN for the benefit of the LHCb collaboration'

" for debugging syntax highlighting functions
" function! SyntaxItem()
"   return synIDattr(synID(line("."),col("."),1),"name")
" endfunction
"
" map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
" \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
