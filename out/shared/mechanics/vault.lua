-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local Workspace = _services.Workspace
local mathf = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "mathf")
local getCamera = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "middleware", "clientExposed").getCamera
local vault = {}
do
	local _container = vault
	local vaultDistance = 4
	local characterHeight = 10
	local normalUp = Vector3.new(0, 1, 0)
	local function Vault(ignore)
		local character = Players.LocalPlayer.Character
		local cframe = character:GetPivot()
		local camera = getCamera()
		local _, bounding = character:GetBoundingBox()
		local look = cframe.LookVector
		local pos = cframe.Position
		local maxL = look * vaultDistance
		local cast = Workspace:Raycast(pos, maxL, ignore)
		if cast then
			-- next check how tall the object is and if it is at a vaultable height!
			local _filterDescendantsInstances = ignore.FilterDescendantsInstances
			local _instance = cast.Instance
			table.insert(_filterDescendantsInstances, _instance)
			local _fn = mathf
			local _exp = cast.Instance
			local _position = cast.Position
			local _vector3 = Vector3.new(0, 100, 0)
			local top = _fn.closestPointOnPart(_exp, _position + _vector3)
			local up = Workspace:Raycast(top, normalUp * characterHeight, ignore)
			if up then
				print("too small a gap to vault!")
				return nil
			end
			local _exp_1 = character:GetChildren()
			local _arg0 = function(v)
				if not v:IsA("BasePart") then
					return nil
				end
				v.Anchored = true
				v.CanCollide = false
			end
			for _k, _v in ipairs(_exp_1) do
				_arg0(_v, _k - 1, _exp_1)
			end
			local p0 = pos
			local _top = top
			local _arg0_1 = camera.CFrame.LookVector * 5
			local _vector3_1 = Vector3.new(0, bounding.Y / 2, 0)
			local p2 = _top + _arg0_1 + _vector3_1
			local _exp_2 = mathf.lerpV3(p0, p2, .75)
			local _vector3_2 = Vector3.new(0, 2, 0)
			local p1 = _exp_2 + _vector3_2
			local t = 0
			local c
			c = RunService.RenderStepped:Connect(function(dt)
				t = math.clamp(t + 2 * dt, 0, 1)
				if t == 1 then
					c:Disconnect()
					local _exp_3 = character:GetChildren()
					local _arg0_2 = function(v)
						if not v:IsA("BasePart") then
							return nil
						end
						v.Anchored = false
						v.CanCollide = true
					end
					for _k, _v in ipairs(_exp_3) do
						_arg0_2(_v, _k - 1, _exp_3)
					end
					return nil
				end
				local bez = mathf.bezierQuadraticV3(t, p0, p1, p2)
				character:SetPrimaryPartCFrame(CFrame.lookAt(bez, character:GetPivot().Position))
			end)
		else
			print("no cast!")
		end
	end
	_container.Vault = Vault
end
return vault
