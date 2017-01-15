
bonemeal = {}

-- bone item
minetest.register_craftitem("bonemeal:bone", {
	description = "Bone",
	inventory_image = "bonemeal_bone.png",
})

-- bonemeal recipes
minetest.register_craft({
	type = "shapeless",
	output = "bonemeal:bonemeal 2",
	recipe = {"bonemeal:bone"},
})

minetest.register_craft({
	type = "shapeless",
	output = "bonemeal:bonemeal 4",
	recipe = {"bones:bones"},
})

-- have animalmaterials found, craft bone into bonemeal
if minetest.get_modpath("animalmaterials") then

	minetest.register_craft({
		type = "shapeless",
		output = "bonemeal:bonemeal 2",
		recipe = {"animalmaterials:bone"},
	})
end

-- add bones to dirt
minetest.override_item("default:dirt", {
	drop = {
		max_items = 1,
		items = {
			{
				items = {"bonemeal:bone", "default:dirt"},
				rarity = 30,
			},
			{
				items = {"default:dirt"},
			}
		}
	},
})


-- particles
local function particle_effect(pos)

	minetest.add_particlespawner({
		amount = 4,
		time = 0.15,
		minpos = pos,
		maxpos = pos,
		minvel = {x = -1, y = 2, z = -1},
		maxvel = {x = 1, y = 4, z = 1},
		minacc = {x = -1, y = -1, z = -1},
		maxacc = {x = 1, y = 1, z = 1},
		minexptime = 1,
		maxexptime = 1,
		minsize = 1,
		maxsize = 3,
		texture = "bonemeal_particle.png",
	})
end


-- default crops
local crops = {
	{"farming:cotton_", 8, "farming:seed_cotton"},
	{"farming:wheat_", 8, "farming:seed_wheat"},
}

-- add to crop list to force grow
-- {crop name start_, growth steps, seed node (if required)}
-- e.g. {"farming:wheat_", 8, "farming:seed_wheat"}

function bonemeal:add_crop(list)

	for n = 1, #list do
		table.insert(crops, list[n])
	end
end


-- default plants
local plants = {
	"air",
	"flowers:dandelion_white",
	"flowers:dandelion_yellow",
	"flowers:geranium",
	"flowers:rose",
	"flowers:tulip",
	"flowers:viola",
}

-- add to plant list to grow among grass
-- "plant node name"
-- e.g. "flowers:rose"

function bonemeal:add_plant(list)

	for n = 1, #list do
		table.insert(plants, list[n])
	end
end


-- special pine check for snow
local function pine_grow(pos)

	if minetest.find_node_near(pos, 1,
		{"default:snow", "default:snowblock", "default:dirt_with_snow"}) then

		default.grow_new_snowy_pine_tree(pos)
	else
		default.grow_new_pine_tree(pos)
	end
end

-- default saplings
local saplings = {
	{"default:sapling", default.grow_new_apple_tree, "soil"},
	{"default:junglesapling", default.grow_new_jungle_tree, "soil"},
	{"default:acacia_sapling", default.grow_new_acacia_tree, "soil"},
	{"default:aspen_sapling", default.grow_new_aspen_tree, "soil"},
	{"default:pine_sapling", pine_grow, "soil"},
}

-- add to sapling list
-- {sapling node, schematic or function name, "soil"|"sand"|specific_node}
--e.g. {"default:sapling", default.grow_new_apple_tree, "soil"}

function bonemeal:add_sapling(list)

	for n = 1, #list do
		table.insert(saplings, list[n])
	end
end


-- moretrees specific function
local function more_tree(pos, object)

	if type(object) == "table" and object.axiom then
		-- grow L-system tree
		minetest.remove_node(pos)
		minetest.spawn_tree(pos, object)

	elseif type(object) == "string" and minetest.registered_nodes[object] then
		-- place node
		minetest.set_node(pos, {name = object})

	elseif type(object) == "function" then
		-- function
		object(pos)

	end
