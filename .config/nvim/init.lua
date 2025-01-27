-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("user.copy_buffers")
vim.api.nvim_set_option("clipboard", "unnamed")
