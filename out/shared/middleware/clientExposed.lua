-- Compiled with roblox-ts v1.3.3
local clientExposed
do
	clientExposed = {}
	function clientExposed:constructor()
	end
	function clientExposed:getCamera()
		if not self.camera then
			error("camera has not been set!")
		end
		return self.camera
	end
	function clientExposed:setCamera(camera)
		self.camera = camera
	end
	function clientExposed:getBaseWalkSpeed()
		return self.baseWalkspeed
	end
	function clientExposed:setBaseWalkSpeed(speed)
		self.baseWalkspeed = speed
	end
	function clientExposed:getActionController()
		return self.actionController
	end
	function clientExposed:setActionController(actionController)
		self.actionController = actionController
	end
end
return {
	default = clientExposed,
}
