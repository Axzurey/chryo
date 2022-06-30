-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Debris = _services.Debris
local Workspace = _services.Workspace
local graphRBX = {}
do
	local _container = graphRBX
	local function plotInWorld(point, color, length)
		if color == nil then
			color = Color3.new(1, 1, 1)
		end
		local p = Instance.new("Part")
		p.Anchored = true
		p.Shape = Enum.PartType.Ball
		p.Color = color
		p.Size = Vector3.new(.5, .5, .5)
		p.CanCollide = false
		p.CanQuery = false
		p.CanTouch = false
		p.Name = "point@" .. tostring(point)
		p.Position = point
		p.Parent = Workspace
		if length ~= 0 and (length == length and length) then
			Debris:AddItem(p, length)
		end
	end
	_container.plotInWorld = plotInWorld
end
return graphRBX
