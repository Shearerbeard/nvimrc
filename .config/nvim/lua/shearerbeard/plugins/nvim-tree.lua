return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	priority = 999,
	config = function ()	
		-- empty setup using defaults
		require("nvim-tree").setup()
	end
}
