-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local path = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "path").default
local tracer
do
	tracer = setmetatable({}, {
		__tostring = function()
			return "tracer"
		end,
	})
	tracer.__index = tracer
	function tracer.new(...)
		local self = setmetatable({}, tracer)
		return self:constructor(...) or self
	end
	function tracer:constructor(origin, direction, lifeTime, color)
		local t = 1
		local velocity = 1000
		local bin = Instance.new("Part")
		bin.Anchored = true
		bin.CanCollide = false
		bin.CanTouch = false
		bin.CanQuery = false
		bin.Size = Vector3.new()
		local _t = t
		local _arg0 = direction * _t
		bin.Position = origin + _arg0
		bin.Transparency = 1
		bin.Parent = path:createIfMissing("Workspace//ignore", "Folder")
		local a1 = Instance.new("Attachment")
		a1.Position = Vector3.new(0, 0, 2)
		a1.Parent = bin
		local a2 = Instance.new("Attachment")
		a2.Position = Vector3.new(0, 0, -2)
		a2.Parent = bin
		local b = Instance.new("Trail")
		b.Brightness = 100
		b.Color = ColorSequence.new(color)
		b.Lifetime = 1
		b.LightInfluence = 0
		b.FaceCamera = true
		b.WidthScale = NumberSequence.new(.01)
		b.MaxLength = 100
		b.Attachment0 = a1
		b.Attachment1 = a2
		b.Parent = bin
		local start = tick()
		local rs
		rs = RunService.RenderStepped:Connect(function(dt)
			t += velocity * dt
			if tick() - start >= lifeTime then
				rs:Disconnect()
				bin:Destroy()
				return nil
			end
			local _t_1 = t
			local _arg0_1 = direction * _t_1
			local d = origin + _arg0_1
			bin.CFrame = CFrame.lookAt(d, d * 2)
		end)
	end
end
return {
	default = tracer,
}
