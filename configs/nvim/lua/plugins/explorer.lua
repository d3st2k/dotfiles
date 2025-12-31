-- Explorer configurations
return {
	"folke/snacks.nvim",
	---@type snacks.Config
	opts = {
		picker = {
			hidden = true,
			ignored = true,
			sources = {
				explorer = {
					layout = {
						layout = {
							position = "right",
						},
					},
				},
			},
		},
	},
}
