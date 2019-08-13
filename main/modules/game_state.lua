-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local N = {
	transcript_data = json.decode(sys.load_resource("/game_data/data.json")),
	-- transcript_keys_gathered = {[1] = hash("captain_2136_05_20")},
	transcript_keys_gathered = {},
	hash_key_index = {},

	room_labels = {
		[hash("MED_BAY")] = "MED_BAY",
		[hash("OFC_CMDR")] = "OFC_CMDR",
		[hash("CHRIO_LOBBY")] = "CHRIO_LOBBY",
		[hash("CHRIO")] = "CHRIO",
		[hash("QTN")] = "QTN"
	}
}

for key, _ in pairs(N.transcript_data["transcripts"]) do
	N.hash_key_index[hash(key)] = key
end

local M = {}

function M.get_room_name(name_hash)
	return N.room_labels[name_hash]
end

function M.discover_transcript(key)
	table.insert(N.transcript_keys_gathered, hash(key))
end

function M.get_transcript(key_hash)
	return N.transcript_data["transcripts"][N.hash_key_index[key_hash]]
end

function M.get_transcript_keys()
	return N.transcript_keys_gathered
end

function M.get_transcript_name(key)
	return N.hash_key_index[key]
end

return M