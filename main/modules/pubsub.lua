local M = {}

local state = {
	textbox = {},
	objects = {}
}

function M.subscribe(queue, id)
	table.insert(state[queue], id)
end

function M.create_queue(queue)
	state[queue] = {}
end

function M.publish(queue, message)
	for i, v in ipairs(state[queue]) do
		msg.post(v, queue, message)
	end
end

return M