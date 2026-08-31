# Neovim Configuration

This repository contains a Lua-based Neovim configuration managed with
`lazy.nvim`.

## Key notation

- `<leader>` is `Space`.
- `<localleader>` is `\`.
- Modes: `N` = normal, `I` = insert, `V` = visual, `O` = operator-pending,
  and `T` = terminal.
- A scope of **buffer** means that the mapping is available only when its
  plugin or filetype is attached to the current buffer.

## General editing

| Mapping | Mode | Action |
| --- | --- | --- |
| `<leader>pv` | N | Open the built-in file explorer. |
| `J` | V | Move the selected lines down. |
| `K` | V | Move the selected lines up. |
| `J` | N | Invoke the current `K` action while restoring the cursor position. |
| `n` | N | Jump to the next search result and center it. |
| `N` | N | Jump to the previous search result and center it. |
| `<leader>p` | V | Paste without replacing the current yank register. |
| `Q` | N | Disabled. |
| `<leader>ct` | N, V | Remove trailing whitespace. |
| `<leader>hs` | N | Highlight and match trailing whitespace. |
| `<A-j>` | N | Go to the next quickfix entry. |
| `<A-k>` | N | Go to the previous quickfix entry. |

## Windows and terminals

| Mapping | Mode | Action |
| --- | --- | --- |
| `<leader>ws` | N | Open a horizontal split. |
| `<leader>wv` | N | Open a vertical split. |
| `<leader>t` | N | Toggle a floating terminal; a count selects the terminal number. |
| `<Esc>` | T | Leave terminal mode. |

## Search and Telescope

| Mapping | Mode | Action |
| --- | --- | --- |
| `<leader>pf` | N | Find files. |
| `<C-p>` | N | Find Git-tracked files. |
| `<C-b>` | N | Search open buffers. |
| `<leader>ps` | N | Prompt for text and grep the project. |
| `<leader>pm` | N | Live multi-grep; separate search and globs with ` @ `. |
| `<leader>pw` | N | Live whole-word grep with optional ` @ ` globs. |
| `<leader>ep` | N | Find files in the installed Lazy plugins directory. |

## LSP and diagnostics

The navigation and action mappings are buffer-local and become available after
an LSP client attaches. The diagnostic popup is global.

| Mapping | Mode | Scope | Action |
| --- | --- | --- | --- |
| `K` | N | LSP buffer | Show hover documentation; Rust provides its own hover action. |
| `gd` | N | LSP buffer | Go to definition. |
| `gD` | N | LSP buffer | Go to declaration. |
| `gi` | N | LSP buffer | Go to implementation. |
| `go` | N | LSP buffer | Go to type definition. |
| `gr` | N | LSP buffer | List references. |
| `gs` | N | LSP buffer | Show signature help. |
| `<F2>` | N | LSP buffer | Rename symbol. |
| `<F3>` | N, V | LSP buffer | Format asynchronously. |
| `<F4>` | N | LSP buffer | Show code actions. |
| `<leader>di` | N | Global | Open diagnostics for the item under the cursor. |

## Debugging with DAP

| Mapping | Mode | Action |
| --- | --- | --- |
| `<F5>` | N | Start or continue debugging. |
| `<F10>` | N | Step over. |
| `<F11>` | N | Step into. |
| `<F12>` | N | Step out. |
| `<leader>b` | N | Toggle a breakpoint. |
| `<leader>B` | N | Set a conditional breakpoint. |
| `<leader>du` | N | Toggle the DAP UI. |

## Git and Gitsigns

Gitsigns mappings are buffer-local to Git-controlled buffers. In Python
buffers, `[c` and `]c` may instead use the cell-navigation mappings described
below.

| Mapping | Mode | Action |
| --- | --- | --- |
| `]c` | N | Go to the next hunk, or use native diff navigation in diff mode. |
| `[c` | N | Go to the previous hunk, or use native diff navigation in diff mode. |
| `<leader>ha` | N, V | Stage the current hunk or selected range. |
| `<leader>hr` | N, V | Reset the current hunk or selected range. |
| `<leader>hS` | N | Stage the entire buffer. |
| `<leader>hR` | N | Reset the entire buffer. |
| `<leader>hp` | N | Preview the current hunk. |
| `<leader>hi` | N | Preview the current hunk inline. |
| `<leader>hb` | N | Show full blame information for the current line. |
| `<leader>hd` | N | Diff against the index. |
| `<leader>hD` | N | Diff against the previous revision. |
| `<leader>hQ` | N | Add hunks from all buffers to the quickfix list. |
| `<leader>hq` | N | Add hunks from the current buffer to the quickfix list. |
| `<leader>tb` | N | Toggle current-line blame. |
| `<leader>tw` | N | Toggle word-level diff highlighting. |
| `ih` | O, V | Select a Git hunk. |
| `<leader>gb` | N | Toggle inline Git blame. |

## Harpoon, symbols, and history

| Mapping | Mode | Scope | Action |
| --- | --- | --- | --- |
| `<leader>a` | N | Global | Add the current file to Harpoon. |
| `<C-e>` | N | Global | Toggle the Harpoon quick menu. |
| `<C-h>` | N | Global | Open Harpoon file 1. |
| `<C-t>` | N | Global | Open Harpoon file 2. |
| `<C-n>` | N | Global | Open Harpoon file 3. |
| `<C-s>` | N | Global | Open Harpoon file 4. |
| `<leader>ol` | N | Global | Toggle the Aerial symbols outline. |
| `{` | N | Aerial-attached buffer | Jump to the previous symbol. |
| `}` | N | Aerial-attached buffer | Jump to the next symbol. |
| `<leader>u` | N | Global | Toggle the undo tree. |

## Comments

| Mapping | Mode | Action |
| --- | --- | --- |
| `gcc` | N | Toggle a line comment. |
| `gbc` | N | Toggle a block comment. |
| `gc{motion}` | N, O | Toggle line comments over a motion. |
| `gb{motion}` | N, O | Toggle block comments over a motion. |
| `gc` | V | Toggle line comments for the selection. |
| `gb` | V | Toggle block comments for the selection. |
| `gcO` | N | Add a comment on the line above. |
| `gco` | N | Add a comment on the line below. |
| `gcA` | N | Add a comment at the end of the line. |

## Completion with Blink

| Mapping | Mode | Action |
| --- | --- | --- |
| `<C-Space>` | I | Open completion, or documentation when completion is already open. |
| `<C-n>` / `<C-p>` | I | Select the next or previous completion item. |
| `<Down>` / `<Up>` | I | Select the next or previous completion item. |
| `<C-y>` | I | Accept the selected completion. |
| `<C-e>` | I | Hide completion. |
| `<C-k>` | I | Toggle signature help. |

Terminal completion is enabled for ipybridge's `ipdb` suggestions.

## Python data science and IPython

These buffer-local mappings use `ipybridge.nvim`. The first kernel action
finds the nearest `pyproject.toml` or `uv.lock`, prepares the required Jupyter
packages through `uv`, and launches the IPython console in a right-side split.
Python cells are delimited with `# %%` markers.

| Mapping | Mode | Scope | Action |
| --- | --- | --- | --- |
| `<leader>sp` | N | Python | Toggle the full Spyder-style workspace. |
| `<leader>ti` | N | Python | Toggle the IPython console. |
| `<leader>ii` | N | Python | Focus the IPython console. |
| `<leader>iv` | N, T | Python/IPython | Return to the editor. |
| `<leader>ir` | N, T | Python/IPython | Restart the kernel. |
| `<leader>if` | N | Python | Run the current file. |
| `<leader><CR>` | N | Python | Run the current `# %%` cell. |
| `<F9>` | N | Python | Run the current line. |
| `<F9>` | V | Python | Run the selected lines. |
| `]c` | N, V | Python | Go to the next cell. |
| `[c` | N, V | Python | Go to the previous cell. |
| `<leader>vx` | N, T | Python/IPython | Open the variable explorer. |
| `<leader>vr` | N | Python | Refresh the variable explorer. |
| `<leader>vp` | N | Python | Preview the variable under the cursor. |
| `<C-c>` | T | IPython | Interrupt the running kernel operation. |

The IPython dependencies are supplied as `uv run --with` overlays, so these
editor-only packages are not added to a project's dependency groups.

The full workspace keeps the editor on the left, docks the variable explorer
in a fixed upper-right window, and docks the IPython console below it. The same
layout is also available through `:SpyderToggle`.

## Rust

These mappings are buffer-local to Rust files.

| Mapping | Mode | Action |
| --- | --- | --- |
| `<leader>r` | N | Open grouped rust-analyzer code actions. |
| `K` | N | Open rustaceanvim hover actions. |
| `<leader>rd` | N | Select a debuggable target. |

## C++

This mapping is buffer-local to C++ files.

| Mapping | Mode | Action |
| --- | --- | --- |
| `<leader>r` | N | Open the Tree-sitter C++ tools action picker. |
| `q` | N | Close a Tree-sitter C++ tools preview. |
| `<Enter>` | N | Accept a Tree-sitter C++ tools preview. |
