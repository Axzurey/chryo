-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local mathf = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "math")
local newThread = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "utils").newThread
local ignoreInstances = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "space").ignoreInstances
local explosion = {}
do
	local _container = explosion
	local damaged = {}
	local function explosionRange(centerPoint)
		local explosionFidelity = 20 * 1
		local directions = mathf.pointsOnSphere(explosionFidelity)
		local ignore = RaycastParams.new()
		local _array = {}
		local _length = #_array
		table.move(ignoreInstances, 1, #ignoreInstances, _length + 1, _array)
		ignore.FilterDescendantsInstances = _array
		local toCSG = {}
		local _directions = directions
		local _arg0 = function(direction)
			newThread(function()
				local result = Workspace:Raycast(centerPoint, direction * 100, ignore)
				if result then
					local position = result.Position
					local hit = result.Instance
					local distance = (position - centerPoint).Magnitude
					local damage = 100
					local _hit = hit
					local mapped = damaged[_hit]
					if mapped then
						mapped.current += damage
						local _hit_1 = hit
						local _mapped = mapped
						damaged[_hit_1] = _mapped
					else
						mapped = {
							max = 100,
							current = damage,
						}
						local _hit_1 = hit
						local _mapped = mapped
						damaged[_hit_1] = _mapped
					end
					local p = Instance.new("Part")
					p.Color = Color3.new(1, 0, 1)
					p.Size = Vector3.new(1, 1, 1)
					p.Shape = Enum.PartType.Ball
					p.Anchored = true
					p.Position = position
					p.CanCollide = false
					p.CanQuery = false
					p.Parent = Workspace
					-- maybe not use csg for everything unless u wanna crash
					if mapped.current >= mapped.max then
						local _toCSG = toCSG
						local _exp = hit
						local _toCSG_1 = toCSG
						local _hit_1 = hit
						local _result
						if _toCSG_1[_hit_1] then
							local _array_1 = {}
							local _length_1 = #_array_1
							local _toCSG_2 = toCSG
							local _hit_2 = hit
							local _array_2 = _toCSG_2[_hit_2]
							local _Length = #_array_2
							table.move(_array_2, 1, _Length, _length_1 + 1, _array_1)
							_length_1 += _Length
							_array_1[_length_1 + 1] = p
							_result = _array_1
						else
							_result = { p }
						end
						_toCSG[_exp] = _result
					end
				end
			end)
		end
		for _k, _v in ipairs(_directions) do
			_arg0(_v, _k - 1, _directions)
		end
		local _toCSG = toCSG
		local _arg0_1 = function(v, k)
			local n = k:SubtractAsync(v)
			k:Destroy()
			n.Parent = Workspace
			local _arg0_2 = function(v)
				v:Destroy()
			end
			for _k, _v in ipairs(v) do
				_arg0_2(_v, _k - 1, v)
			end
		end
		for _k, _v in pairs(_toCSG) do
			_arg0_1(_v, _k, _toCSG)
		end
	end
	_container.explosionRange = explosionRange
	local function focusedExplosion(at, direction, length)
		if length == nil then
			length = 1
		end
	end
	_container.focusedExplosion = focusedExplosion
end
return explosion
