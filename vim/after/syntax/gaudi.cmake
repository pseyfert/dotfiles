" Vim syntax file
" Program:      CMake - Cross-Platform Makefile Generator
" Version:      cmake version 3.13.20181010-ga3598
" Language:     CMake
" Author:       Andy Cedilnik <andy.cedilnik@kitware.com>,
"               Nicholas Hutchinson <nshutchinson@gmail.com>,
"               Patrick Boettcher <patrick.boettcher@posteo.de>
" Maintainer:   Dimitri Merejkowsky <d.merej@gmail.com>
" Former Maintainer: Karthik Krishnan <karthik.krishnan@kitware.com>
" Last Change:  2018 Oct 18
"
" Licence:      The CMake license applies to this file. See
"               https://cmake.org/licensing
"               This implies that distribution with Vim is allowed

if exists("b:current_syntax")
  if b:current_syntax != "cmake"
    finish
  endif
endif
let s:keepcpo= &cpo
set cpo&vim

syn region GaudiArgs start="(" end=")" contains=GaudiArguments

syn case match

syn keyword GaudiArguments contained
            \ INCLUDE_DIRS
            \ LINK_LIBRARIES
            \ PUBLIC_HEADERS
            \ NO_PUBLIC_HEADERS

syn case ignore

syn keyword cmakeGaudi
            \ gaudi_add_library
            \ gaudi_add_module
            \ nextgroup=GaudiArgs

hi def link cmakeGaudi Function
hi def link GaudiArguments ModeMsg

let &cpo = s:keepcpo
unlet s:keepcpo

" vim: set nowrap:
