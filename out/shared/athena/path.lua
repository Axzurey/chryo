-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local pattern = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "athena", "pattern").default
local path
do
	path = {}
	function path:constructor()
	end
	function path:exists(pathlike)
		return if self:getInstance(pathlike) then true else false
	end
	function path:last(pathlike)
		pathlike = string.split(pathlike, "&")[1]
		local paths = string.split(pathlike, "//")
		return paths[#paths - 1 + 1]
	end
	function path:getInstance(pathlike)
		pathlike = string.split(pathlike, "&")[1]
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
		-- now make it accept args that tell like if it's of a certain class or smth
		local i = self:getInstance(pathlike)
		if not i then
			error(pathlike .. " is an invalid path")
		end
		local matches = pattern:match(pathlike, {
			classMust = "&class:%a+",
		})
		local _condition = matches.classMust
		if _condition ~= "" and _condition then
			_condition = i.ClassName ~= matches.classMust
		end
		if _condition ~= "" and _condition then
			error("instance found does not match class " .. (matches.classMust .. (". it has class " .. i.ClassName)))
		end
		return i
	end
	function path:createIfMissing(pathlike, classType)
		pathlike = string.split(pathlike, "&")[1]
		local paths = string.split(pathlike, "//")
		local inst = game
		for i, v in pairs(paths) do
			local t = inst:FindFirstChild(v)
			if t then
				inst = t
			else
				print(i, paths)
				if i == #paths then
					print("last one!")
					local n = Instance.new(classType)
					n.Name = v
					n.Parent = inst
					inst = n
				else
					error("unable to create path " .. (pathlike .. (". " .. (paths[#paths - 1 + 1] .. " is too deeply nested in non-existing instances"))))
				end
				break
			end
		end
		return inst
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
