-- Compiled with roblox-ts v1.3.3
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
			if i == "$className" then
				continue
			end
			if i == "$properties" and x then
				for r, t in pairs(v) do
					x[r] = t
				end
			elseif typeof(v) == "table" then
				self:createTree(container, v)
			end
			--[[
				else if(typeOf(v) === 'string' && !container[i as keyof typeof container]) {
				let n = new Instance(v as keyof CreatableInstances);
				n.Parent = x;
				}
			]]
		end
		if x then
			x.Parent = container
		end
		return container
	end
	function tree:createFolder(name, parent)
		local l = Instance.new("Folder")
		l.Name = name
		l.Parent = parent
		return l
	end
end
return {
	default = tree,
}
