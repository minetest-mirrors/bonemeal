
-- add lucky blocks

if minetest.get_modpath("lucky_block") then

lucky_block:add_blocks({
	{"lig"},
	{"dro", {"bonemeal:mulch", "bonemeal:bonemeal", "bonemeal:fertiliser"}, 10},
})

end -- END IF
