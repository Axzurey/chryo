-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local RunService = _services.RunService
local Workspace = _services.Workspace
local physicsObject = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "phantom", "physicsObject").default
local i = Instance.new("Part")
i.Anchored = true
i.Color = Color3.fromRGB(255, 0, 255)
i.Material = Enum.Material.Neon
i.Name = "hola"
i.Parent = Workspace
i.CanCollide = false
local obj = physicsObject.new(i, Vector3.new(0, 30, 0))
RunService.Stepped:Connect(function(_, dt)
	obj:update(dt)
end)
while true do
	task.wait(2)
	obj:applyImpulse(Vector3.new(math.random() * 1000 * (if math.random() > .5 then 1 else -1), math.random() * 1000, math.random() * 1000 * (if math.random() > .5 then 1 else -1)))
end
