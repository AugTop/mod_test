local timer = 0

local function add_priv_wear(player)
	local inv = player:get_inventory()
	if inv then
		local list = inv:get_list("armor")
		for index, stack in pairs(list) do
			local name = stack:get_name()
			local wear = minetest.get_item_group(name, "privkit_use")
			if wear > 0 then
				armor:damage(player, index, stack, wear)
			end
		end
	end
end

minetest.register_tool("testaxi:boots", {
	description = ('Flying Boots'),
	inventory_image = "boots_inv.png",
	groups = {armor_feet=1, privkit_use=8000},
	armor_groups = {fleshy=5},
	on_equip = function(itemstack, user)

		local pos = user:get_pos()
		local name = user:get_player_name()

		-- are we already invisible?
		if invisibility[name] then

			minetest.chat_send_player(name,
				">>> You are already invisible!")

				return itemstack
		end


		-- make player invisible
		invisible(user, true)

		

		-- display 10 second warning
		minetest.after(effect_time - 10, function()

			if invisibility[name]
			and user:get_pos() then

				minetest.chat_send_player(name,
					">>> You have 10 seconds before invisibility wears off!")
			end
		end)

		-- make player visible 5 minutes later
		minetest.after(effect_time, function()

			if invisibility[name]
			and user:get_pos() then

				-- show aready hidden player
				invisible(user, nil)

				
			end
		

	



-- minetest.register_privilege("privkit", {
-- 	description = "Player privileges determined by privkit armor",
--	give_to_singleplayer = false,
--})

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local privs = minetest.get_player_privs(name)
	if privs.privkit then
		privs.fly = nil
		if not minetest.check_player_privs(player:get_player_name(),{ban = true})
		then
			minetest.set_player_privs(name, privs)
		end
	end
end)

-- apply wear once every 8 seconds
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > 8 then
		local players = minetest.get_connected_players()
		for _, player in pairs(players) do
			add_priv_wear(player)
		end
		timer = 0
	end
end)
