-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local animationCompile
do
	animationCompile = setmetatable({}, {
		__tostring = function()
			return "animationCompile"
		end,
	})
	animationCompile.__index = animationCompile
	function animationCompile.new(...)
		local self = setmetatable({}, animationCompile)
		return self:constructor(...) or self
	end
	function animationCompile:constructor(animation)
		self.animation = animation
	end
	function animationCompile:create(animationId)
		local a = Instance.new("Animation")
		a.Parent = Workspace
		a.AnimationId = animationId
		return self.new(a)
	end
	function animationCompile:final()
		return self.animation
	end
	function animationCompile:cleanUp()
		self.animation:Destroy()
	end
end
return {
	default = animationCompile,
}
