-- UI
-- NSFCubzh UI

local ui_loader = {}

ui_loader.init = function(self, e)
	self.env = e
    rawset(self.env, "UI", self:new())
end

ui_loader.new = function(loader)
    local ui = {}

    return ui
end

return ui_loader