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

set wildmenu

""" undo stuff
set undofile
set undodir=$HOME/.vim_undo
set undolevels=1000
set undoreload=10000

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
:hi DiffAdd term=bold ctermbg=6 gui=bold guifg=Blue guibg=DarkCyan

"" LINEDIFF
" diff lines within a file (requires the linediff plugin)
" with the t key in visual modes (t=hard pronounciation of the d in diff)
" https://www.youtube.com/watch?v=DryXjvQ9t2A
" http://www.vim.org/scripts/script.php?script_id=3745
vnoremap t :Linediff<CR>

""" cursors
" use different cursor for normal, insert, replace modes
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

noremap <C-B>l :ALELint<cr>
""" LANGUAGE SPECIFICS
" TODO:
"  - do this depending on filetype (e.g. not for latex, vimrc, python)
"  - instead autopep8 for python
"  - ensure lsb_release is installed
"  - nasty: g:os comes with trailing linefeed
let g:os=system('echo ${$(lsb_release -d)[2]}')

"" Python
"
" pydocstring config
let g:pydocstring_enable_mapping=0
" indendation / formatting
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
autocmd FileType python noremap <C-I> :call Autopep8()<cr>
" want something like
"   yapf --style pep8 -i <fname>
"   pylint --rcfile=/usr/share/sevensense_linter/pylint.rc -rn --score=n --disable=R -f colorized <fname>
" code checking
autocmd BufWritePost *.py call Flake8()
autocmd FileType python noremap <C-B>b :call Flake8()<cr>
let g:flake8_show_in_file=1

"" CSV
let g:disable_rainbow_key_mappings=1

"" Shell
autocmd FileType sh noremap <C-B>b :ShellCheck!<cr>
" if executable('bash-language-server')
"   au User lsp_setup call lsp#register_server({
"         \ 'name': 'bash-language-server',
"         \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
"         \ 'whitelist': ['sh', 'zsh'],
"         \ })
" endif

"" Json
autocmd FileType json noremap <C-I> :%!json_reformat<cr>

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

"" Rust
"
autocmd FileType rust noremap <C-I> :RustFmt<cr>
autocmd FileType rust compiler rustc
autocmd FileType rust noremap <C-B>b :w<cr>:call MakeAndShow()<cr>
autocmd FileType rust noremap <C-B>r :RustRun<cr>

"" C/C++/JS/... formatting
"
" manual filetype overriding before other things (allow ft switches)
" consider *.icpp as c++
" http://vim.wikia.com/wiki/Forcing_Syntax_Coloring_for_files_with_odd_extensions
au BufRead,BufNewFile *.icpp setfiletype cpp

" ^I: run clang-format for a marked section or entire file if nothing marked
" (try to jump back to where started with ``)
if g:os == "Scientific\n"
  let $PATH="/cvmfs/lhcb.cern.ch/lib/lcg/releases/clang/7.0.0/x86_64-slc6-gcc62-opt/bin:/cvmfs/lhcb.cern.ch/lib/lcg/releases/gcc/8.1.0/x86_64-slc6/bin:/cvmfs/lhcb.cern.ch/lib/lcg/releases/binutils/2.30/x86_64-slc6/bin:" . $PATH
  let $LD_LIBRARY_PATH="/cvmfs/lhcb.cern.ch/lib/lcg/releases/clang/7.0.0/x86_64-slc6-gcc62-opt/lib64:/cvmfs/lhcb.cern.ch/lib/lcg/releases/gcc/8.1.0/x86_64-slc6/lib64:/cvmfs/lhcb.cern.ch/lib/lcg/releases/binutils/2.30/x86_64-slc6/lib:" . $LD_LIBRARY_PATH
  autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino vmap <C-I> :pyf /cvmfs/lhcb.cern.ch/lib/lcg/releases/clang/7.0.0/x86_64-slc6-gcc62-opt/share/clang/clang-format.py<cr>
  autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino nmap <C-I> ggV``G:pyf /cvmfs/lhcb.cern.ch/lib/lcg/releases/clang/7.0.0/x86_64-slc6-gcc62-opt/share/clang/clang-format.py<cr>``
elseif g:os == "CentOS\n"
  let $PATH="/cvmfs/lhcb.cern.ch/lib/lcg/releases/clang/8.0.0/x86_64-centos7/bin:/cvmfs/lhcb.cern.ch/lib/lcg/releases/gcc/8.2.0/x86_64-centos7/bin:/cvmfs/lhcb.cern.ch/lib/lcg/releases/binutils/2.30/x86_64-centos7/bin" . $PATH
  let $LD_LIBRARY_PATH="/cvmfs/lhcb.cern.ch/lib/lcg/releases/clang/8.0.0/x86_64-centos7/lib:/cvmfs/lhcb.cern.ch/lib/lcg/releases/gcc/8.2.0/x86_64-centos7/lib:/cvmfs/lhcb.cern.ch/lib/lcg/releases/gcc/8.2.0/x86_64-centos7/lib64:/cvmfs/lhcb.cern.ch/lib/lcg/releases/binutils/2.30/x86_64-centos7/lib" . $LD_LIBRARY_PATH
  autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino vmap <C-I> :pyf /cvmfs/lhcb.cern.ch/lib/lcg/releases/clang/8.0.0/x86_64-centos7/share/clang/clang-format.py<cr>
  function FormatFile()
    let l:lines="all"
    pyf /cvmfs/lhcb.cern.ch/lib/lcg/releases/clang/8.0.0/x86_64-centos7/share/clang/clang-format.py
  endfunction
  autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino nmap <C-I> :call FormatFile()<cr>
elseif g:os == "Arch\n"
  if has('python3')
    autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino vmap <C-I> :py3f /home/pseyfert/.local/bin/clang-format.py<cr>
    function FormatFile()
      let l:lines="all"
      py3f /home/pseyfert/.local/bin/clang-format.py
    endfunction
    autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino nmap <C-I> :call FormatFile()<cr>
  elseif has('python')
    autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino vmap <C-I> :pyf /home/pseyfert/.local/bin/clang-format.py<cr>
    function FormatFile()
      let l:lines="all"
      pyf /home/pseyfert/.local/bin/clang-format.py
    endfunction
    autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino nmap <C-I> :call FormatFile()<cr>
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
elseif g:os == "Ubuntu\n"
  autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino vmap <C-I> :py3f /usr/share/vim/addons/syntax/clang-format-10.py<cr>
  autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino nmap <C-I> ggV``G:py3f /usr/share/vim/addons/syntax/clang-format-10.py<cr>``
endif

let g:ycm_filetype_blacklist = {'notes': 1, 'markdown': 1, 'netrw': 1, 'unite': 1, 'pandoc': 1, 'tagbar': 1, 'qf': 1, 'vimwiki': 1, 'text': 1, 'infolog': 1, 'mail': 1}
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_goto_buffer_command = 'split'
if g:os == "Scientific\n" || g:os == "CentOS\n"
  " TODO: move away from site-dependent location
  let g:ycm_global_ycm_extra_conf = "/afs/cern.ch/user/p/pseyfert/.vim/.ycm_extra_conf.py"
elseif g:os == "Arch\n"
  " ycm here seems to be built for python2
  " let g:ycm_global_ycm_extra_conf = "/home/pseyfert/.ycm_global_conf.py"
  let g:ycm_global_ycm_extra_conf = "/home/pseyfert/coding/dotfiles/vim/bundle/ycm_conf/ycm_global_conf.py"
  "let g:ycm_server_python_interpreter='/usr/bin/python2'
elseif g:os == "Debian\n"
endif
autocmd FileType c,cpp,proto,javascript,objc,java,typescript,arduino nmap <C-B>b :YcmDiags<cr>

let g:ale_linters_explicit = 1
let g:ale_linters = { 'cpp': ['clangtidy'], 'python': ['pylint', 'mypy']}
let g:ale_cpp_clangtidy_executable = 'clang-tidy-10'
let g:ale_cpp_clangtidy_checks = ['clang-diagnostic-*,clang-analyzer-*,performance*,bugprone*,clang*,cppcore*,google*,hicpp*,modernize*,readability*,-google-explicit-constructor,-hicpp-explicit-conversions,-google-readability-todo,-*-uppercase-literal-suffix,-modernize-use-trailing-return-type']
let g:ale_cpp_clangtidy_extra_options = '-p=/home/pseyfert/navigator_ws/build/navigation_common'
let g:ale_python_pylint_options = '--rcfile=/usr/share/sevensense_linter/pylint.rc --disable=R'
let g:ale_python_mypy_options = '--ignore-missing-imports --py2'

function! MakeAndShow()
  :w
  silent make!
  redraw!
  cwindow
endfunction

nmap <C-B>r :call MakeAndShow()<cr>

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
  elseif g:os=="Ubuntu\n"
    " set rtp+=/usr/share/vim-youcompleteme
    let g:my_ycm = "ubuntu"
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

let g:licenses_authors_name = 'Paul Seyfert <pseyfert.mathphys@gmail.com>'
" let g:licenses_copyright_holders_name = 'CERN for the benefit of the LHCb collaboration'

map <F6> :doautocmd BufRead<cr>
function! RunFtDetect(...)
  let fname = get(a:, 0, 0)
  if fname
    echo "detecting filetype based on filename " . a:1
    exec 'doautocmd BufRead ' . a:1
  else
    echo "detecting filetype based on buffer content"
    exec 'doautocmd BufRead'
  endif
endfunction
com! -nargs=? FtDetect :call RunFtDetect(<args>)

"" for debugging syntax highlighting functions
" function! SyntaxItem()
"   return synIDattr(synID(line("."),col("."),1),"name")
" endfunction
"
" map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
" \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
"" end-syntax debugging


"" experimenting with lsp and tabnine
" let g:ycm_filetype_blacklist = {'cpp': 1}
" let g:ycm_filetype_whitelist = { }
" if executable('clangd')
"   augroup lsp_clangd
"     autocmd!
"     autocmd User lsp_setup call lsp#register_server({
"           \ 'name': 'clangd',
"           \ 'cmd': {server_info->['clangd']},
"           \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
"           \ })
"     autocmd FileType c setlocal omnifunc=lsp#complete
"     autocmd FileType cpp setlocal omnifunc=lsp#complete
"     autocmd FileType objc setlocal omnifunc=lsp#complete
"     autocmd FileType objcpp setlocal omnifunc=lsp#complete
"   augroup end
"   autocmd FileType c,cpp noremap <C-B>b :LspDocumentDiagnostics<cr>
" endif
" let g:lsp_signs_enabled = 1         " enable signs
" let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
" " let g:lsp_log_verbose = 1
" " let g:lsp_log_file = '/tmp/vim-lsp.log'

" set rtp+=/home/pseyfert/.vim/ondemand/tabnine-vim
"
"" end-experimenting with lsp and tabnine

let &errorformat="%*[^\"]\"%f\"%*\\D%l: %m,
      \\"%f\"%*\\D%l: %m,
      \%-G%f:%l: (Each undeclared identifier is reported only once,
      \%-G%f:%l: for each function it appears in.),
      \%-GIn file included from %f:%l:%c:,
      \%-GIn file included from %f:%l:%c\\,,
      \%-GIn file included from %f:%l:%c,
      \%-GIn file included from %f:%l,
      \%-G%*[ ]from %f:%l:%c,
      \%-G%*[ ]from %f:%l:,
      \%-G%*[ ]from %f:%l\\,,
      \%-G%*[ ]from %f:%l,
      \[01m[K%f:%l:%c:%m,
      \%f:%l:%c:%m,
      \%f(%l):%m,
      \[01m[K%f:%l:%m,
      \%f:%l:%m,
      \[01m[K%f:%m,
      \\"%f\"\\, line %l%*\\D%c%*[^ ] %m,
      \%D%*\\a[%*\\d]: Entering directory %*[`']%f',
      \%X%*\\a[%*\\d]: Leaving directory %*[`']%f',
      \%D%*\\a: Entering directory %*[`']%f',
      \%X%*\\a: Leaving directory %*[`']%f',
      \%DMaking %*\\a in %f,
      \%f|%l| %m"
