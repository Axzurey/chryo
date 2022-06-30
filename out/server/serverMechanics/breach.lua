-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local newThread = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "utils").newThread
local breach = {}
do
	local _container = breach
	local function shotgun(pos, dir)
		local p = Instance.new("Part")
		p.Anchored = true
		p.CanCollide = false
		p.CanQuery = false
		p.CanTouch = false
		p.Transparency = 1
		p.CFrame = CFrame.lookAt(pos, dir)
		p.Size = Vector3.new(3, 3, 2)
		p.Parent = Workspace
		return p
	end
	_container.shotgun = shotgun
	local existingImpacts = {}
	local originalMap = {}
	local function bulk(parts)
		local tod = {}
		local _arg0 = function(v)
			local gett = Workspace:GetPartBoundsInBox(v.CFrame, v.Size)
			local _gett = gett
			local _arg0_1 = function(hit)
				if hit:IsA("MeshPart") then
					return nil
				end
				if hit.Name == "Baseplate" then
					return nil
				end
				if (table.find(tod, hit) or 0) - 1 ~= -1 then
					return nil
				end
				table.insert(tod, hit)
			end
			for _k, _v in ipairs(_gett) do
				_arg0_1(_v, _k - 1, _gett)
			end
			local c = v:Clone()
			c.Parent = v.Parent
			local _existingImpacts = existingImpacts
			local _c = c
			table.insert(_existingImpacts, _c)
		end
		for _k, _v in ipairs(parts) do
			_arg0(_v, _k - 1, parts)
		end
		local _tod = tod
		local _arg0_1 = function(hit)
			newThread(function()
				local original = originalMap[hit]
				if not original then
					local pz = hit:Clone()
					local c = hit:SubtractAsync(parts, Enum.CollisionFidelity.PreciseConvexDecomposition)
					local _originalMap = originalMap
					local _c = c
					local _pz = pz
					_originalMap[_c] = _pz
					c.Name = hit.Name
					c.Position = hit.Position
					local p = hit.Parent
					hit:Destroy()
					c.Parent = p
				else
					local c = original:SubtractAsync(existingImpacts, Enum.CollisionFidelity.PreciseConvexDecomposition)
					c.Name = hit.Name
					c.Position = hit.Position
					local p = hit.Parent
					hit:Destroy()
					c.Parent = p
				end
			end)
		end
		for _k, _v in ipairs(_tod) do
			_arg0_1(_v, _k - 1, _tod)
		end
	end
	_container.bulk = bulk
end
return breach
