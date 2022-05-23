-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local UserInputService = _services.UserInputService
local RunService = _services.RunService
local comboOutcome
do
	local _inverse = {}
	comboOutcome = setmetatable({}, {
		__index = _inverse,
	})
	comboOutcome.timeout = "combo took too long to initialize"
	_inverse["combo took too long to initialize"] = "timeout"
	comboOutcome.chainTimeout = "combo chain took too long"
	_inverse["combo chain took too long"] = "chainTimeout"
	comboOutcome.success = "combo was successful"
	_inverse["combo was successful"] = "success"
	comboOutcome.chainBroken = "combo chain was broken"
	_inverse["combo chain was broken"] = "chainBroken"
end
local holdOutcome
do
	local _inverse = {}
	holdOutcome = setmetatable({}, {
		__index = _inverse,
	})
	holdOutcome.timeout = "key hold took too long to initialize"
	_inverse["key hold took too long to initialize"] = "timeout"
	holdOutcome.success = "key hold was successful"
	_inverse["key hold was successful"] = "success"
	holdOutcome.liftedEarly = "key hold was lifted early"
	_inverse["key hold was lifted early"] = "liftedEarly"
end
local key
do
	key = {}
	function key:constructor()
	end
	function key:waitForKeyUp(config)
		return TS.Promise.new(function(resolve, reject)
			local target = config.key
			local start = tick()
			local c2
			local c1
			local _value = config.maxLength
			if _value ~= 0 and (_value == _value and _value) then
				c2 = RunService.RenderStepped:Connect(function()
					if tick() - start >= config.maxLength then
						c1:Disconnect()
						c2:Disconnect()
						resolve(tick() - start)
					elseif config.onUpdate then
						config.onUpdate(tick() - start)
					end
				end)
			end
			c1 = UserInputService.InputEnded:Connect(function(input)
				if target.EnumType == Enum.KeyCode and input.KeyCode == target or target.EnumType == Enum.UserInputType and input.UserInputType == target then
					c1:Disconnect()
					local _result = c2
					if _result ~= nil then
						_result:Disconnect()
					end
					resolve(tick() - start)
				end
			end)
		end)
	end
	function key:keyHold(config)
		return TS.Promise.new(function(resolve, reject)
			local target = config.key
			local started = false
			local t = tick()
			local c1
			local _value = config.cancelOnHoldNotInitiatedAfter
			if _value ~= 0 and (_value == _value and _value) then
				local r
				r = RunService.RenderStepped:Connect(function()
					if started then
						r:Disconnect()
						return nil
					end
					if tick() - t >= config.cancelOnHoldNotInitiatedAfter then
						r:Disconnect()
						c1:Disconnect()
					end
				end)
			end
			c1 = UserInputService.InputBegan:Connect(function(input, gp)
				if gp then
					return nil
				end
				started = true
				if target.EnumType == Enum.KeyCode and input.KeyCode == target or target.EnumType == Enum.UserInputType and input.UserInputType == target then
					local start = tick()
					local c2
					c2 = UserInputService.InputEnded:Connect(function(input)
						if target.EnumType == Enum.KeyCode and input.KeyCode == target or target.EnumType == Enum.UserInputType and input.UserInputType == target then
							c2:Disconnect()
							if tick() - start < config.length then
								reject(holdOutcome.liftedEarly)
							end
						end
					end)
					local rs
					rs = RunService.RenderStepped:Connect(function()
						if tick() - start > config.length then
							c2:Disconnect()
							rs:Disconnect()
							resolve(holdOutcome.success)
						end
					end)
					c1:Disconnect()
				end
			end)
		end)
	end
	function key:keyCombo(config)
		return TS.Promise.new(function(resolve, reject)
			local lastcall = tick()
			local currentIndex = 0
			local connection, step
			step = RunService.RenderStepped:Connect(function()
				local _condition = config.cancelOnChainNotInitiatedAfter
				if _condition ~= 0 and (_condition == _condition and _condition) then
					_condition = currentIndex == 0 and tick() - lastcall > config.cancelOnChainNotInitiatedAfter
				end
				if _condition ~= 0 and (_condition == _condition and _condition) then
					connection:Disconnect()
					step:Disconnect()
					reject(comboOutcome.timeout)
				end
			end)
			connection = UserInputService.InputBegan:Connect(function(input, gp)
				if gp then
					return nil
				end
				local _exp = tick() - lastcall
				local _condition = config.timeSpacing
				if not (_condition ~= 0 and (_condition == _condition and _condition)) then
					_condition = 1
				end
				if _exp < _condition then
					local target = config.keys[currentIndex + 1]
					if (target.EnumType == Enum.KeyCode and input.KeyCode == target) or (target.EnumType == Enum.UserInputType and input.UserInputType == target) then
						lastcall = tick()
						currentIndex += 1
						if currentIndex >= #config.keys then
							connection:Disconnect()
							resolve(comboOutcome.success)
						end
					elseif config.cancelOnKeyChainBroken then
						reject(comboOutcome.chainBroken)
					end
				else
					reject(comboOutcome.chainTimeout)
				end
			end)
		end)
	end
end
return {
	comboOutcome = comboOutcome,
	holdOutcome = holdOutcome,
	default = key,
}
