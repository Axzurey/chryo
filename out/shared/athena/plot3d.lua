-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local path = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "path").default
local bin = path:createIfMissing("Workspace//plot3d#env", "Folder")
local plot3d = {}
do
	local _container = plot3d
	local plotId = 0
	local function plotInWorld(position, color)
		if color == nil then
			color = Color3.new(0, 1, 1)
		end
		local p = Instance.new("Part")
		p.Shape = Enum.PartType.Ball
		p.Name = plotId
		p.CastShadow = false
		p.CanCollide = false
		p.CanQuery = false
		p.CanTouch = false
		p.Anchored = true
		p.Size = Vector3.new(1, 1, 1)
		p.Material = Enum.Material.Neon
		p.Color = color
		p.Position = position
		p.Parent = bin
		plotId += 1
		return p
	end
	_container.plotInWorld = plotInWorld
end
return plot3d
