# Gitsigns Cheat Sheet

This config groups most Git hunk actions under `<leader>h`.

Think of it like this:
- `h` means "work on hunks"
- lowercase keys act on the current hunk
- uppercase keys usually act on the whole buffer

## Navigation

### `[c`
Jump to the previous hunk in the current file.

Use this when you want to move backward through changed areas without opening a diff view.

### `]c`
Jump to the next hunk in the current file.

Use this to walk forward through edits one change block at a time.

## Hunk Actions

### `<leader>ha`
Stage the current hunk.

`a` stands for "add". This sends just the current change block to Git's index without staging the whole file.

### Visual `<leader>ha`
Stage only the selected lines.

This is useful when one hunk contains several edits and you want to stage only part of it.

### `<leader>hr`
Reset the current hunk.

This discards the current hunk and restores it from Git's indexed version.

### Visual `<leader>hr`
Reset only the selected lines.

Use this when you want to throw away part of a larger hunk instead of the whole thing.

### `<leader>hS`
Stage the entire buffer.

This stages every hunk in the current file at once.

### `<leader>hR`
Reset the entire buffer.

This discards every unstaged hunk in the current file.

## Preview and Inspection

### `<leader>hp`
Preview the current hunk in a floating window.

Good for checking exactly what changed before you stage or reset it.

### `<leader>hi`
Preview the current hunk inline.

This shows the change directly in the buffer, which can be faster than a popup when you are staying in flow.

### `<leader>hb`
Show full blame for the current line.

Use this when you want to see who changed the line, when they changed it, and the commit message behind it.

### `<leader>hd`
Diff the current file against the index.

This shows what is still unstaged in the file.

### `<leader>hD`
Diff the current file against `~`.

In practice this is a quick way to compare against the previous revision instead of the index.

### `<leader>hq`
Send hunks from the current buffer to the quickfix list.

Use this when you want a navigable list of changes for just the file you are in.

### `<leader>hQ`
Send hunks from all tracked buffers/files to the quickfix list.

Use this when you want a broader worklist across the repo.

## Toggles

### `<leader>tb`
Toggle inline blame for the current line.

This adds or removes a small virtual-text blame annotation while you edit.

### `<leader>tw`
Toggle word diff mode.

This highlights changes inside lines, not just whole changed lines, which helps when edits are small.

## Text Object

### `ih`
Select the current hunk as a text object.

This works in operator-pending and visual contexts. For example, you can select a hunk directly and operate on it as one unit.

## Practical Memory Guide

- `ha` = hunk add
- `hr` = hunk reset
- `hS` = hunk Stage buffer
- `hR` = hunk Reset buffer
- `hp` = hunk preview
- `hi` = hunk inline preview
- `hb` = hunk blame
- `hd` = hunk diff
- `hq` = hunk quickfix
