-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'folke/zen-mode.nvim',
  config = function()
    vim.keymap.set('n', '<leader>zz', function()
      require('zen-mode').setup {
        window = {
          width = 90,
          options = {},
        },
      }
      require('zen-mode').toggle()
      vim.wo.wrap = false
      vim.wo.number = true
      vim.wo.rnu = true
    end)

    vim.keymap.set('n', '<leader>zZ', function()
      require('zen-mode').setup {
        window = {
          width = 80,
          options = {},
        },
      }
      require('zen-mode').toggle()
      vim.wo.wrap = false
      vim.wo.number = false
      vim.wo.rnu = false
      vim.opt.colorcolumn = '0'
    end)
  end,
}
