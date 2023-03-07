# Dotfiles

This repo contains configuration details for command line utilities; namely, `nvim` and `tmux` as
they require the most elaborate configuration. 

# How this all works
The target for each directory is: `~/.config/<utility>` on the actual filesystem where
we will be using said files.

To ensure that the proper linking is done, each `<utility>` is written in this repo as if 
it existed in `~/.config/<utility>`: `<utility>/.config/<utility>`.

When we change the dotfiles in any way -- as tracked by git in this repo -- we can easily run 
`stow <utility>` from the root of this repo, to sync the changes to our target machine.

This command creates a symlink from our repo to the target path on our home machine.

To stow all files at once, run `stow */` to get only directories not the readme.

If there are files that already exist in the target prior to running stow, you must run `stow --adopt <utility>` so that the symlink is correctly initialized -- more on this in the manpage of stow.

# TODOS

## nvim
- [ ] move packer setup + sync logic out of init.lua and into plugin-setup.lua
	- [x] treesitter
	- [x] telescope
	- [ ] packer
	- [x] nvim-tree
	- [x] lualine
	- [x] gitsigns
	- [ ] harpoon (still need to use this)
	- [x] indent_blankline
	- [ ] colorscheme (tokyonight)
	- [x] comment
- [ ] modularize LSP config
- [ ] create configuration files for each plugin under `lua/plugins/`
- [ ] find the correct place for autogroups
- [ ] add /plugins directory with packer_compiled.lua to git repo 
