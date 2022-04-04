-- Compiled with roblox-ts v1.3.3
local treex = {
	["$className"] = "Folder",
	["$properties"] = {
		Name = "helo!",
	},
	hello = {
		["$className"] = "Part",
		cookies = "Folder",
		["$properties"] = {
			Color = Color3.fromRGB(1, 1, 1),
		},
	},
}
local tree
do
	tree = {}
	function tree:constructor()
	end
	function tree:createTree(container, tree)
		local l = tree["$className"]
		local x
		if l then
			x = Instance.new(l)
		end
		for i, v in pairs(tree) do
			if i == "$properties" and x then
				for r, t in pairs(v) do
					x[r] = t
				end
			elseif typeof(v) == "table" then
				local n = self:createTree(container, v)
				n.Parent = x
			else
				local _condition = typeof(v) == "string"
				if _condition then
					local _value = container[i]
					_condition = not (_value ~= 0 and (_value == _value and (_value ~= "" and _value)))
				end
				if _condition then
					local n = Instance.new(v)
					n.Parent = x
				end
			end
		end
		return container
	end
	function tree:createFolder(name, parent)
		local l = Instance.new("Folder")
		l.Name = name
		return l
	end
end
return {
	default = tree,
}
