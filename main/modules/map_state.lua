local M = {}

local state = {
	doors = false,
	rooms = false
}

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