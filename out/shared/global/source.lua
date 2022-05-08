-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local image = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "classes", "image").default
local source = {}
do
	local _container = source
	local images = {
		bullet_hole_default = image:create("rbxassetid://9570940144", Vector2.new(.5, .5)),
		bullet_hole_glass = image:create("rbxassetid://9570939806", Vector2.new(.5, .5)),
		crosshair_default = image:create("rbxassetid://9571407023", Vector2.new(1, 1)),
	}
	_container.images = images
end
return source
