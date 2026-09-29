local kt = {}
kt.S = core.get_translator(core.get_current_modname())

kt.toggle_sitting = function(npos, player)
	if not player:is_player() then
		return
	end
	local meta = core.get_meta(npos)
	local tablepos = core.string_to_pos(meta:get_string("p"))
	if not tablepos then
		core.remove_node(npos)
		return
	end
	local name = player:get_player_name()
	if default.player_attached[name] then
		player:set_pos(vector.add(player:get_pos(), { x = 0, y = 1, z = 0 }))
		default.player_attached[name] = false
		player:set_physics_override({ speed = 1, jump = 1, gravity = 1 })
		player:set_eye_offset({ x = 0, y = 0, z = 0 }, { x = 0, y = 0, z = 0 })
		default.player_set_animation(player, "stand", 30)
	else
		local v = player:get_player_velocity()
		if v.x ~= 0 or v.y ~= 0 or v.z ~= 0 then
			return
		end
		local ppos = player:get_pos()
		ppos.x = ppos.x - tablepos.x
		ppos.y = tablepos.y - 0.5
		ppos.z = ppos.z - tablepos.z
		local inside = ppos.x > -1.25 and ppos.x < 1.25 and ppos.z > -1.25 and ppos.z < 1.25
		if inside then
			if math.abs(ppos.x) > math.abs(ppos.z) then
				ppos.x = (ppos.x > 0) and 1.25 or -1.25
			else
				ppos.z = (ppos.z > 0) and 1.25 or -1.25
			end
		else
			ppos.x = math.max(-1.25, math.min(1.25, ppos.x))
			ppos.z = math.max(-1.25, math.min(1.25, ppos.z))
		end
		ppos.x = ppos.x + tablepos.x
		ppos.z = ppos.z + tablepos.z
		player:set_pos(ppos)
		player:set_physics_override({ speed = 0, jump = 0, gravity = 0 })
		default.player_attached[name] = true
		--player:set_eye_offset({x=0, y=-1, z=0}, {x=0, y=0, z=0})
		default.player_set_animation(player, "sit", 30)
	end
end

kt.tabletop_nodebox = {
	type = "fixed",
	fixed = {
		{ -0.8, 0.25, -0.8, 0.8, 0.3, 0.8 },
	},
}

kt.blanket_nodebox = {
	type = "fixed",
	fixed = {
		{ 0.125, -0.125, 0.125, 1.875, 0.25, 1.875 },
		{ -0.125, -0.375, -0.125, 2.125, -0.125, 2.125 },
		{ -0.5, -0.5, -0.5, 2.5, -0.375, 2.5 },
	},
}

kt.blanket_side_nodebox = {
	type = "fixed",
	fixed = {
		{ -0.5, -0.125, 0.125, 0.5, 0.25, 0.5 },
		{ -0.5, -0.375, -0.125, 0.5, -0.125, 0.5 },
		{ -0.5, -0.5, -0.5, 0.5, -0.375, 0.5 },
	},
}

kt.blanket_corner_nodebox = {
	type = "fixed",
	fixed = {
		{ 0.125, -0.125, 0.125, 0.5, 0.25, 0.5 },
		{ -0.125, -0.375, -0.125, 0.5, -0.125, 0.5 },
		{ -0.5, -0.5, -0.5, 0.5, -0.375, 0.5 },
	},
}

