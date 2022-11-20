--
-- COLOR SCHEME
--

local v = vim


-- GRUVBOX SETUP {{{
-- setup must be called before loading the colorscheme
-- Default options:
-- require("nord").setup({
--   undercurl = true,
--   underline = true,
--   bold = true,
--   italic = false,
--   strikethrough = true,
--   invert_selection = false,
--   invert_signs = false,
--   invert_tabline = false,
--   invert_intend_guides = false,
--   inverse = true, -- invert background for search, diffs, statuslines and errors
--   contrast = "", -- can be "hard", "soft" or empty string
--   overrides = {},
-- })
-- }}}

-- {{{ NORD SETUP
-- Example config in lua
v.g.nord_contrast = true
v.g.nord_borders = true
v.g.nord_disable_background = false
v.g.nord_italic = false
v.g.nord_uniform_diff_background = true
v.g.nord_bold = false
-- }}}

-- Load the colorscheme
require('nord').set()
