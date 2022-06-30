-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local Workspace = _services.Workspace
local interpolate = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "interpolations").interpolate
local mathf = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "mathf")
local getActionController = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "global", "clientExposed").getActionController
local vault = {}
do
	local _container = vault
	local vaultDistance = 4
	local characterHeight = 10
	local normalUp = Vector3.new(0, 1, 0)
	local inset = 2
	local maxVaultableHeight = 5
	local function Vault(ignore)
		local character = Players.LocalPlayer.Character
		local cframe = character:GetPivot()
		local _, bounding = character:GetBoundingBox()
		local look = cframe.LookVector
		local pos = cframe.Position
		local maxL = look * vaultDistance
		local cast = Workspace:Raycast(pos, maxL, ignore)
		local controller = getActionController()
		if cast then
			-- following 3 lines check if the top of the object is a small enough distance to vault
			local _fn = mathf
			local _exp = cast.Instance
			local _position = cast.Position
			local _vector3 = Vector3.new(0, 100, 0)
			local top = _fn.closestPointOnPart(_exp, _position + _vector3)
			local _position_1 = cast.Position
			local _top = top
			local distanceToTop = (_position_1 - _top).Magnitude
			if distanceToTop > maxVaultableHeight then
				print("too tall a height")
				return nil
			end
			local _filterDescendantsInstances = ignore.FilterDescendantsInstances
			local _instance = cast.Instance
			table.insert(_filterDescendantsInstances, _instance)
			controller.vaulting = true
			local _pos = pos
			local _position_2 = cast.Position
			local distance = (_pos - _position_2).Magnitude
			local up = Workspace:Raycast(top, normalUp * characterHeight, ignore)
			if up then
				print("too small a gap to vault!")
				return nil
			end
			local changed = {}
			local _exp_1 = character:GetChildren()
			local _arg0 = function(v)
				if not v:IsA("BasePart") then
					return nil
				end
				local _changed = changed
				local _canCollide = v.CanCollide
				_changed[v] = _canCollide
				v.CanCollide = false
			end
			for _k, _v in ipairs(_exp_1) do
				_arg0(_v, _k - 1, _exp_1)
			end
			local p0 = pos
			local _top_1 = top
			local _look = look
			local _arg0_1 = inset + distance
			local _vector3_1 = Vector3.new(0, bounding.Y / 2 + 1, 0)
			local p2 = _top_1 + (_look * _arg0_1) + _vector3_1
			local _exp_2 = mathf.lerpV3(p0, p2, .25)
			local _vector3_2 = Vector3.new(0, 2, 0)
			local p1 = _exp_2 + _vector3_2
			local t = 0
			controller.actionMap.crouch(controller.start)
			local c
			c = RunService.RenderStepped:Connect(function(dt)
				t = math.clamp(t + 2 * dt, 0, 1)
				if t == 1 then
					c:Disconnect()
					local _changed = changed
					local _arg0_2 = function(v, k)
						k.CanCollide = v
					end
					for _k, _v in pairs(_changed) do
						_arg0_2(_v, _k, _changed)
					end
					controller.vaulting = false
					controller.actionMap.crouch(controller.start)
					task.wait(1)
					return nil
				end
				local z = interpolate(t, 0, 1, "quadInOut")
				local bez = mathf.bezierQuadraticV3(z, p0, p1, p2)
				local p = character:GetPivot()
				character:SetPrimaryPartCFrame(CFrame.lookAt(bez, Vector3.new()))
			end)
		else
			print("no cast!")
		end
	end
	_container.Vault = Vault
end
return vault
