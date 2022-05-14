-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local UserInputService = TS.import(script, TS.getModule(script, "@rbxts", "services")).UserInputService
local userContext = {}
do
	local _container = userContext
	local function moveDirectionFromKeys()
		local v = Vector3.new()
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			local _v = v
			local _vector3 = Vector3.new(1, 0, 0)
			v = _v + _vector3
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			local _v = v
			local _vector3 = Vector3.new(0, 0, 1)
			v = _v + _vector3
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			local _v = v
			local _vector3 = Vector3.new(0, 0, -1)
			v = _v + _vector3
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			local _v = v
			local _vector3 = Vector3.new(-1, 0, 0)
			v = _v + _vector3
		end
		return v
	end
	_container.moveDirectionFromKeys = moveDirectionFromKeys
end
return userContext
