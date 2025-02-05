return {
  "NachoNievaG/atac.nvim",
  dependencies = { "akinsho/toggleterm.nvim" },
  config = function()
    require("atac").setup({
      dir = "~/Library/'Application Support'/com.Julien-cpsn.ATAC",
    })
  end,
}
