"=============================================================================
" regreplop.vim - a operator to replace something with a register
"=============================================================================
"
" Author:  Takahiro SUZUKI <takahiro.suzuki.ja@gmDELETEMEail.com>
" Version: 1.0 (Vim 7.1)
" Licence: MIT Licence
"
"=============================================================================
" Document: {{{1
"
"-----------------------------------------------------------------------------
" Description:
"   This plugin provides a operator to replace something(motion/visual) with a
"   specified register.
"   By default, the operator is mapped at
"     <Plug>ReplaceMotion  " for normal mode
"     <Plug>ReplaceVisual  " for visual mode
"   and if there are no key mapping for <C-K>, <C-K> is mapped to these
"   operators.
"
"   If you want to map them to another keys, add like below in your vimrc.
"     nmap YOURKEY <Plug>ReplaceMotion
"     vmap YOURKEY <Plug>ReplaceVisual
"
"-----------------------------------------------------------------------------
" Installation:
"   Place this file in /usr/share/vim/vim*/plugin or ~/.vim/plugin/
"   Now replacing operator <C-K> is available.
"
"-----------------------------------------------------------------------------
" Examples:
"   in normal mode:
"      <C-K>iw     " replaces inner word with default register
"      "a<C-K>iw   " replaces inner word with register a
"      <C-K>$      " replaces whole text right the cursor
"
"   in visual mode:
"      <C-K>       " replace visual selection with default register
"      "a<C-K>     " replace visual selection with register a
"
"-----------------------------------------------------------------------------
" ChangeLog:
"   1.0:
"     - Initial release
"
" }}}1
"=============================================================================

" replace selection with register
function! s:ReplaceMotion(type, ...)
  let reg = empty(s:lastreg) ? '"' : s:lastreg
  let op_mode = 'v'

  if a:0 " visual mode
    let marks = ['<', '>']
  else   " normal mode
    let marks = ['[', ']']
    if a:type == 'list'
      let op_mode = 'V'
    endif
  endif

  exe 'normal! `'.marks[1].'$'
  let paste_cmd = getpos("'".marks[1]) == getpos('.') ? 'p' : 'P'
  exe 'normal! `'.marks[0].'"_d'.op_mode.'`'.marks[1].'"'.reg.paste_cmd
endfunction

function! s:SaveReg()
  let s:lastreg = v:register
endfunction

" default mapping
if !hasmapto('<Plug>ReplaceMotion', 'n')
  nmap <silent> <C-K> <Plug>ReplaceMotion
endif
if !hasmapto('<Plug>ReplaceVisual', 'v')
  vmap <silent> <C-K> <Plug>ReplaceVisual
endif

" export the plugin mapping
nnoremap <silent> <Plug>ReplaceMotion :<C-U>call <SID>SaveReg()<CR><ESC>:set opfunc=<SID>ReplaceMotion<CR>g@
vnoremap <silent> <Plug>ReplaceVisual :<C-U>call <SID>SaveReg()<CR><ESC>:call <SID>ReplaceMotion('', 1)<CR>

" vim: set foldmethod=marker et ts=2 sts=2 sw=2:
