-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local Workspace = _services.Workspace
local _mathf = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "mathf")
local mathf = _mathf
local closestPointOnPart = _mathf.closestPointOnPart
local peripherals = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "utils").peripherals
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
	--[[
		*
		* RAPPEL STILL GOING ON EVEN AFTER EXITING!
	]]
	local function Rappel(ignore)
		local controller = getActionController()
		if controller.rappelling then
			return nil
		end
		local character = Players.LocalPlayer.Character
		local cframe = character:GetPivot()
		local camera = getCamera()
		local _, bounding = character:GetBoundingBox()
		local look = cframe.LookVector
		local pos = cframe.Position
		local maxL = look * rappelDistance
		local cast = Workspace:Raycast(pos, maxL, ignore)
		if cast then
			controller.rappelling = true
			local _fn = mathf
			local _exp = cast.Instance
			local _position = cast.Position
			local _arg0 = up * 1000
			local topSurface = _fn.closestPointOnPart(_exp, _position + _arg0)
			local hitPos = cast.Position
			local hit = cast.Instance
			local topDiff = topSurface.Y - hitPos.Y
			local starttime = tick()
			if topDiff > 20 then
				local r
				r = RunService.RenderStepped:Connect(function(dt)
					local direction = moveDirectionFromKeys()
					direction = Vector3.new(direction.X, direction.Z, 0)
					local charf = character:GetPrimaryPartCFrame()
					local ign = RaycastParams.new()
					ign.FilterType = Enum.RaycastFilterType.Whitelist
					ign.FilterDescendantsInstances = { hit }
					local result = Workspace:Raycast(charf.Position, cast.Normal * (-5), ign)
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
					local checkIfStillOnPart = Workspace:Raycast(targetCFrame.Position, cast.Normal * (-5), ignore)
					local changeDirection = CFrame.lookAt(charf.Position, targetCFrame.Position).LookVector
					local _position_2 = charf.Position
					local _position_3 = targetCFrame.Position
					local changeMagnitude = (_position_2 - _position_3).Magnitude
					local _fn_2 = Workspace
					local _exp_3 = charf.Position
					local _changeDirection = changeDirection
					local _changeMagnitude = changeMagnitude
					local checkObscuring = _fn_2:Raycast(_exp_3, _changeDirection * _changeMagnitude, ignore)
					local halfCharacterHeight = bounding.Y / 2
					local checkDownForGround = Workspace:Raycast(charf.Position, Vector3.new(0, halfCharacterHeight, 0), ignore)
					local function exitUp()
						r:Disconnect()
						local origincharcf = character:GetPivot()
						local start = origincharcf.Position
						local _start = start
						local _vector3 = Vector3.new(0, 1000, 0)
						local _exp_4 = closestPointOnPart(hit, _start + _vector3)
						local _arg0_2 = cast.Normal * (-4)
						local _vector3_1 = Vector3.new(halfCharacterHeight)
						local endTarget = _exp_4 + _arg0_2 + _vector3_1
						local _exp_5 = mathf.lerpV3(start, endTarget, .75)
						local _vector3_2 = Vector3.new(0, 5, 0)
						local middle = _exp_5 + _vector3_2
						local i = 0
						local tip
						tip = RunService.RenderStepped:Connect(function(dt)
							i = math.clamp(i + .5 * dt, 0, 1)
							if i == 1 then
								tip:Disconnect()
								controller.rappelling = false
							end
							local now = mathf.bezierQuadraticV3(i, start, middle, endTarget)
							character:SetPrimaryPartCFrame(CFrame.new(now))
						end)
					end
					local function exitDown()
						r:Disconnect()
						local origincharcf = character:GetPivot()
						local start = origincharcf.Position
						local _exp_4 = closestPointOnPart(hit, start)
						local _arg0_2 = cast.Normal * 4
						local endTarget = _exp_4 + _arg0_2
						local _exp_5 = mathf.lerpV3(start, endTarget, .2)
						local _vector3 = Vector3.new(0, 2, 0)
						local middle = _exp_5 + _vector3
						local i = 0
						local tip
						tip = RunService.RenderStepped:Connect(function(dt)
							i = math.clamp(i + .5 * dt, 0, 1)
							if i == 1 then
								tip:Disconnect()
								controller.rappelling = false
							end
							local now = mathf.bezierQuadraticV3(i, start, middle, endTarget)
							character:SetPrimaryPartCFrame(CFrame.new(now))
						end)
					end
					local origincharcf = character:GetPivot()
					local s = origincharcf.Position
					local _s = s
					local _vector3 = Vector3.new(0, 1000, 0)
					local topBlock = closestPointOnPart(hit, _s + _vector3).Y
					local _s_1 = s
					local _vector3_1 = Vector3.new(0, 1000, 0)
					local bottomBlock = closestPointOnPart(hit, _s_1 - _vector3_1).Y
					if math.abs(topBlock - charf.Position.Y) < 4 and peripherals.isButtonDown(controller:getKey("rappel")) then
						-- exit up
						exitUp()
					end
					if math.abs(bottomBlock - charf.Position.Y) < 4 and peripherals.isButtonDown(controller:getKey("rappel")) then
						if tick() - starttime > 1 then
							exitDown()
						end
					end
					if not checkDownForGround and (not checkObscuring and (checkIfStillOnPart and checkIfStillOnPart.Instance == cast.Instance)) then
						character:SetPrimaryPartCFrame(targetCFrame)
					end
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
