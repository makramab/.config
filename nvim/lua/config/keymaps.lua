-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- LazyDocker binding
if vim.fn.executable("lazydocker") == 1 then
  vim.keymap.set("n", "<leader>gd", function()
    Snacks.terminal("lazydocker", { esc_esc = false, ctrl_hjkl = false })
  end, { desc = "Lazydocker" })
end

-- ############################################################################

-- Refresh the images in the current buffer
-- Useful if you delete an actual image file and want to see the changes
-- without having to re-open neovim
vim.keymap.set("n", "<leader>ir", function()
  -- First I clear the images
  -- I'm using [[ ]] to escape the special characters in a command
  vim.cmd([[lua require("image").clear()]])
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  print("Images refreshed")
end, { desc = "Refresh images" })

-- ###################################################<Tab>i#########################

-- Set up a keymap to clear all images in the current <Tab>ibuffer
vim.keymap.set("n", "<leader>ic", function()
  -- This is the command that clears the images
  -- I'm using [[ ]] to escape the special characters <Tab>iin a command
  vim.cmd([[lua require("image").clear()]])
  print("Images cleared")
end, { desc = "Clear images" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<leader>iy", function()
      local closest_image_position_signed = 999
      local closest_image_position = 999
      local closest_image_path = ""
      for i, image in ipairs(require("image").get_images()) do
        local current_image_position_signed = vim.api.nvim_win_get_cursor(0)[1] - image.geometry.y
        local current_image_position = math.abs(current_image_position_signed)
        if current_image_position < closest_image_position then
          closest_image_position = current_image_position
          closest_image_position_signed = current_image_position_signed
          closest_image_path = image.path
        end
      end
      local image_sign_pointer = ""
      if closest_image_position_signed <= 1 then
        image_sign_pointer = "↓"
      else
        image_sign_pointer = "↑"
      end
      local command =
        string.format([[osascript -e 'set the clipboard to (read (POSIX file "%s") as picture)']], closest_image_path)
      vim.fn.system(command)

      local successMessage =
        string.format([[Closest image %s has been successfully copied to the clipboard!]], image_sign_pointer)

      vim.notify(successMessage)
    end, { desc = "Copy closest image to clipboard" })
  end,
})

vim.keymap.set("n", "<leader>it", function()
  require("diagram").toggle()
end, { noremap = true, silent = true, desc = "Toggle D<Tab>iiagram" })

vim.keymap.set("n", "<C-;>", function()
  vim.notify("Control+I Pressed!")
end, { noremap = true, silent = true })
