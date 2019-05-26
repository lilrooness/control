-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local N = {
	transcript_data = json.decode(sys.load_resource("/game_data/data.json")),
	transcript_keys_gathered = {},
	hash_key_index = {}
}

for key, _ in pairs(N.transcript_data["transcripts"]) do
	N.hash_key_index[hash(key)] = key
end

local M = {}

function M.get_transcript(key_hash)
	return N.transcript_data[N.hash_key_index[key_hash]]
end

return M