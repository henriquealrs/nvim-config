local function clamp(value)
    if value < 0 then
        return 0
    end
    if value > 255 then
        return 255
    end
    return value
end

local function brighten(hex_color, amount)
    if type(hex_color) ~= "string" or #hex_color < 7 then
        return hex_color
    end
    local r = tonumber(hex_color:sub(2, 3), 16)
    local g = tonumber(hex_color:sub(4, 5), 16)
    local b = tonumber(hex_color:sub(6, 7), 16)

    if not (r and g and b) then
        return hex_color
    end

    return string.format(
        "#%02x%02x%02x",
        clamp(r + amount),
        clamp(g + amount),
        clamp(b + amount)
    )
end

local function set_comment_brighter()
    local ok, comment = pcall(vim.api.nvim_get_hl, 0, { name = "Comment", link = false })
    if not ok or not comment.fg then
        return
    end

    local fg = string.format("#%06x", comment.fg)
    local brighter = brighten(fg, 22)
    local opts = { fg = brighter }

    if comment.italic ~= nil then
        opts.italic = comment.italic
    end
    if comment.bold ~= nil then
        opts.bold = comment.bold
    end
    if comment.underline ~= nil then
        opts.underline = comment.underline
    end
    if comment.strikethrough ~= nil then
        opts.strikethrough = comment.strikethrough
    end

    vim.api.nvim_set_hl(0, "Comment", opts)
end

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_comment_brighter,
})

set_comment_brighter()
