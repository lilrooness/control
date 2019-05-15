-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local N = {
	audio_log_ids = {},
	audio_log_keys_gathered = {}
}

local M = {}

function M.get_audio_log_ids()
	return N.audio_log_ids
end

return M