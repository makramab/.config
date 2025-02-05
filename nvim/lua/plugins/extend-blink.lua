return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "default",
      ["<C-;>"] = { -- Replace <Tab> with <C-I>
        LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
        "fallback",
      },
      ["<Tab>"] = {
        LazyVim.cmp.map({ "snippet_forward" }),
        "fallback",
      },
    },
  },
}
