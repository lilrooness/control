local M = {}

function M.range(n1, n2)
	local t = {}

	for i=n1, n2 do
		print(i)
		table.insert(t, i)
	end

	return t
end