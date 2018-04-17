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

if !exists("g:current_selected_tab")
  let g:current_selected_tab = 2
endif

function! ReloadTab()
  execute "!chrome-cli reload -t " . g:current_selected_tab
endfunction

" let g:chrome_tabs = systemlist("chrome-cli list tabs | sed 's/.*\[\([^]]*\)\].*/\1/g'")
function! ShowAvailableTabs()
    " Get the tab list.
    let tablist = system(g:chrome_cli_command . " list tabs")

    " Open a new split and set it up.
    vsplit __Chrome_Tabs__
    normal! ggdG
    " setlocal filetype=potionbytecode
    setlocal buftype=nofile
    nnoremap <buffer> <CR> :call GrabTabChoice()<CR>

    " Insert the tab list.
    call append(0, split(tablist, '\v\n'))

    setlocal nomodifiable
endfunction

function! GrabTabChoice()
  set relativenumber!
endfunction

map <localleader>c :call ReloadTab()<CR>
map <localleader>x :call ShowAvailableTabs()<CR>
