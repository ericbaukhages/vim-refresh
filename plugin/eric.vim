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

if !exists("g:chrome_cli_refresh_active_tab")
  let g:chrome_cli_refresh_active_tab = 0
endif

function! GrabTabList()
  let tablist = systemlist(g:chrome_cli_command . " list tabs")
  return tablist
endfunction

function! ChangeCurrentTab()
    " Get the tab list.
    let tablist = GrabTabList()
    let tablist = ["[0] Current Active Tab"] + tablist

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
  let tabInfo = split(getreg(0), ":")
  if len(tabInfo) == 1
    let g:current_selected_tab = tabInfo[0]
  else
    let g:current_selected_tab = tabInfo[1]
  endif

  if g:current_selected_tab ==# 0
    let g:chrome_cli_refresh_active_tab = 1
  else
    let g:chrome_cli_refresh_active_tab = 0
  endif
  bdelete
endfunction

function! ReloadTab()
  if g:chrome_cli_refresh_active_tab == 1 || !exists("g:current_selected_tab")
    execute "!chrome-cli reload"
  else
    execute "!chrome-cli reload -t " . g:current_selected_tab
  endif
endfunction

noremap <localleader>c :call ReloadTab()<CR><CR>
noremap <localleader>x :call ChangeCurrentTab()<CR>
