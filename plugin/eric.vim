" eric.vim - Baby's first plugin
" Maintainer:   Eric Baukhages <http://eric.baukhag.es>
" Version:      0.1

if exists('g:loaded_eric')
  finish
endif
let g:loaded_eric = 1

if !exists("g:chrome_cli_command")
  let g:chrome_cli_command = "chrome-cli"
endif

function! GrabTabList()
  let tablist = systemlist(g:chrome_cli_command . " list tabs")
  return tablist
endfunction

function! ChangeCurrentTab()
    " Get the tab list.
    let tablist = GrabTabList()

    " Open a new split and set it up.
    vsplit __Chrome_Tabs__
    setlocal modifiable
    normal! ggdG
    " setlocal filetype=potionbytecode
    setlocal buftype=nofile
    nnoremap <buffer> <CR> :call GrabTabChoice()<CR>

    " Insert the tab list.
    call append(0, tablist)

    " remove the trailing newline and return to top of file
    execute ":normal Gddgg"

    setlocal nomodifiable
endfunction

function! GrabTabChoice()
  execute ":normal ^yi["
  let g:current_selected_tab = getreg(0)
  close
endfunction

function! ReloadTab()
  if !exists("g:current_selected_tab")
    call ChangeCurrentTab()
    call GrabTabChoice()
  endif

  execute "!chrome-cli reload -t " . g:current_selected_tab
endfunction

noremap <localleader>c :call ReloadTab()<CR><CR>
noremap <localleader>x :call ChangeCurrentTab()<CR>
