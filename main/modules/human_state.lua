-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local M = {}

local state = {
	registered_markers = 0
	markers = {}
}

local marker_names = {
	{"Emily", "E"}
	{"Max", "M"}
}

function M.register_marker(marker_id) do
	local name = marker_names[state.registered_markers][1]
	state.markers[marker_id] = name
	state.registered_markers = state.registered_markers + 1
	return name
end

function M.get_marker_command_key(marker_id) do
	return marker_names[state.markers[marker_id]]][2]
end

return M