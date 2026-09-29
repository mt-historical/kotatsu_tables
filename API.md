# API

## kotatsu_table.toggle_sitting

```lua
-- pos is a position in the world {x = <x>, y = <y>, z = <z>}
-- player is a player's ObjectRef
kotatsu_table.toggle_sitting(pos, player)
```

## helper variables

These are various helper variables.

### Nodeboxes

- `kotatsu_table.tabletop_nodebox`
- `kotatsu_table.blanket_nodebox`
- `kotatsu_table.blanket_side_nodebox`
- `kotatsu_table.blanket_corner_nodebox`

#### kotatsu_table.pos_check

- `kotatsu_table.pos_check`

#### kotatsu_table.wool_dyes

- `kotatsu_table.wool_dyes`

## kotatsu_table.register_table

```lua
-- name of the node "<your_mod_name>:<your_table_name>".
-- desc of the node "<Your Desc>".
-- base node that should be used in the crafting recipe and for tiles if missing "<somemod:base_node>".
-- tiles that should be applied to faces of the node {"<+Y>", "<-Y>", "<+X>", "<-X>", "<+Z>", "<-Z>"}.
-- top node or group to be used for crafting and as a fallback for top_tiles.
-- top_tiles same as tiles except for being used for the table top.
-- inv_image used as the inventory image, see luanti lua_api.md for complete documentation on this.
kotatsu_table.register_table = function(name, desc, base, tiles, top, top_tiles, inv_image)
```
