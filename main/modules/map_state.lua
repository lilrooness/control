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
	},

	level_script_url = nil
}

function M.get_display_id(n)
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

function M.set_level_script(url)
	state.level_script_url = url
end

function M.level_event(event_code, event)
	-- during level init, this might be nil but door events can still fire
	if state.level_script_url ~= nil then
		msg.post(state.level_script_url, event_code, event)
	end
end

function M.room_entered_event(room_id)
	M.level_event("room_entered", {room_id = room_id})
end

function M.door_opened_event(door_id)
	M.level_event("door_opened", {door_id = door_id})
end

function M.door_closed_event(door_id)
	M.level_event("door_closed", {door_id = door_id})
end

return M