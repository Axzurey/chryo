-- Compiled with roblox-ts v1.3.3
local clientExposed = {}
do
	local _container = clientExposed
	local camera
	local baseWalkspeed
	local actionController
	local function getCamera()
		if not camera then
			error("camera has not been set!")
		end
		return camera
	end
	_container.getCamera = getCamera
	local function setCamera(_camera)
		camera = _camera
	end
	_container.setCamera = setCamera
	local function getBaseWalkSpeed()
		return baseWalkspeed
	end
	_container.getBaseWalkSpeed = getBaseWalkSpeed
	local function setBaseWalkSpeed(speed)
		baseWalkspeed = speed
	end
	_container.setBaseWalkSpeed = setBaseWalkSpeed
	local function getActionController()
		return actionController
	end
	_container.getActionController = getActionController
	local function setActionController(_actionController)
		actionController = _actionController
	end
	_container.setActionController = setActionController
end
return clientExposed