end


-- sapling check
local function check_sapling(pos, nodename)

	-- 1 in 2 chance of spawning sapling
	if math.random(1, 2) == 1 then
		return
	end

	-- what is sapling placed on?
	local under =  minetest.get_node({
		x = pos.x,
		y = pos.y - 1,
		z = pos.z
	})

	local can_grow, grow_on

	-- check list for sapling and function
	for n = 1, #saplings do

		if saplings[n][1] == nodename then

			grow_on = saplings[n][3]

			-- sapling grows on top of specific node
			if grow_on
			and grow_on ~= "soil"
			and grow_on ~= "sand"
			and grow_on == under.name then
				can_grow = true
			end

			-- sapling grows on top of soil (default)
			if can_grow == nil
			and (grow_on == nil or grow_on == "soil")
			and minetest.get_item_group(under.name, "soil") > 0 then
				can_grow = true
			end

			-- sapling grows on top of sand
			if can_grow == nil
			and grow_on == "sand"
			and minetest.get_item_group(under.name, "sand") > 0 then
				can_grow = true
			end

			-- check if we can grow sapling
			if can_grow then
				particle_effect(pos)
				more_tree(pos, saplings[n][2])
				return
			end
		end
	end
end


-- crops check
local function check_crops(pos, nodename)

	local stage = ""

	-- grow registered crops
	for n = 1, #crops do

		if string.find(nodename, crops[n][1])
		or nodename == crops[n][3] then

			-- get stage number or set to 0 for seed
			stage = tonumber( nodename:split("_")[2] ) or 0
			stage = math.min(stage + math.random(1, 4), crops[n][2])

			minetest.set_node(pos, {name = crops[n][1] .. stage})

			particle_effect(pos)

			return

		end

	end

end


-- soil check
local function check_soil(pos, nodename)

	local dirt = minetest.find_nodes_in_area_under_air(
		{x = pos.x - 2, y = pos.y - 1, z = pos.z - 2},
		{x = pos.x + 2, y = pos.y + 1, z = pos.z + 2},
		{"group:soil"})

	for _,n in pairs(dirt) do

		local pos2 = n

		pos2.y = pos2.y + 1

		if math.random(0, 5) > 3 then

			minetest.swap_node(pos2,
				{name = plants[math.random(1, #plants)]})
		else

			if nodename == "default:dirt_with_dry_grass" then
				minetest.swap_node(pos2,
					{name = "default:dry_grass_" .. math.random(1, 5)})
			else
				minetest.swap_node(pos2,
					{name = "default:grass_" .. math.random(1, 5)})
			end
		end

		particle_effect(pos2)
	end
end


-- growing routine
local function growth(pointed_thing)

	local pos = pointed_thing.under
	local node = minetest.get_node(pos)

	-- return if nothing there
	if node.name == "ignore" then
		return
	end

	-- check for tree growth if pointing at sapling
	if minetest.get_item_group(node.name, "sapling") > 0 then

		check_sapling(pos, node.name)

		return
	end

	-- check for crop growth
	check_crops(pos, node.name)

	-- grow grass and flowers
	if minetest.get_item_group(node.name, "soil") > 0 then
		check_soil(pos, node.name)
	end
end


-- bonemeal item
minetest.register_craftitem("bonemeal:bonemeal", {
	description = "Bone Meal",
	inventory_image = "bonemeal_item.png",

	on_use = function(itemstack, user, pointed_thing)

		if pointed_thing.type == "node" then

			-- Check if node protected
			if minetest.is_protected(pointed_thing.under, user:get_player_name()) then
				return
			end

			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end

			growth(pointed_thing)

			return itemstack
		end
	end,
})


-- add support for other mods
dofile(minetest.get_modpath("bonemeal") .. "/mods.lua")

print ("[MOD] Bonemeal loaded")