kt.pos_check = {
	{ offset = { x = -1, y = 0, z = 0 }, ext = "_side", param2 = 1 },
	{ offset = { x = 1, y = 0, z = 0 }, ext = "_side", param2 = 3 },
	{ offset = { x = 0, y = 0, z = -1 }, ext = "_side", param2 = 0 },
	{ offset = { x = 0, y = 0, z = 1 }, ext = "_side", param2 = 2 },
	{ offset = { x = 1, y = 0, z = 1 }, ext = "_corner", param2 = 2 },
	{ offset = { x = -1, y = 0, z = 1 }, ext = "_corner", param2 = 1 },
	{ offset = { x = 1, y = 0, z = -1 }, ext = "_corner", param2 = 3 },
	{ offset = { x = -1, y = 0, z = -1 }, ext = "_corner", param2 = 0 },
}
kt.register_table = function(name, desc, base, tiles, top, top_tiles, inv_image)
	base = base or "wool:white" -- don't omit base
	tiles = tiles or (core.registered_nodes[base] or { tiles = { "wool_white.png" } }).tiles
	top = top or "group:wood"
	top_tiles = top_tiles or (core.registered_nodes[top] or { tiles = { "default_wood.png" } }).tiles
	inv_image = inv_image
		or ("(kotatsu_base.png^[mask:" .. tiles[1] .. ")^(kotatsu_top.png^[mask:" .. top_tiles[1] .. ")")
	local kotatsu = name or ("kotatsu_table:table_" .. string.gsub(base, ":", "_"))
	desc = (
		desc
		or (core.registered_nodes[base] or { description = "Terribly Programmed" }).description
		or "Very Terribly Programmed"
	) .. " Kotatsu Table"

	core.register_node(kotatsu .. "_side", {
		description = kt.S("@1 Blanket Side", desc),
		walkable = false,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = tiles,
		drop = "",
		node_box = kt.blanket_side_nodebox,
		diggable = false,
		on_rightclick = function(pos, _, player)
			kt.toggle_sitting(pos, player)
		end,
		groups = { not_in_creative_inventory = 1, immovable = 2 },
		on_blast = function() end,
	})

	core.register_node(kotatsu .. "_corner", {
		description = kt.S("@1 Blanket Corner", desc),
		walkable = false,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = tiles,
		drop = "",
		node_box = kt.blanket_corner_nodebox,
		diggable = false,
		on_rightclick = function(pos, _, player)
			kt.toggle_sitting(pos, player)
		end,
		groups = { not_in_creative_inventory = 1, immovable = 2 },
		on_blast = function() end,
	})

	core.register_node(kotatsu, {
		description = desc,
		inventory_image = inv_image,
		wield_image = inv_image,
		drawtype = "nodebox",
		tiles = top_tiles,
		node_box = kt.tabletop_nodebox,
		groups = { choppy = 3, oddly_breakable_by_hand = 2, immovable = 2 },
		on_construct = function(pos)
			local npos
			for _, p in ipairs(kt.pos_check) do
				npos = vector.add(p.offset, pos)
				local n = core.get_node_or_nil(npos)
				if not n or not (core.registered_nodes[n.name] or {}).buildable_to then
					core.remove_node(pos)
					core.add_item(pos, kotatsu)
					return
				end
			end
			for _, p in ipairs(kt.pos_check) do -- Check passed, now build
				npos = vector.add(p.offset, pos)
				core.set_node(npos, { name = kotatsu .. p.ext, param2 = p.param2 })
				core.after(0, function(np)
					core.get_meta(np):set_string("p", core.pos_to_string(pos))
				end, npos)
			end
		end,
		on_destruct = function(pos)
			local npos
			for _, p in ipairs(kt.pos_check) do
				npos = vector.add(p.offset, pos)
				local n = core.get_node(npos)
				if n.name == kotatsu .. p.ext and n.param2 == p.param2 then
					core.remove_node(npos)
				end
			end
		end,
	})

	core.register_craft({
		output = kotatsu,
		recipe = {
			{ top, top, top },
			{ base, "default:mese_crystal", base },
			{ base, "", base },
		},
	})
end

kt.wool_dyes = {
	{ "white", kt.S("White") },
	{ "grey", kt.S("Grey") },
	{ "black", kt.S("Black") },
	{ "red", kt.S("Red") },
	{ "yellow", kt.S("Yellow") },
	{ "green", kt.S("Green") },
	{ "cyan", kt.S("Cyan") },
	{ "blue", kt.S("Blue") },
	{ "magenta", kt.S("Magenta") },
	{ "orange", kt.S("Orange") },
	{ "violet", kt.S("Violet") },
	{ "brown", kt.S("Brown") },
	{ "pink", kt.S("Pink") },
	{ "dark_grey", kt.S("Dark Grey") },
	{ "dark_green", kt.S("Dark Green") },
}

for _, d in pairs(kt.wool_dyes) do
	kt.register_table(nil, d[2], "wool:" .. d[1])
end

kotatsu_table = kt
