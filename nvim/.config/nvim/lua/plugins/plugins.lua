return {
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			{ 'j-hui/fidget.nvim', tag = 'legacy' },
			'folke/neodev.nvim',
		},
	},
	'jose-elias-alvarez/null-ls.nvim',
	{
		'L3MON4D3/LuaSnip',
		version = 'v2.*',
		build = 'make install_jsregexp'
	},
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require('gitsigns').setup {
				signs = {
					add = { text = '+' },
					change = { text = '~' },
					delete = { text = '_' },
					topdelete = { text = '‾' },
					changedelete = { text = '~' },
				},
			}
		end
	},
	{
		'nvim-lualine/lualine.nvim',
		config = function()
			require('lualine').setup {
				options = {
					icons_enabled = true,
					theme = 'tokyonight',
					component_separators = '|',
					section_separators = '',
				},
			}
		end
	}, -- Fancier statusline
	{
		'lukas-reineke/indent-blankline.nvim',
		config = function()
			require('ibl').setup {
				indent = { char = '┊' },
			}
		end
	},
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	},
	'tpope/vim-sleuth',
	{
		'nvim-tree/nvim-tree.lua',
		config = function()
			require("nvim-tree").setup()
		end
	},
	{
		'j-hui/fidget.nvim',
		config = function()
			require('fidget').setup()
		end
	},
	{
		'folke/neodev.nvim',
		config = function()
			require('neodev').setup()
		end
	},
}
