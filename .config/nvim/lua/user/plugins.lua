local fn = vim.fn
local is_mac = vim.fn.has("macunix")

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

---@diagnostic disable-next-line: missing-parameter
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    -- snapshot = "july-24",
    snapshot_path = fn.stdpath "config" .. "/snapshots",
    max_jobs = 50,
    display = {
        open_fn = function()
        return require("packer.util").float { border = "rounded" }
        end,
        prompt_border = "rounded", -- Border style of prompt popups.
    },
}

-- Install your plugins here
return packer.startup(function(use)
    
    -- Plugin Mangager
    use "wbthomason/packer.nvim" -- Have packer manage itself

    -- Fuzzy Finder/Telescope
    use "nvim-telescope/telescope.nvim"
    use "tamago324/lir.nvim"
    -- Lua Development
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
    use "nvim-lua/popup.nvim"
    use "christianchiarulli/lua-dev.nvim"

    -- LSP
    use "neovim/nvim-lspconfig" -- enable LSP
    if is_mac then
        use "williamboman/nvim-lsp-installer"
    end
    use "onsails/lspkind-nvim"
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    
    use "ray-x/lsp_signature.nvim"
    use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
    use "RRethy/vim-illuminate"
    use { "lvimuser/lsp-inlayhints.nvim"}

    -- LSP Languages
    use "b0o/SchemaStore.nvim"

    -- Completion
    -- use "christianchiarulli/nvim-cmp"
    use "hrsh7th/nvim-cmp" --completion
    use "hrsh7th/cmp-buffer" -- buffer completions
    use "hrsh7th/cmp-path" -- path completions
    use "hrsh7th/cmp-cmdline" -- cmdline completions
    use "hrsh7th/cmp-emoji"
    use "hrsh7th/cmp-nvim-lua"
    use "hrsh7th/cmp-nvim-lsp"
    use "zbirenbaum/copilot-cmp"
    -- use { "tzachar/cmp-tabnine", run = "./install.sh" , requires = "hrsh7th/nvim-cmp"}
    use "saadparwaiz1/cmp_luasnip" -- snippet completions

    -- Snippet
    use "L3MON4D3/LuaSnip" --snippet engine
    use "rafamadriz/friendly-snippets" -- a bunch of snippets to use
    
    -- Syntax/Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }

    -- Color Schemes
    use "morhetz/gruvbox"
    use "lunarvim/onedarker.nvim"

    -- Icon
    use "kyazdani42/nvim-web-devicons"

    -- Alpha
    use "goolord/alpha-nvim"
	
    -- Git
	use "lewis6991/gitsigns.nvim"
    
    -- Debugger
    use 'mfussenegger/nvim-dap'
    
    -- Java
    use 'mfussenegger/nvim-jdtls'

    --Others TODO need to rearrange
    use "windwp/nvim-autopairs"-- Autopairs, integrates with both cmp and treesitter
	use "numToStr/Comment.nvim"
	use "JoosepAlviste/nvim-ts-context-commentstring"
	use "kyazdani42/nvim-tree.lua"
	use "akinsho/bufferline.nvim"
	use "moll/vim-bbye"
	use "nvim-lualine/lualine.nvim"
	use "akinsho/toggleterm.nvim"
	use "ahmedkhalf/project.nvim"
	use "lewis6991/impatient.nvim"
	use "lukas-reineke/indent-blankline.nvim"
	use "folke/which-key.nvim"

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
