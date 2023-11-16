return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	config = function ()	
		-- empty setup using defaults
		require("nvim-tree").setup()
		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>tt", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set("n", "<leader>tc", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
		keymap.set("n", "<leader>tc", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
		keymap.set("n", "<leader>tr", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
	end
}
