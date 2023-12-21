return {
	'folke/lazy.nvim',
	{
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	},
	{
		'folke/tokyonight.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			require('tokyonight').setup({
				style = 'storm',
				transparent = true
			})
			vim.cmd [[colorscheme tokyonight]]
		end
	},
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
	{ -- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
		config = function()
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'

			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert {
					['<C-d>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<CR>'] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				},
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
				},
			}
		end
	},
	{ -- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup {
				-- Add languages to be installed here that you want installed for treesitter
				ensure_installed = {
					'c',
					'cpp',
					'go',
					'lua',
					'python',
					'rust',
					'typescript',
					'javascript',
					'vim',
					'nix',
					'ocaml',
					'bash',
					'swift',
					'terraform',
					'yaml',
					'json',
					'dockerfile',
					'gitignore',
					'markdown'
				},

				highlight = { enable = true },
				indent = { enable = true, disable = { 'python' } },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = '<c-space>',
						node_incremental = '<c-space>',
						scope_incremental = '<c-s>',
						node_decremental = '<c-backspace>',
					},
				},
			}
		end
	},
	{ -- Additional text objects via treesitter
		'nvim-treesitter/nvim-treesitter-textobjects',
		dependencies = 'nvim-treesitter',
		config = function()
			require('nvim-treesitter.configs').setup({
				textobjects = {
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["a="] = { query = "@assignment.outer", desc =
							"Select outer part of an assignment" },
							["i="] = { query = "@assignment.inner", desc =
							"Select inner part of an assignment" },
							["l="] = { query = "@assignment.lhs", desc =
							"Select left hand side of an assignment" },
							["r="] = { query = "@assignment.rhs", desc =
							"Select right hand side of an assignment" },

							-- works for javascript/typescript files (custom capture I created in after/queries/ecma/textobjects.scm)
							["a:"] = { query = "@property.outer", desc =
							"Select outer part of an object property" },
							["i:"] = { query = "@property.inner", desc =
							"Select inner part of an object property" },
							["l:"] = { query = "@property.lhs", desc =
							"Select left part of an object property" },
							["r:"] = { query = "@property.rhs", desc =
							"Select right part of an object property" },

							["aa"] = { query = "@parameter.outer", desc =
							"Select outer part of a parameter/argument" },
							["ia"] = { query = "@parameter.inner", desc =
							"Select inner part of a parameter/argument" },

							["ai"] = { query = "@conditional.outer", desc =
							"Select outer part of a conditional" },
							["ii"] = { query = "@conditional.inner", desc =
							"Select inner part of a conditional" },

							["al"] = { query = "@loop.outer", desc =
							"Select outer part of a loop" },
							["il"] = { query = "@loop.inner", desc =
							"Select inner part of a loop" },

							["af"] = { query = "@call.outer", desc =
							"Select outer part of a function call" },
							["if"] = { query = "@call.inner", desc =
							"Select inner part of a function call" },

							["am"] = { query = "@function.outer", desc =
							"Select outer part of a method/function definition" },
							["im"] = { query = "@function.inner", desc =
							"Select inner part of a method/function definition" },

							["ac"] = { query = "@class.outer", desc =
							"Select outer part of a class" },
							["ic"] = { query = "@class.inner", desc =
							"Select inner part of a class" },
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
							["<leader>n:"] = "@property.outer", -- swap object property with next
							["<leader>nm"] = "@function.outer", -- swap function with next
						},
						swap_previous = {
							["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
							["<leader>p:"] = "@property.outer", -- swap object property with prev
							["<leader>pm"] = "@function.outer", -- swap function with previous
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]f"] = { query = "@call.outer", desc =
							"Next function call start" },
							["]m"] = { query = "@function.outer", desc =
							"Next method/function def start" },
							["]c"] = { query = "@class.outer", desc = "Next class start" },
							["]i"] = { query = "@conditional.outer", desc =
							"Next conditional start" },
							["]l"] = { query = "@loop.outer", desc = "Next loop start" },

							-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
							-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
							["]s"] = { query = "@scope", query_group = "locals", desc =
							"Next scope" },
							["]z"] = { query = "@fold", query_group = "folds", desc =
							"Next fold" },
						},
						goto_next_end = {
							["]F"] = { query = "@call.outer", desc = "Next function call end" },
							["]M"] = { query = "@function.outer", desc =
							"Next method/function def end" },
							["]C"] = { query = "@class.outer", desc = "Next class end" },
							["]I"] = { query = "@conditional.outer", desc =
							"Next conditional end" },
							["]L"] = { query = "@loop.outer", desc = "Next loop end" },
						},
						goto_previous_start = {
							["[f"] = { query = "@call.outer", desc =
							"Prev function call start" },
							["[m"] = { query = "@function.outer", desc =
							"Prev method/function def start" },
							["[c"] = { query = "@class.outer", desc = "Prev class start" },
							["[i"] = { query = "@conditional.outer", desc =
							"Prev conditional start" },
							["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
						},
						goto_previous_end = {
							["[F"] = { query = "@call.outer", desc = "Prev function call end" },
							["[M"] = { query = "@function.outer", desc =
							"Prev method/function def end" },
							["[C"] = { query = "@class.outer", desc = "Prev class end" },
							["[I"] = { query = "@conditional.outer", desc =
							"Prev conditional end" },
							["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
						},
					},
				},
			})
		end
	},
	-- Git related plugins
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
	}, -- Add indentation guides even on blank lines
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	},            -- "gc" to comment visual regions/lines
	'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
	-- Fuzzy Finder (files, lsp, etc)
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.4',
		dependencies = {
			'nvim-lua/plenary.nvim'
		},
		config = function()
			require('telescope').setup {
				defaults = {
					file_ignore_patterns = {
						'venv', '__pycache__'
					},
					mappings = {
						i = {
							['<C-u>'] = false,
							['<C-d>'] = false,
						},
					},
					layout_strategy = 'vertical',
				},
			}

			-- Enable telescope fzf native, if installed
			pcall(require('telescope').load_extension, 'fzf')

			-- See `:help telescope.builtin`
			vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,
				{ desc = '[?] Find recently opened files' })
			vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,
				{ desc = '[ ] Find existing buffers' })
			vim.keymap.set('n', '<leader>/', function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes')
				.get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end, { desc = '[/] Fuzzily search in current buffer]' })

			vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files,
				{ desc = '[S]earch [F]iles' })
			vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags,
				{ desc = '[S]earch [H]elp' })
			vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string,
				{ desc = '[S]earch current [W]ord' })
			vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep,
				{ desc = '[S]earch by [G]rep' })
			vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics,
				{ desc = '[S]earch [D]iagnostics' })
		end
	},
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build =
		'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
	},
	-- File tree
	{
		'nvim-tree/nvim-tree.lua',
		config = function()
			require("nvim-tree").setup()
		end
	},
	-- Tmux
	{
		'alexghergh/nvim-tmux-navigation',
		config = function()
			require 'nvim-tmux-navigation'.setup {
				disable_when_zoomed = true, -- defaults to false
				keybindings = {
					left = "<C-h>",
					down = "<C-j>",
					up = "<C-k>",
					right = "<C-l>",
					last_active = "<C-\\>",
					next = "<C-Space>",
				}
			}
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
	'navarasu/onedark.nvim',
	'craftzdog/solarized-osaka.nvim'
}
