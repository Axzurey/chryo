-- Compiled with roblox-ts v1.3.3
local path
do
	path = {}
	function path:constructor()
	end
	function path:getInstance(pathlike)
		local paths = string.split(pathlike, "//")
		local inst = game
		local err = false
		for i, v in pairs(paths) do
			local t = inst:FindFirstChild(v)
			if t then
				inst = t
			else
				err = true
				break
			end
		end
		return if err then nil else inst
	end
	function path:sure(pathlike)
		local i = self:getInstance(pathlike)
		if not i then
			error(pathlike .. " is an invalid path")
		end
		return i
	end
	function path:join(...)
		local pathlike = { ... }
		local l = ""
		local _arg0 = function(v, i)
			if i == 0 then
				l = v
			else
				l = l .. ("//" .. v)
			end
		end
		for _k, _v in ipairs(pathlike) do
			_arg0(_v, _k - 1, pathlike)
		end
		return l
	end
end
return {
	default = path,
}
