vim.cmd [[
try
    colorscheme gruvbox
    highlight Normal guibg=none
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    set background=dark
endtry
]]
