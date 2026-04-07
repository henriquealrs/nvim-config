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

local function get_highlight(name)
    local ok, highlight = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if not ok then
        return nil
    end

    return highlight
end

local function to_hex(color)
    if type(color) == "number" then
        return string.format("#%06x", color)
    end

    return color
end

local function copy_text_style(source, target)
    if source.italic ~= nil then
        target.italic = source.italic
    end
    if source.bold ~= nil then
        target.bold = source.bold
    end
    if source.underline ~= nil then
        target.underline = source.underline
    end
    if source.strikethrough ~= nil then
        target.strikethrough = source.strikethrough
    end
end

local function set_comment_and_git_blame_highlights()
    local comment = get_highlight("Comment")
    if comment and comment.fg then
        local brighter_comment = { fg = brighten(to_hex(comment.fg), 22) }
        copy_text_style(comment, brighter_comment)
        brighter_comment.italic = true
        vim.api.nvim_set_hl(0, "Comment", brighter_comment)
    end

    local git_blame = {
        fg = "#7aa2f7",
        italic = false,
        nocombine = true,
    }

    local diagnostic_hint = get_highlight("DiagnosticHint")
    if diagnostic_hint and diagnostic_hint.fg then
        git_blame.fg = to_hex(diagnostic_hint.fg)
    end

    vim.api.nvim_set_hl(0, "GitBlameInline", git_blame)
end

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_comment_and_git_blame_highlights,
})

set_comment_and_git_blame_highlights()
