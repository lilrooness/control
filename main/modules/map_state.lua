local N = {}

local M = {}

local state = {
	event_chains = {},

	doors_selected = false,
	rooms_selected = false,
	schematic_selected = false,

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

	door_ids = {},
	room_ids = {},

	emily_room = -1,

	level_script_url = nil
}

function M.toggle_door(display_id)
	msg.post(M.display_id_to_door_proxy_id(display_id), "toggle")
end

function M.get_door_proxy_id(door_number)
	return state.door_ids[door_number]
end

function M.get_room_proxy_id(room_number)
	return state.room_ids[room_number]
end

function M.init_door(door_number, proxy_id)
	state.door_ids[door_number] = proxy_id
end

function M.init_room(room_number, proxy_id)
	state.room_ids[room_number] = proxy_id
end

function M.display_id_to_room_proxy_id(in_display_id)
	local hash_in_display_id = hash(in_display_id)
	local obj_id = nil;

	for room_number, room_proxy_id in pairs(state.room_ids) do
		if hash(state.ids[room_number]) == hash_in_display_id then
			obj_id = room_proxy_id
		end
	end

	return obj_id
	
end

function M.display_id_to_door_proxy_id(in_display_id)
	local hash_in_display_id = hash(in_display_id)
	local obj_id = nil;

	for door_number, door_proxy_id in pairs(state.door_ids) do
		if hash(state.ids[door_number]) == hash_in_display_id then
			obj_id = door_proxy_id
		end
	end

	return obj_id
end


function M.begin_event_chain(event, duration)
	table.insert(state.event_chains, {[1] = {event = event, duration = duration}})
	return #state.event_chains
end

function M.chain_event(chain_id, event, duration)
	table.insert(state.event_chains[chain_id], {event = event, duration = duration})
end

function M.execute_event_chain(chain_id)
	N.execute_events(1, state.event_chains[chain_id], 0)
end

function N.execute_events(index, event_list, last_duration)
	timer.delay(last_duration, false, function()
		event_list[index].event()

		if index < #event_list then
			N.execute_events(index + 1, event_list, event_list[index].duration)
		else
			timer.delay(event_list[index].duration, false, function() end)
		end
	end)
end

function M.get_display_id(n)
	return state.ids[n]
end

function M.select_doors(selected)
	state.doors_selected = selected
end

function M.select_rooms(selected)
	state.rooms_selected = selected
end

function M.select_schematic(selected)
	state.schematic_selected = selected
end

function M.doors_selected()
	return state.doors_selected
end

function M.rooms_selected()
	return state.rooms_selected
end

function M.schematic_selected()
	return state.schematic_selected
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
	state.emily_room = room_id
end

function M.door_opened_event(door_id)
	M.level_event("door_opened", {door_id = door_id})
end

function M.door_closed_event(door_id)
	M.level_event("door_closed", {door_id = door_id})
end

function M.disable_input()
	msg.post(":/map_obj", "release_input_focus")
end

function M.enable_input()
	msg.post(":/map_obj", "acquire_input_focus")
end

function M.move_camera_to_obj(obj_id, duration)
	obj_pos = go.get_position(obj_id) + go.get_position(":/map_obj")
	ref_pos = go.get_position(":/center_reference")
	move_vec = obj_pos - ref_pos

	M.move_camera_by(move_vec.x, move_vec.y, duration)
end

function M.get_emily_room()
	return state.emily_room
end

function M.set_emily_room(room_id)
	state.emily_room = room_id
end

function M.move_camera_by(x, y, duration)
	newPos = go.get_position(":/map_obj")

	--inverted controls since what we're really doing is moving the world
	newPos.x = newPos.x - x
	newPos.y = newPos.y - y
	go.animate(":/map_obj", "position", go.PLAYBACK_ONCE_FORWARD, newPos, go.EASING_LINEAR, duration)
end

return M