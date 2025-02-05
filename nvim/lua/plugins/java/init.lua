return {
  "nvim-java/nvim-java",
  config = false,
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      opts = {
        inlay_hints = { enabled = false },
        servers = {
          jdtls = {
            -- Your custom jdtls settings goes here
            handlers = {
              -- By assigning an empty function, you can remove the notifications
              -- printed to the cmd
              ["$/progress"] = function(_, result, ctx) end,
            },
            java = {
              completion = {
                favoriteStaticMembers = {
                  "org.assertj.core.api.Assertions.*",
                  "org.assertj.core.configuration.Services.*",
                  "org.mockito.BDDMockito.*",
                  "org.mockito.Mockito.*",
                  "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
                  "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
                },
              },
            },
          },
        },
        setup = {
          jdtls = function()
            require("java").setup({
              -- Your custom nvim-java configuration goes here
            })
          end,
        },
      },
    },
  },
}
