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
}
