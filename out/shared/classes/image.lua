-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local path = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "path").default
local directory = path:createIfMissing("Workspace//imageSource", "Folder")
local image
do
	image = setmetatable({}, {
		__tostring = function()
			return "image"
		end,
	})
	image.__index = image
	function image.new(...)
		local self = setmetatable({}, image)
		return self:constructor(...) or self
	end
	function image:constructor(imageId, size, explicitColor, transparency)
		if transparency == nil then
			transparency = 0
		end
		self.imageId = imageId
		self.size = size
		self.explicitColor = explicitColor
		self.transparency = transparency
	end
	function image:create(imageId, size, explicitColor, transparency)
		if explicitColor == nil then
			explicitColor = Color3.new(1, 1, 1)
		end
		if transparency == nil then
			transparency = 0
		end
		return image.new(imageId, size, explicitColor, transparency)
	end
	function image:toLabel(at, rotation, scale, parent)
		local inst = Instance.new("ImageLabel")
		inst.Name = "image"
		inst.AnchorPoint = Vector2.new(.5, .5)
		inst.Position = UDim2.fromOffset(at.X, at.Y)
		inst.Size = UDim2.fromOffset(self.size.X * scale, self.size.Y * scale)
		inst.Rotation = rotation
		inst.Transparency = self.transparency
		inst.Parent = parent
		return {
			destroy = function()
				inst:Destroy()
			end,
			transform = function(_at, _rotation, _scale)
				if _at then
					inst.Position = UDim2.fromOffset(_at.X, _at.Y)
				end
				if _rotation ~= 0 and (_rotation == _rotation and _rotation) then
					inst.Rotation = _rotation
				end
				if _scale ~= 0 and (_scale == _scale and _scale) then
					inst.Size = UDim2.fromOffset(self.size.X * _scale, self.size.Y * _scale)
				end
			end,
			changeTransparency = function(newTransparency)
				inst.Transparency = self.transparency
			end,
			getInstance = function()
				return inst
			end,
		}
	end
	function image:spawn(at, direction, scale)
		local back = Instance.new("Part")
		back.Name = "imageBackdrop"
		back.CanCollide = false
		back.CanTouch = false
		back.CanQuery = false
		back.Anchored = true
		back.Transparency = 1
		back.CFrame = CFrame.lookAt(at, at + direction)
		back.Size = Vector3.new(self.size.X * scale, self.size.Y * scale, 0)
		back.Parent = directory
		local inst = Instance.new("Decal")
		inst.Name = "image"
		inst.Color3 = self.explicitColor
		inst.Texture = self.imageId
		inst.Transparency = self.transparency
		inst.Parent = back
		return {
			destroy = function()
				back:Destroy()
			end,
			transform = function(_at, _direction, _scale)
				if _at then
					local _fn = CFrame
					local _lookVector = back.CFrame.LookVector
					back.CFrame = _fn.lookAt(_at, at + _lookVector)
				end
				if _direction then
					back.CFrame = CFrame.lookAt(back.Position, back.Position + _direction)
				end
				if _scale ~= 0 and (_scale == _scale and _scale) then
					back.Size = Vector3.new(self.size.X * _scale, self.size.Y * _scale, 0)
				end
			end,
			changeTransparency = function(newTransparency)
				inst.Transparency = newTransparency
			end,
			getInstance = function()
				return back
			end,
		}
	end
end
return {
	default = image,
}
