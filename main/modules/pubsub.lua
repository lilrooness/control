local M = {}

local state = {
	textbox = {},
	objects = {}
}

function M.subscribe(queue, id)
	table.insert(state[queue], id)
end

function M.clean(queue)
	state[queue] = {}
end

function M.create_queue(queue)
	state[queue] = {}
end

function M.publish(queue, message)
	for i, v in ipairs(state[queue]) do
		pcall(msg.post, v, queue, message)
	end
end

return M