-- Compiled with roblox-ts v1.3.3
local positionTracker = {}
do
	local _container = positionTracker
	local playerInfo = {}
	local maximum_distance_per_second = 20
	local function addPlayer(player)
		playerInfo[player.UserId] = {
			ignoreNext = true,
			position = CFrame.new(),
			delta = 0,
		}
	end
	_container.addPlayer = addPlayer
	local function removePlayer(player)
		playerInfo[player.UserId] = nil
	end
	_container.removePlayer = removePlayer
	local function setPosition(player, cframe)
		local dir = playerInfo[player.UserId]
		local now = tick()
		local delta = dir.delta
		local lastpos = dir.position
		local ignorenext = dir.ignoreNext
		if ignorenext then
			dir.ignoreNext = false
			dir.position = cframe
			dir.delta = now
			return true
		end
		local diff = now - delta
		local _position = lastpos.Position
		local _position_1 = cframe.Position
		local posdiff = _position - _position_1
		local _posdiff = posdiff
		local _diff = diff
		local diffASecond = (_posdiff / _diff).Magnitude
		if diffASecond > maximum_distance_per_second then
			print("too fast!")
			return false
		end
		dir.delta = now
		dir.position = cframe
		return true
	end
	_container.setPosition = setPosition
end
return positionTracker
