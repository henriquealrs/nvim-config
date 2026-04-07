# Repository Guidelines

## Project Structure & Module Organization
This repository is a Neovim configuration written in Lua.
- `init.lua`: entrypoint; loads core config and sets the active colorscheme.
- `lua/config/`: base editor behavior (options, keymaps, plugin manager bootstrap).
- `lua/plugins/`: Lazy.nvim plugin specs and plugin-specific options.
- `after/plugin/`: post-load runtime configuration for plugins.
- `lazy-lock.json`: pinned plugin versions; update intentionally.

Prefer adding new plugin declarations in `lua/plugins/<plugin>.lua` and keeping plugin runtime mappings/setup in `after/plugin/<plugin>.lua` when it improves clarity.

## Build, Test, and Development Commands
No Makefile/test runner is defined; validate changes through headless Neovim checks.
- `nvim --headless "+Lazy! sync" +qa`: install/update plugins from specs.
- `nvim --headless "+checkhealth" +qa`: run Neovim health checks.
- `nvim --headless "+lua vim.cmd('qa')"`: quick startup sanity check.
- `nvim`: interactive verification of mappings, LSP, Treesitter, Telescope, DAP, etc.

If plugin specs change, review `lazy-lock.json` diff before committing.

## Coding Style & Naming Conventions
- Language: Lua.
- Indentation: 4 spaces, no tabs (`expandtab`, `shiftwidth=4`).
- Keep modules small and focused; one plugin spec per file in `lua/plugins/`.
- File naming: lowercase snake_case (examples: `dap_python.lua`, `blink_cmp.lua`).
- Keymaps and global options belong in `lua/config/remap.lua` and `lua/config/set.lua` unless plugin-specific.

## Testing Guidelines
There is no automated unit/integration test suite in this repo.
- Treat `checkhealth` + headless startup as the minimum gate.
- For plugin changes, test the exact workflow manually (example: DAP breakpoints, Telescope pickers, LSP attach).
- Capture regressions by reproducing in a clean session: `nvim --clean -u init.lua`.

## Commit & Pull Request Guidelines
Recent history favors short, imperative commit subjects (examples: `Fix tree-sitter on ubuntu`, `Replace nvim-cmp with blink.cmp`).
- Commit format: concise imperative summary; avoid vague messages except for true WIP branches.
- PRs should include: goal, key files changed, manual validation steps, and any breaking behavior changes.
- Link related issues and include screenshots/GIFs when UI behavior changes are visible.
