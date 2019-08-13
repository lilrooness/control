local N = {}

local M = {}

local state = {
	event_chains = {},

	power_level = 100,

	doors_selected = false,
	rooms_selected = false,
	comms_selected = false,
	schematic_selected = false,
	files_selected = false,
	
	comms_enabled = false,
	files_enabled = false,

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
	power_source_ids = {},

	emily_room = -1,
	level_script_url = nil
}

function M.is_seperating_door_open(room1Id, room2Id, socket)
	print("well . . . . we called it :shrug:")
	print(table.getn(state.door_ids))


	for door_number, door_proxy_id in pairs(state.door_ids) do
		local url = msg.url()
		url.socket = socket
		url.fragment = "door_label"
		url.path = door_proxy_id
		local connected_room_1 = go.get(url, "room1_id")
		local connected_room_2 = go.get(url, "room2_id")
		if (room1Id == connected_room_1 or room1Id == connected_room_2) and (room2Id == connected_room_1 or room2Id == connected_room_2) then
			return go.get(url, "open")
		end
	end
	print("CANT FIND DOOR CONNECTING ROOMS - ASSUMING NO DOOR EXISTS")
	-- return true
	return true
end

function M.files_enabled()
	return state.files_enabled
end

function M.enable_files(enabled)
	state.files_enabled = enabled
end

function M.comms_enabled()
	return state.comms_enabled
end

function M.enable_comms(enabled)
	state.comms_enabled = enabled
end

function M.get_power_source_ids()
	return state.power_source_ids
end

function M.get_power_level()
	return state.power_level
end

function M.set_power_level(in_power_level)
	state.power_level = in_power_level
end

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

function M.init_power_source(power_source_number, power_source_id)
	state.power_source_ids[power_source_number] = power_source_id
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

function M.display_id_to_power_source_id(in_display_id)
	local hash_in_display_id = hash(in_display_id)
	local obj_id = nil;

	for power_source_number, power_source_id in pairs(state.power_source_ids) do
		if hash(state.ids[power_source_number]) == hash_in_display_id then
			obj_id = power_source_id
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

function M.select_comms(selected)
	state.comms_selected = selected
end

function M.select_doors(selected)
	state.doors_selected = selected
end

function M.select_rooms(selected)
	state.rooms_selected = selected
end

function M.select_files(selected)
	state.files_selected = selected
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

function M.comms_selected()
	return state.comms_selected
end

function M.files_selected()
	return state.files_selected
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
		print(event.door_id)
		print(state.level_script_url)
	end
end

function M.room_entered_event(room_id)
	M.level_event("room_entered", {room_id = room_id})
	local room_url = msg.url()
	room_url.fragment = "room_proxy"

	-- Add one occupant to new room
	room_url.path = state.room_ids[room_id]
	go.set(room_url, "occupants", go.get(room_url, "occupants") + 1)

	-- Minus one occupant from old room
	room_url.path = state.room_ids[state.emily_room]
	go.set(room_url, "occupants", go.get(room_url, "occupants") - 1)
	state.emily_room = room_id
end

function M.room_left_event(room_id)
	M.level_event("room_left", {room_id = room_id})
	local room_url = msg.url()
	room_url.path = state.room_ids[room_id]
	room_url.fragment = "room_proxy"
	go.set(room_url, "occupants", go.get(room_url, "occupants") - 1)
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