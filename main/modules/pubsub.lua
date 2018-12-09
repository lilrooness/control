local M = {}

local state = {
	textbox = {}
}

function M.subscribe(queue, id)
	table.insert(state[queue], id)
end

function M.create_queue(queue)
	state[queue] = {}
end

function M.publish(queue, message)
	print("publishing messages ...")
	for i, v in ipairs(state[queue]) do
		print(v)
		msg.post(v, queue, message)
	end
end

return M