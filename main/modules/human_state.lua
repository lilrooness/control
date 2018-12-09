local M = {}

local state = {
	selected = {}
}

function M.get_selected()
	return state.selected
end

function M.register_select(human_id)
	state.selected = human_id
	print(human_id)
end

function M.register_unselect()
	state.selected = ""
end

function M.is_anything_selected()
	if(state.selected == "") then
		return false
	end
	return true
end

return M
