-- UI
-- NSFCubzh UI

local ui_loader = {}
local ui_mt = {
    __newindex = function(self, key, value)
        
    end,
    __index = function(self, key)
        if key == "Register" then
            return function(ui, constructor)
                if type(constructor) ~= table then
                    error("UI:Register(constructor) - constructor must be a table", 2)
                end

                if constructor.Name == nil then
                    error("UI:Register(constructor) - constructor must have .Name field", 2)
                end
                if constructor.Create == nil then
                    error("UI:Register(constructor) - constructor must have .Create field", 2)
                end
                if constructor.Remove == nil then
                    error("UI:Register(constructor) - constructor must have .Remove field", 2)
                end
                if constructor.Update == nil then
                    error("UI:Register(constructor) - constructor must have .Update field", 2)
                end
                if constructor.Get == nil then
                    error("UI:Register(constructor) - constructor must have .Get field", 2)
                end
                if constructor.Set == nil then
                    error("UI:Register(constructor) - constructor must have .Set field", 2)
                end

                if self.loaded[constructor.Name] ~= nil then
                    error("UI:Register(constructor) - '"..constructor.Name.."' is already loaded", 2)
                end

                self.loaded[constructor.Name] = self.loader.copyTable(constructor)
            end
        elseif self.loaded[key] ~= nil then
            return function(...)
                local o = self.loader.createBaseNode(self.uikit)

                o.Remove = self.loaded[key].Remove
                o.Update = self.loaded[key].Update
                o.Tick = self.loaded[key].Tick

                o.initialized = true
                
                self.loaded[key].Create(o, ...)

                return o
            end
        end
    end
}


ui_loader.init = function(self, e)
	self.env = e
    rawset(self.env, "UI", self:new())
end

ui_loader.new = function(loader)
    local ui = {}
    ui.env = loader.env
    ui.loader = loader
    ui.uikit = require("uikit")

    ui.loaded = {}
    setmetatable(ui, ui_mt)

    return ui
end

ui_loader.createBaseNode = function(uikit)
    local node = {}

    node.uikit_node = uikit:createNode()
    node.initialized = false

    setmetatable(node, {
        __index = function(self, key)
            if key == "Position" then
                return self.uikit_node.pos
            elseif key == "SetParent" then
                return self.uikit_node.setParent
            elseif key == "AddChild" then
                return self.uikit_node.addChild
            elseif key == "uikit_object" then
                return self.uikit_node
            elseif self.initialized == false then
                return rawget(self, key)
            end
        end,
        __newindex = function(self, key, value)
            if key == "Position" then
                self.uikit_node.pos = value
            elseif self.initialized == false then
                rawset(self, key, value)
            end
        end
    })

    return node
end

--http://lua-users.org/wiki/CopyTable
ui_loader.copyTable = function(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[self.env.copyTable(orig_key, copies)] = self.env.copyTable(orig_value, copies)
            end
            setmetatable(copy, self.env.copyTable(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return ui_loader