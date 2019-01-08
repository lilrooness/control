-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local M = {}

function M.fresh_start(self, texts)
	M.start(self, texts)
	ps.subscribe("textbox", go.get_id())
end

function M.start(self, texts)
	self.tbstate = {}
	self.tbstate.texts = texts
	self.tbstate.textNumber = 1
	self.tbstate.numberOfTexts = M.table_length(texts)
	self.tbstate.stop_text = false
end

function M.show_text(self)
	local text = self.tbstate.texts[self.tbstate.textNumber]
	textbox = factory.create(":/textbox_factory#factory")
	msg.post(textbox, "text", {text = text.text, name = text.name, parent_obj = textbox})
	self.tbstate.textNumber = self.tbstate.textNumber + 1

	if text.callback ~= nil then
		text.callback()
	end

	if text.stop then
		self.tbstate.stop_text = true
	end
end

function M.table_length(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function M.handle_textbox_message(self, message_id, message)
	if message_id == hash("textbox") and not message.created and not self.tbstate.stop_text then
		M.show_text(self)
	end
end


return M