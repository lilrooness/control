local M = {}

local state = {
	{name = hash("main_deck"), on = false},
	{name = hash("atmosphere"), on = false},
	{name = hash("engines"), on = false},
	{name = hash("fuel"), on = false},
	{name = hash("chriopods"), on = false}
}

local alarms = {}

function M.set(name, on)
	for i, v in ipairs(state) do
		if v.name == name then
			v.on = on
		end
	end
end

function M.get(name)
	for i, v in ipairs(state) do
		if v.name == name then
			return v.on
		end
	end

	return false
end

function M.set_alarm(id, on)
	alarms[id] = on
end

function M.get_alarm(id)
	return alarms[id]
end

return M