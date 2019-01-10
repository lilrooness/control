
local N = {}

local M = {}

-- {
-- [1] = {2, 3}
-- [2] = {1}
-- [3] = {1}
-- }
local edges = {}


function M.path(a, b)

	dists = {[a] = {dist = 0, prev = a}}
	visited = {}
	
	found_b = false

	current_node = N.shortest_dist_node_not_visited(dists, visited)

	while not found_b do

		for i, e in pairs(edges[current_node]) do
			dist_to = dists[current_node].dist + 1

			if dists[e] == nil or dists[e].dist > dist_to then
				dists[e] = {dist = dist_to, prev = current_node}
			end
		end

		visited[current_node] = true

		current_node = N.shortest_dist_node_not_visited(dists, visited)
		
		if current_node == b then
			found_b = true
		end
	end

	path = {[1] = b}
	backtrack_node = b
	
	while backtrack_node ~= a do
		backtrack_node = dists[backtrack_node].prev
		table.insert(path, backtrack_node)
	end

	return path
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

return M