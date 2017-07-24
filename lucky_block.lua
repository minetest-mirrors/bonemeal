
-- add lucky blocks

local function growy(pos, player)

	local dpos = minetest.find_node_near(pos, 1, "group:soil")

	if dpos then
		bonemeal:on_use(dpos, 5)
	end
end


if minetest.get_modpath("lucky_block") then

lucky_block:add_blocks({
	{"lig"},
	{"dro", {"bonemeal:mulch", "bonemeal:bonemeal", "bonemeal:fertiliser"}, 10},
	{"cus", growy},
})

end -- END IF
