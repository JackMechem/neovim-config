return {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false,
    init = function()
        -- The nvim-treesitter main branch puts queries under runtime/queries/
        -- but only the plugin root is on rtp, so we add the runtime/ subdir manually
        local ts_runtime = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime"
        if vim.fn.isdirectory(ts_runtime) == 1 then
            vim.opt.runtimepath:prepend(ts_runtime)
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "rust",
            callback = function(ev)
                pcall(vim.treesitter.start, ev.buf)
            end,
        })
    end,
}
