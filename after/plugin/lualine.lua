require("lualine").setup({
    sections = {
        lualine_x = { require("yaml_nvim").get_yaml_key_and_value },
        -- etc
    }
})
