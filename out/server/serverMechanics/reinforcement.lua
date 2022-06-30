-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local anime = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "anime")
local path = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "path").default
local newThread = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "utils").newThread
local rocaster = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "rocast").default
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
		local attr = wallCast.instance:GetAttribute("reinforcable")
		if not (attr ~= 0 and (attr == attr and (attr ~= "" and attr))) then
			return nil
		end
		local selectedWall = wallCast.instance
		local selectedWallNormal = wallCast.normal
		local wallPosition = selectedWall.Position
		local _size = selectedWall.Size
		local _vector3_1 = Vector3.new(0, 0, -selectedWall.Size.Z * 2)
		local bottomLeft = wallPosition - ((_size + _vector3_1) / 2)
		local _size_1 = selectedWall.Size
		local backBottomLeft = (wallPosition - _size_1) / 2
		local animations = {}
		local i = {}
		local canceled = false
		do
			local _x = 0
			local _shouldIncrement = false
			while true do
				local x = _x
				if _shouldIncrement then
					x += 1
				else
					_shouldIncrement = true
				end
				if not (x < 4) then
					break
				end
				local _vector3_2 = Vector3.new(x * 2 + 1, 1, 0)
				local lastposition = bottomLeft + _vector3_2
				newThread(function()
					do
						local y = 0
						local _shouldIncrement_1 = false
						while true do
							if _shouldIncrement_1 then
								y += 1
							else
								_shouldIncrement_1 = true
							end
							if not (y < 5) then
								break
							end
							if canceled then
								break
							end
							local _vector3_3 = Vector3.new(x * 2 + 1, y * 2 + 1, 0)
							local calculatedPosition = bottomLeft + _vector3_3
							local clone = pathObject:Clone()
							clone:SetPrimaryPartCFrame(CFrame.lookAt(lastposition, lastposition + selectedWallNormal))
							local animation = anime.animateModelPosition(clone, calculatedPosition, .4)
							local _unbind = animation.binding.unbind
							table.insert(animations, _unbind)
							local _clone = clone
							table.insert(i, _clone)
							clone.Parent = Workspace
							task.wait(.5)
							lastposition = calculatedPosition
						end
					end
				end)
				_x = x
			end
		end
		do
			local _x = 0
			local _shouldIncrement = false
			while true do
				local x = _x
				if _shouldIncrement then
					x += 1
				else
					_shouldIncrement = true
				end
				if not (x < 4) then
					break
				end
				local _vector3_2 = Vector3.new(x * 2 + 1, 1, 0)
				local lastposition = backBottomLeft + _vector3_2
				newThread(function()
					do
						local y = 0
						local _shouldIncrement_1 = false
						while true do
							if _shouldIncrement_1 then
								y += 1
							else
								_shouldIncrement_1 = true
							end
							if not (y < 5) then
								break
							end
							if canceled then
								break
							end
							local _vector3_3 = Vector3.new(x * 2 + 1, y * 2 + 1, 0)
							local calculatedPosition = backBottomLeft + _vector3_3
							local clone = pathObject:Clone()
							clone:SetPrimaryPartCFrame(CFrame.lookAt(lastposition, lastposition + selectedWallNormal))
							local animation = anime.animateModelPosition(clone, calculatedPosition, .4)
							local _unbind = animation.binding.unbind
							table.insert(animations, _unbind)
							local _clone = clone
							table.insert(i, _clone)
							clone.Parent = Workspace
							task.wait(.5)
							lastposition = calculatedPosition
						end
					end
				end)
				_x = x
			end
		end
		return {
			cancel = function()
				canceled = true
				local _arg0 = function(v)
					v()
				end
				for _k, _v in ipairs(animations) do
					_arg0(_v, _k - 1, animations)
				end
				local _arg0_1 = function(v)
					v:Destroy()
				end
				for _k, _v in ipairs(i) do
					_arg0_1(_v, _k - 1, i)
				end
			end,
		}
	end
	_container.reinforce = reinforce
end
return reinforcement
