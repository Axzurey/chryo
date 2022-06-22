-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local path = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "path").default
local rocaster = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "rocast").default
local reinforcement = {}
do
	local _container = reinforcement
	local reinforceRange = 8
	local pathVar = "ReplicatedStorage//assets//reinforcement"
	local pathObject = path:getInstance(pathVar)
	local function reinforce(client, cameraCFrame)
		local _lookVector = cameraCFrame.LookVector
		local _vector3 = Vector3.new(0, cameraCFrame.LookVector.Y, 0)
		local lookvector = _lookVector - _vector3
		local caster = rocaster.new({
			from = cameraCFrame.Position,
			direction = lookvector,
			maxDistance = reinforceRange,
			ignore = { client.Character },
			ignoreNames = { "HumanoidRootPart" },
			debug = false,
		})
		local wallCast = caster:cast({
			canPierce = function(result)
				return nil
				--[[
					return {
					damageMultiplier: 1,
					weight: 1
					}
				]]
			end,
		})
		if not wallCast then
			print("there is no wall!")
			return nil
		end
		local selectedWall = wallCast.instance
		local selectedWallNormal = wallCast.normal
		local wallPosition = selectedWall.Position
		local _size = selectedWall.Size
		local _vector3_1 = Vector3.new(0, 0, -selectedWall.Size.Z * 2)
		local bottomLeft = wallPosition - ((_size + _vector3_1) / 2)
		local _vector3_2 = Vector3.new(1, 1, 0)
		local lastposition = bottomLeft + _vector3_2
		do
			local y = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					y += 1
				else
					_shouldIncrement = true
				end
				if not (y < 5) then
					break
				end
				do
					local x = 0
					local _shouldIncrement_1 = false
					while true do
						if _shouldIncrement_1 then
							x += 1
						else
							_shouldIncrement_1 = true
						end
						if not (x < 4) then
							break
						end
						local _vector3_3 = Vector3.new(x * 2 + 1, y * 2 + 1, 0)
						local calculatedPosition = bottomLeft + _vector3_3
						local clone = pathObject:Clone()
						clone:SetPrimaryPartCFrame(CFrame.lookAt(lastposition, calculatedPosition + selectedWallNormal))
						clone.Parent = Workspace
						task.wait(.5)
						lastposition = calculatedPosition
					end
				end
			end
		end
	end
	_container.reinforce = reinforce
end
return reinforcement
