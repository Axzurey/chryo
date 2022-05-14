-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local Workspace = _services.Workspace
local mathf = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "mathf")
local _clientExposed = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "middleware", "clientExposed")
local getActionController = _clientExposed.getActionController
local getCamera = _clientExposed.getCamera
local moveDirectionFromKeys = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "util", "userContext").moveDirectionFromKeys
local rappel = {}
do
	local _container = rappel
	local rappelDistance = 5
	local rappelVelocity = 10
	local up = Vector3.new(0, 1, 0)
	local function Rappel(ignore)
		local controller = getActionController()
		controller.rappelling = true
		local character = Players.LocalPlayer.Character
		local cframe = character:GetPivot()
		local camera = getCamera()
		local _, bounding = character:GetBoundingBox()
		local look = cframe.LookVector
		local pos = cframe.Position
		local maxL = look * rappelDistance
		local cast = Workspace:Raycast(pos, maxL, ignore)
		if cast then
			local _fn = mathf
			local _exp = cast.Instance
			local _position = cast.Position
			local _arg0 = up * 1000
			local topSurface = _fn.closestPointOnPart(_exp, _position + _arg0)
			local hitPos = cast.Position
			local hit = cast.Instance
			local topDiff = topSurface.Y - hitPos.Y
			if topDiff > 20 then
				local r = RunService.RenderStepped:Connect(function(dt)
					local direction = moveDirectionFromKeys()
					direction = Vector3.new(direction.X, direction.Z, 0)
					local charf = character:GetPrimaryPartCFrame()
					local ign = RaycastParams.new()
					ign.FilterType = Enum.RaycastFilterType.Whitelist
					ign.FilterDescendantsInstances = { hit }
					local result = Workspace:Raycast(charf.Position, charf.LookVector * 5, ign)
					if not result then
						print("no result!!!!!")
						return nil
					end
					if result.Normal ~= cast.Normal then
						print("incorrect normal! wrong face!")
						return nil
					end
					local _fn_1 = CFrame
					local _exp_1 = result.Position
					local _position_1 = result.Position
					local _normal = result.Normal
					local constructed = _fn_1.lookAt(_exp_1, _position_1 + _normal)
					local ry = constructed:VectorToObjectSpace(direction)
					local tochar = character:GetPrimaryPartCFrame():VectorToObjectSpace(ry)
					local _tochar = tochar
					local _arg0_1 = rappelVelocity * dt
					local nextp = _tochar * _arg0_1
					local _exp_2 = character:GetPrimaryPartCFrame()
					local _cFrame = CFrame.new(nextp)
					local targetCFrame = _exp_2 * _cFrame
					-- make sure targetcframe lies on the surface of the part!
					character:SetPrimaryPartCFrame(targetCFrame)
				end)
			else
				print("too small to rappel on!")
			end
		else
			print("nothing to rappel on!")
		end
	end
	_container.Rappel = Rappel
end
return rappel
