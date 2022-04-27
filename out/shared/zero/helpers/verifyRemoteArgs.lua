-- Compiled with roblox-ts v1.3.3
local function verifyRemoteArgs(args, verify)
	local i = 0
	for _, value in ipairs(verify) do
		local against = args[i + 1]
		if not value(against) then
			return false
		end
		i += 1
	end
	return true
end
return {
	default = verifyRemoteArgs,
}
