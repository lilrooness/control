local M = {}

local state = {
	doors = false,
	rooms = false,
	ids = {
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9",
		"0",
		"a",
		"b",
		"c",
		"e",
		"f",
		"g",
		"h",
		"i",
		"j",
		"k"
	}
}

function M.get_door_id(n)
	return state.ids[n]
end

function M.select_doors(selected)
	state.doors = selected
end

function M.select_rooms(selected)
	state.rooms = selected
end

function M.doors_selected()
	return state.doors
end

function M.rooms_selected()
	return state.rooms
end

return M