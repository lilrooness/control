
local N = {}

local M = {}

-- {
-- [1] = {2, 3}
-- [2] = {1}
-- [3] = {1}
-- }
local edges = {}

local node_obj_ids = {}

local node_states = {}

function M.clear_nodes()
	edges = {}
	node_obj_ids = {}
end

function M.set_node(node_id, connections, obj_id)
	edges[node_id] = connections
	node_obj_ids[node_id] = obj_id
end

function M.get_obj_id(node_id)
	return node_obj_ids[node_id]
end

function M.path_to_obj_ids(path)
	local id_path = {}
	for _, n in pairs(path) do
		table.insert(id_path, M.get_obj_id(n))
	end

	return id_path
end

function M.path(a, b)

	N.preload_door_states()

	local dists = {[a] = {dist = 0, prev = a}}
	local visited = {}

	local found_b = false

	local current_node = N.shortest_dist_node_not_visited(dists, visited)

	while not found_b do

		for _, e in pairs(edges[current_node]) do
			local dist_to = dists[current_node].dist + 1

			if dists[e] == nil or dists[e].dist > dist_to then
				dists[e] = {dist = dist_to, prev = current_node}
			end
		end

		visited[current_node] = true

		current_node = N.shortest_dist_node_not_visited(dists, visited)

		if current_node == b then
			found_b = true
		elseif current_node == nil then
			return {}
		end
	end

	local path = {[1] = b}
	local backtrack_node = b

	while backtrack_node ~= a do
		backtrack_node = dists[backtrack_node].prev
		table.insert(path, backtrack_node)
	end

	return N.reverse_order(path)
end

function N.shortest_dist_node_not_visited(dists, visited)
	local shortest_dist = -1
	local shortest_dist_node = nil

	for node, info in pairs(dists) do
		if visited[node] == nil then
			if shortest_dist == -1 then
				shortest_dist = info.dist
				shortest_dist_node = node
			elseif shortest_dist > info.dist then
				shortest_dist = info.dist
				shortest_dist_node = node
			end
		end
	end

	return shortest_dist_node
end

function N.reverse_order(t)

	local reversed = {}
	
	for i = #t, 1, -1 do
		table.insert(reversed, t[i])
	end

	return reversed
end

function N.preload_door_states()
	for node_id, obj_id in pairs(node_obj_ids) do
		local node_url = msg.url()
		node_url.path = obj_id
		node_url.fragment = "map_node"
		local door_url = go.get(node_url, "door_url")

		-- if the door url has not been overriden
		if door_url ~= hash("not_set") then
			node_states[node_id] = go.get(door_url, "open")
		else
			node_states[node_id] = true
		end

		print(node_id.." : "..tostring(node_states[node_id]))
	end
end

return M