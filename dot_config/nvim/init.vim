"-----------"
"           "
"  General  "
"           "
"-----------"

" Leader key.
let mapleader = ";"

" Disable older Vi.
set nocompatible

" Maximum cached history.
set history=100

" Auto read when a file is changed from the outside.
set autoread

" Auto write when a file is being built.
set autowrite

" Hide mode status info.
set noshowmode

" Set true terminal colors.
set termguicolors

"-----------"
"           "
"  Plugins  "
"           "
"-----------"

" Install vim-plug, if needed.
if empty(glob('~/.nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.nvim/plugged')

" General plugins.
Plug 'neovim/nvim-lspconfig'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } 
Plug 'vim-airline/vim-airline'
Plug 'bluz71/vim-moonfly-colors'
Plug 'cespare/vim-toml'
Plug 'junegunn/fzf.vim'

" Git helpers.
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Development plugins.
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'rust-lang/rust.vim'
Plug 'SirVer/ultisnips'

" Better autocomplete, signature
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'ray-x/lsp_signature.nvim'

call plug#end()

"------------"
" Git Gutter "
"------------"

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modifed = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_removed_above_and_below = '|'
let g:gitgutter_sign_modified_removed = '*'

"--------------"
" NERDTree Git "
"--------------"

let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'+',
                \ 'Staged'    :'^',
                \ 'Untracked' :'*',
                \ 'Renamed'   :'~',
                \ 'Unmerged'  :'=',
                \ 'Deleted'   :'-',
                \ 'Dirty'     :'+',
                \ 'Ignored'   :'.',
                \ 'Clean'     :'.',
                \ 'Unknown'   :'?',
                \ }

"----------"
" NERDTree "
"----------"

" Open file manager on enter.
autocmd VimEnter * NERDTree

" Open / close file NERD Tree.
nnoremap <leader>o :NERDTreeToggle<cr>

"--------"
" vim-go "
"--------"

" Show the name of each failed test before the errors and logs output by the
" test
let g:go_test_show_name = 1

" Increase default timeout for the tests.
let g:go_test_timeout = '2m'

" Highlight all uses of the indetifier under the cursor.
let g:go_auto_sameids = 0

" Run extended linter on save.
let g:go_metalinter_autosave = 0
let g:go_metalinter_command = "golangci-lint"

" Highlighting of various syntax objects.
let g:go_highlight_operators = 1
let g:go_highlight_types = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1

" We only want to use vim-go for GoTest and etc.
let g:go_pls_enabled = 0

augroup gobindings
	autocmd! gobindings

	" Run tests in selected package.
	autocmd FileType go nmap <buffer> <leader>t <Plug>(go-test)

	" Rename object under the cursor.
	autocmd FileType go nmap <buffer> <leader>r <Plug>(go-rename)

	" Toggle code coverage.
	autocmd FileType go nmap <buffer> <leader>c <Plug>(go-coverage-toggle)

	" Run only the test that is under the cursor.
	autocmd FileType go nmap <buffer> <leader>ft <Plug>(go-test-func)
augroup end

"------------"
"            "
"  Keybinds  "
"            "
"------------"

" Prevent arrows usage in all modes.
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" Better buffer navigation.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Open new vertical buffer.
nnoremap <leader>l :vsplit<cr>

"------"
"      "
"  UI  "
"      "
"------"


" Width of tab character.
set tabstop=8
set shiftwidth=8
set softtabstop=8

" Set formatting.
set formatoptions -=t

" Theme
syntax enable
colorscheme moonfly

exec 'highlight SpecialKey ctermbg=bg ctermfg=236 guibg=bg guifg=#303030'

let g:moonflyCursorColor = 1

" Show options when pressing tab in command-line.
set wildmenu

" Highlight current line.
set cursorline

" Don't convert tabs to spaces.
set noexpandtab

" Add separator break.
set colorcolumn=79

" Don't automatically wrap lines.
set nowrap

" Leave 15 lines above and below when scrolling.
set scrolloff=15

" Show command matches.
set incsearch

" Display TAB as characters.
set list
set listchars=tab:>~,trail:.

" Display line numbers.
set nu

" Set encoding.
set encoding=UTF-8

"---------"
"         "
"  Files  "
"         "
"---------"

" Disable file backups.
set nobackup

" Disable swap files creation.
set noswapfile

" Make nvim store the undo history in a file.
set undofile

" Create undo directory.
if !isdirectory($HOME.'/.nvim/undo')
	call mkdir($HOME.'/.nvim/undo', 'p', 0700)
endif

" Set undo file location.
set undodir=~/.nvim/undo

" Lua.
lua << EOF
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { noremap=true, silent=true }

	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
end

local cmp = require('cmp')
cmp.setup{
	mapping = {
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<C-y>'] = cmp.config.disable,
		["<C-n>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback() 
			end
		end, { "i", "s" }),
		["<C-p>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" })
	},
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' }, 
		{ name = 'ultisnips' },
	})
}

require('lsp_signature').setup({})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

nvim_lsp.vuels.setup{}

nvim_lsp.gopls.setup{
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		gopls = {
			buildFlags = { '-tags='}
		}
	}
}
EOF
