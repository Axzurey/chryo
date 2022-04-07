-- Compiled with roblox-ts v1.3.3
local pattern
do
	pattern = {}
	function pattern:constructor()
	end
	function pattern:match(str, patterns)
		local matches = {}
		for i, v in pairs(patterns) do
			local match = { string.match(str, v) }
			local _value = match[1]
			if _value ~= 0 and (_value == _value and (_value ~= "" and _value)) then
				matches[i] = v
			end
		end
		return matches
	end
end
return {
	default = pattern,
}
