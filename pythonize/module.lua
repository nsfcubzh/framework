-- Pythonize
-- Module that adds some python features

local pythonize = {}

pythonize.init = function(self, e)
	self.env = e

	self.env.len = function(obj)
		return #obj
	end

	self.env.range = function(start, stop, step)
		if stop == nil then
			stop = start
			start = 1
		end
		step = step or 1 -- Default step is 1 if not provided
		return function(_, last_value)
			local next_value = last_value + step
			if (step > 0 and next_value <= stop) or (step < 0 and next_value >= stop) then
				return next_value
			end
		end, nil, start - step
	end
end

return pythonize